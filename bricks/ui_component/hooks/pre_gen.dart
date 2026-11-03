import 'dart:io';

import 'package:mason/mason.dart';

void run(HookContext context) {
  final pubspec = File('pubspec.yaml');
  if (!pubspec.existsSync()) {
    throw StateError('Run `mason make ui_component` from the Flutter project root.');
  }
  final package = RegExp(r'^name:\s*(\S+)', multiLine: true)
      .firstMatch(pubspec.readAsStringSync())
      ?.group(1);

  var name = (context.vars['name'] as String).trim().snakeCase;
  if (name.startsWith('app_')) name = name.substring(4);
  if (File('lib/shared/ui/components/app_$name.dart').existsSync()) {
    throw StateError('App${name.pascalCase} already exists. Extend it with a named constructor instead.');
  }

  final base = (context.vars['base'] as String).trim();
  final hasBase = base.isNotEmpty && base != 'none';

  context.vars = {
    ...context.vars,
    'name': name,
    'package': package,
    'has_base': hasBase,
    'base': hasBase ? base : '-',
  };
}
