import 'dart:io';

import 'package:mason/mason.dart';

Future<void> run(HookContext context) async {
  final name = (context.vars['project_name'] as String).snakeCase;
  final org = context.vars['org'] as String;
  final dir = Directory(name).absolute.path;

  Future<bool> step(String label, String exe, List<String> args) async {
    final progress = context.logger.progress(label);
    final result = await Process.run(exe, args, workingDirectory: dir, runInShell: true);
    if (result.exitCode != 0) {
      progress.fail('$label failed');
      context.logger.err('${result.stdout}\n${result.stderr}');
      return false;
    }
    progress.complete(label);
    return true;
  }

  // Adds android/ and ios/ around the generated lib/; existing files are kept.
  if (!await step('flutter create (platforms)', 'flutter', [
    'create', '--org', org, '--project-name', name, '--platforms', 'android,ios', '.',
  ])) {
    return;
  }

  // flutter create adds a counter-app test that doesn't apply to this app.
  final counterTest = File('$dir/test/widget_test.dart');
  if (counterTest.existsSync()) counterTest.deleteSync();

  if (!await step('flutter pub get', 'flutter', ['pub', 'get'])) return;
  await step('mason get', 'mason', ['get']);
  if (!await step('build_runner', 'dart', [
    'run', 'build_runner', 'build', '--delete-conflicting-outputs',
  ])) {
    return;
  }
  // Import order depends on the package name, so it is fixed after generation.
  await step('dart fix', 'dart', ['fix', '--apply']);
  await step('dart format', 'dart', ['format', 'lib', 'test', 'tool']);

  context.logger
    ..success('\n$name is ready.')
    ..info('  cd $name && make check')
    ..info('  make feature NAME=<name> TYPE=<cubit|bloc>');
}
