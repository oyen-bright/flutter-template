import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:{{package}}/core/result/result.dart';
import 'package:{{package}}/features/{{name}}/data/models/{{name}}_model.dart';
import 'package:{{package}}/features/{{name}}/data/repositories/{{impl_file}}';
import 'package:{{package}}/features/{{name}}/data/sources/{{name}}_remote_data_source.dart';
{{#domain}}import 'package:{{package}}/features/{{name}}/domain/entities/{{name}}.dart';{{/domain}}

class _MockRemote extends Mock implements {{name.pascalCase()}}RemoteDataSource {}

void main() {
  late _MockRemote remote;
  late {{impl_type}} repository;

  setUp(() {
    remote = _MockRemote();
    repository = {{impl_type}}(remote);
  });

  test('returns Ok with the items', () async {
    when(() => remote.fetchAll()).thenAnswer(
      (_) async => const [{{name.pascalCase()}}Model(id: '1', name: 'First')],
    );

    final result = await repository.fetchAll();

    expect(
      result,
      isA<Ok<List<{{data_type}}>>>().having((r) => r.data.single.id, 'id', '1'),
    );
  });

  test('returns Err instead of throwing when the source fails', () async {
    when(() => remote.fetchAll()).thenThrow(Exception('boom'));

    final result = await repository.fetchAll();

    expect(result, isA<Err<List<{{data_type}}>>>());
  });
}
