// Enforces the architecture rules in AGENTS.md. Run: `dart run tool/check_structure.dart`
// Exits 1 on any violation so CI and agents cannot skip it.
// ignore_for_file: avoid_print
import 'dart:io';

const _maxLines = 400;
const _warnLines = 300;

const _allowedTopLevel = {'app', 'core', 'shared', 'features', 'gen', 'l10n'};
const _allowedTopLevelFiles = {'main.dart', 'bootstrap.dart', 'firebase_options.dart'};
const _allowedLayers = {
  'data': {'models', 'sources', 'repositories'},
  'domain': {'entities', 'repositories', 'usecases'},
  'presentation': {'cubit', 'bloc', 'pages', 'widgets'},
};

final _errors = <String>[];
final _warnings = <String>[];

void main() {
  final lib = Directory('lib');
  if (!lib.existsSync()) {
    stderr.writeln('Run from the project root.');
    exit(2);
  }

  for (final entity in lib.listSync()) {
    final name = entity.uri.pathSegments.where((s) => s.isNotEmpty).last;
    if (entity is Directory && !_allowedTopLevel.contains(name)) {
      _errors.add('lib/$name/ is not allowed. Top level is: ${_allowedTopLevel.join(', ')}.');
    }
    if (entity is File && !_allowedTopLevelFiles.contains(name)) {
      _errors.add('lib/$name must live inside app/, core/, shared/ or features/.');
    }
  }

  _checkFeatureFolders();
  _checkComponentRegistry();

  for (final file in lib.listSync(recursive: true).whereType<File>()) {
    final path = file.path.replaceAll(r'\', '/');
    if (!path.endsWith('.dart') || _isGenerated(path)) continue;
    _checkFile(path, file.readAsLinesSync());
  }

  for (final w in _warnings) {
    print('warning: $w');
  }
  if (_errors.isEmpty) {
    print('structure ok (${_warnings.length} warnings)');
    return;
  }
  for (final e in _errors) {
    print('error: $e');
  }
  print('\n${_errors.length} structure violation(s). See AGENTS.md.');
  exit(1);
}

bool _isGenerated(String path) =>
    path.endsWith('.g.dart') || path.endsWith('.config.dart') || path.startsWith('lib/gen/');

void _checkFeatureFolders() {
  final features = Directory('lib/features');
  if (!features.existsSync()) return;
  for (final feature in features.listSync().whereType<Directory>()) {
    final featureName = feature.uri.pathSegments.where((s) => s.isNotEmpty).last;
    for (final entity in feature.listSync()) {
      final name = entity.uri.pathSegments.where((s) => s.isNotEmpty).last;
      if (entity is File) {
        _errors.add('lib/features/$featureName/$name: files must be inside data/, domain/ or presentation/.');
        continue;
      }
      final allowedSub = _allowedLayers[name];
      if (allowedSub == null) {
        _errors.add('lib/features/$featureName/$name/: only data/, domain/, presentation/ are allowed.');
        continue;
      }
      for (final sub in (entity as Directory).listSync()) {
        final subName = sub.uri.pathSegments.where((s) => s.isNotEmpty).last;
        if (sub is Directory && !allowedSub.contains(subName)) {
          _errors.add('lib/features/$featureName/$name/$subName/: allowed here: ${allowedSub.join(', ')}.');
        }
        if (sub is File && subName != '.gitkeep') {
          _errors.add('lib/features/$featureName/$name/$subName: put it in one of ${allowedSub.join(', ')}.');
        }
      }
    }
  }
}

void _checkComponentRegistry() {
  final registry = File('lib/shared/ui/COMPONENTS.md');
  final components = Directory('lib/shared/ui/components');
  if (!components.existsSync()) return;
  final text = registry.existsSync() ? registry.readAsStringSync() : '';
  for (final row in text.split('\n').where((l) => l.startsWith('| App') && l.contains('TODO'))) {
    _errors.add('COMPONENTS.md row still has TODOs - describe the component: ${row.split('|')[1].trim()}');
  }
  for (final file in components.listSync().whereType<File>()) {
    final name = file.uri.pathSegments.last;
    if (name.endsWith('.dart') && !text.contains('components/$name')) {
      _errors.add('lib/shared/ui/components/$name is not listed in lib/shared/ui/COMPONENTS.md.');
    }
  }
}

void _checkFile(String path, List<String> lines) {
  final imports = lines.where((l) => l.startsWith('import ')).toList();
  final segments = path.split('/');
  final inFeature = segments.length > 3 && segments[1] == 'features';
  final feature = inFeature ? segments[2] : null;
  final layer = inFeature && segments.length > 4 ? segments[3] : null;
  final isStateHolder = path.contains('/presentation/cubit/') || path.contains('/presentation/bloc/');

  if (lines.length > _maxLines) {
    _errors.add('$path has ${lines.length} lines (max $_maxLines). Split it.');
  } else if (lines.length > _warnLines) {
    _warnings.add('$path has ${lines.length} lines; consider splitting.');
  }

  if (!inFeature) return;

  for (final line in imports) {
    if (line.contains('package:shadcn_ui/')) {
      _errors.add('$path imports shadcn_ui directly. Import shared/ui/ui.dart (wrap missing components with `mason make ui_component`).');
    }
    if ((layer == 'presentation' || layer == 'domain') && line.contains('package:dio/')) {
      _errors.add('$path ($layer) imports dio. Network code belongs in data/sources.');
    }
    if (layer == 'domain' && (line.contains('package:flutter/') || line.contains('/data/'))) {
      _errors.add('$path: domain must not import Flutter or the data layer.');
    }
    if (layer == 'presentation' && line.contains('/data/sources/')) {
      _errors.add('$path: presentation must go through the repository, not data sources.');
    }
    final other = RegExp(r'/features/(\w+)/(data|presentation)/').firstMatch(line);
    if (other != null && other.group(1) != feature) {
      _errors.add('$path imports ${other.group(1)}/${other.group(2)}. Cross-feature imports may only use domain/.');
    }
    if (isStateHolder && (line.contains('package:flutter/material.dart') || line.contains('/shared/ui/'))) {
      _errors.add('$path: blocs/cubits must not import UI. Side effects go in a BlocListener.');
    }
  }

  for (var i = 0; i < lines.length; i++) {
    final line = lines[i];
    if (line.trimLeft().startsWith('//')) continue;
    if (RegExp(r'\bColor\(0x').hasMatch(line) || RegExp(r'\bColors\.(?!transparent)').hasMatch(line)) {
      _errors.add('$path:${i + 1} hardcoded color. Use context.colors.* (add tokens in shared/ui/theme).');
    }
    if (isStateHolder && RegExp(r'\btry\s*\{').hasMatch(line)) {
      _errors.add('$path:${i + 1} try/catch in a bloc/cubit. Repositories return Result via guard().');
    }
  }
}
