import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
{{#persist}}import 'package:hydrated_bloc/hydrated_bloc.dart';{{/persist}}
import 'package:mocktail/mocktail.dart';
import 'package:{{package}}/core/error/failure.dart';
import 'package:{{package}}/core/result/result.dart';
import 'package:{{package}}/features/{{name}}/{{{data_import}}}';
import 'package:{{package}}/features/{{name}}/{{{repo_import}}}';
import 'package:{{package}}/features/{{name}}/presentation/cubit/{{name}}_cubit.dart';

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

  group('{{name.pascalCase()}}Cubit', () {
    test('starts in Initial', () {
      expect({{name.pascalCase()}}Cubit(repository).state, const {{name.pascalCase()}}Initial());
    });

    blocTest<{{name.pascalCase()}}Cubit, {{name.pascalCase()}}State>(
      'emits [Loading, Loaded] when the repository succeeds',
      setUp: () => when(() => repository.fetchAll()).thenAnswer((_) async => const Ok([item])),
      build: () => {{name.pascalCase()}}Cubit(repository),
      act: (cubit) => cubit.load(),
      expect: () => const [{{name.pascalCase()}}Loading(), {{name.pascalCase()}}Loaded([item])],
    );

    blocTest<{{name.pascalCase()}}Cubit, {{name.pascalCase()}}State>(
      'emits [Loading, Failure] when the repository fails',
      setUp: () => when(() => repository.fetchAll()).thenAnswer((_) async => const Err(UnknownFailure())),
      build: () => {{name.pascalCase()}}Cubit(repository),
      act: (cubit) => cubit.load(),
      expect: () => const [{{name.pascalCase()}}Loading(), {{name.pascalCase()}}Failure(UnknownFailure())],
    );
  });
}
