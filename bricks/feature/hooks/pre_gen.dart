import 'dart:io';

import 'package:mason/mason.dart';

void run(HookContext context) {
  final pubspec = File('pubspec.yaml');
  if (!pubspec.existsSync()) {
    throw StateError('Run `mason make feature` from the Flutter project root.');
  }
  final package = RegExp(r'^name:\s*(\S+)', multiLine: true)
      .firstMatch(pubspec.readAsStringSync())
      ?.group(1);
  if (package == null) throw StateError('Could not read the package name from pubspec.yaml.');

  final name = (context.vars['name'] as String).trim().snakeCase;
  if (name.isEmpty) throw StateError('Feature name is required.');
  if (Directory('lib/features/$name').existsSync()) {
    throw StateError('lib/features/$name already exists. Extend it instead (see the add-feature skill).');
  }

  final type = context.vars['type'] as String;
  final domain = context.vars['domain'] as bool;
  final pascal = name.pascalCase;

  context.vars = {
    ...context.vars,
    'name': name,
    'package': package,
    'is_bloc': type == 'bloc',
    'data_type': domain ? pascal : '${pascal}Model',
    'data_import': domain ? 'domain/entities/$name.dart' : 'data/models/${name}_model.dart',
    'repo_import': domain
        ? 'domain/repositories/${name}_repository.dart'
        : 'data/repositories/${name}_repository.dart',
    'impl_file': domain ? '${name}_repository_impl.dart' : '${name}_repository.dart',
    'impl_type': domain ? '${pascal}RepositoryImpl' : '${pascal}Repository',
  };
}
