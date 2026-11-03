import 'dart:io';

import 'package:mason/mason.dart';

Future<void> run(HookContext context) async {
  final name = context.vars['name'] as String;
  final base = context.vars['base'] as String;
  final file = 'components/app_$name.dart';

  final registry = File('lib/shared/ui/COMPONENTS.md');
  const rowMarker = '<!-- [components]';
  if (registry.existsSync() && registry.readAsStringSync().contains(rowMarker)) {
    final text = registry.readAsStringSync();
    registry.writeAsStringSync(
      text.replaceFirst(
        rowMarker,
        '| App${name.pascalCase} | $file | $base | TODO: what it is for | TODO: variants / key params |\n$rowMarker',
      ),
    );
  } else {
    context.logger.warn('COMPONENTS.md marker missing - register App${name.pascalCase} manually.');
  }

  final barrel = File('lib/shared/ui/ui.dart');
  const exportMarker = '// [ui-exports]';
  if (barrel.existsSync() && barrel.readAsStringSync().contains(exportMarker)) {
    final lines = barrel.readAsStringSync().split('\n');
    final markerAt = lines.indexWhere((l) => l.startsWith(exportMarker));
    lines.insert(markerAt, "export '$file';");
    // Keep the component exports sorted (directives_ordering).
    final idx = <int>[
      for (var i = 0; i < lines.length; i++)
        if (lines[i].startsWith("export 'components/")) i,
    ];
    final sorted = idx.map((i) => lines[i]).toList()..sort();
    for (var j = 0; j < idx.length; j++) {
      lines[idx[j]] = sorted[j];
    }
    barrel.writeAsStringSync(lines.join('\n'));
  } else {
    context.logger.warn('ui.dart marker missing - export $file manually.');
  }

  for (final dir in ['lib/shared/ui', 'test/shared/ui']) {
    await Process.run('dart', ['fix', '--apply', dir], runInShell: true);
  }
  await Process.run('dart', ['format', 'lib/shared/ui', 'test/shared/ui'], runInShell: true);

  context.logger
    ..success('App${name.pascalCase} created in lib/shared/ui/$file')
    ..info('Next: implement it, replace the two TODOs in its COMPONENTS.md row (make check fails until you do), then `make check`.');
}
