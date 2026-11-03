import 'dart:io';

import 'package:mason/mason.dart';

Future<void> run(HookContext context) async {
  final vars = context.vars;
  final name = vars['name'] as String;
  final package = vars['package'] as String;
  final isBloc = vars['is_bloc'] as bool;
  final feature = 'lib/features/$name';
  final testDir = 'test/features/$name';

  // The brick ships both variants; keep only the one that was chosen.
  final unused = isBloc ? 'cubit' : 'bloc';
  _delete('$feature/presentation/$unused');
  _delete('$testDir/presentation/${name}_${unused}_test.dart');
  if (!(vars['domain'] as bool)) _delete('$feature/domain');

  if (vars['route'] as bool) _registerRoute(context, name, package);

  // Import order depends on the package name, so it is fixed after generation.
  for (final dir in [feature, testDir, 'lib/app/router']) {
    await Process.run('dart', ['fix', '--apply', dir], runInShell: true);
  }
  await Process.run('dart', ['format', feature, testDir, 'lib/app/router'], runInShell: true);

  final kind = isBloc ? 'Bloc' : 'Cubit';
  context.logger
    ..success('Feature "$name" generated with a $kind.')
    ..info('Next: run `make gen`, write the reason for choosing a $kind in the class comment,')
    ..info('replace the placeholder fields, then `make check`.');
}

void _delete(String path) {
  final type = FileSystemEntity.typeSync(path);
  if (type == FileSystemEntityType.directory) Directory(path).deleteSync(recursive: true);
  if (type == FileSystemEntityType.file) File(path).deleteSync();
}

void _registerRoute(HookContext context, String name, String package) {
  final camel = name.camelCase;
  final pascal = name.pascalCase;

  final routes = File('lib/app/router/app_routes.dart');
  final router = File('lib/app/router/app_router.dart');
  if (!routes.existsSync() || !router.existsSync()) {
    context.logger.warn('Router files not found - add the route manually.');
    return;
  }

  final routesText = routes.readAsStringSync();
  const pathsMarker = '  // [feature-paths]';
  if (!routesText.contains(pathsMarker)) {
    context.logger.warn('[feature-paths] marker missing in app_routes.dart - add the route manually.');
    return;
  }
  routes.writeAsStringSync(
    routesText.replaceFirst(
      pathsMarker,
      "  static const $camel = '/${name.paramCase}';\n$pathsMarker",
    ),
  );

  var routerText = router.readAsStringSync();
  const routesMarker = '    // [feature-routes]';
  const importsMarker = '// [feature-imports]';
  if (!routerText.contains(routesMarker) || !routerText.contains(importsMarker)) {
    context.logger.warn('Markers missing in app_router.dart - add the route manually.');
    return;
  }
  routerText = routerText
      .replaceFirst(
        importsMarker,
        "import 'package:$package/features/$name/presentation/pages/${name}_page.dart';\n$importsMarker",
      )
      .replaceFirst(
        routesMarker,
        '    GoRoute(\n'
        '      path: AppRoutes.$camel,\n'
        "      name: '$camel',\n"
        '      builder: (_, _) => const ${pascal}Page(),\n'
        '    ),\n'
        '$routesMarker',
      );
  router.writeAsStringSync(_sortImports(routerText));
}

/// Keeps the import block sorted so `directives_ordering` stays clean.
String _sortImports(String source) {
  final lines = source.split('\n');
  final importIdx = <int>[];
  for (var i = 0; i < lines.length; i++) {
    if (lines[i].startsWith("import 'package:")) importIdx.add(i);
  }
  final sorted = importIdx.map((i) => lines[i]).toList()..sort();
  for (var j = 0; j < importIdx.length; j++) {
    lines[importIdx[j]] = sorted[j];
  }
  return lines.join('\n');
}
