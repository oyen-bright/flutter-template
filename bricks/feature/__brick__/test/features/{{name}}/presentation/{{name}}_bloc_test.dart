import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
{{#persist}}import 'package:hydrated_bloc/hydrated_bloc.dart';{{/persist}}
import 'package:mocktail/mocktail.dart';
import 'package:{{package}}/core/error/failure.dart';
import 'package:{{package}}/core/result/result.dart';
import 'package:{{package}}/features/{{name}}/{{{data_import}}}';
import 'package:{{package}}/features/{{name}}/{{{repo_import}}}';
import 'package:{{package}}/features/{{name}}/presentation/bloc/{{name}}_bloc.dart';

class _MockRepository extends Mock implements {{name.pascalCase()}}Repository {}
{{#persist}}
class _MockStorage extends Mock implements Storage {}
{{/persist}}
void main() {
  late _MockRepository repository;
  const item = {{data_type}}(id: '1', name: 'First');

  setUp(() {
    repository = _MockRepository();
{{#persist}}
    final storage = _MockStorage();
    when(() => storage.write(any(), any<dynamic>())).thenAnswer((_) async {});
    HydratedBloc.storage = storage;
{{/persist}}
  });

  group('{{name.pascalCase()}}Bloc', () {
    test('starts in Initial', () {
      expect({{name.pascalCase()}}Bloc(repository).state, const {{name.pascalCase()}}Initial());
    });

    blocTest<{{name.pascalCase()}}Bloc, {{name.pascalCase()}}State>(
      'emits [Loading, Loaded] on Requested when the repository succeeds',
      setUp: () => when(() => repository.fetchAll()).thenAnswer((_) async => const Ok([item])),
      build: () => {{name.pascalCase()}}Bloc(repository),
      act: (bloc) => bloc.add(const {{name.pascalCase()}}Requested()),
      expect: () => const [{{name.pascalCase()}}Loading(), {{name.pascalCase()}}Loaded([item])],
    );

    blocTest<{{name.pascalCase()}}Bloc, {{name.pascalCase()}}State>(
      'emits [Loading, Failure] on Requested when the repository fails',
      setUp: () => when(() => repository.fetchAll()).thenAnswer((_) async => const Err(UnknownFailure())),
      build: () => {{name.pascalCase()}}Bloc(repository),
      act: (bloc) => bloc.add(const {{name.pascalCase()}}Requested()),
      expect: () => const [{{name.pascalCase()}}Loading(), {{name.pascalCase()}}Failure(UnknownFailure())],
    );
  });
}
