import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:{{package}}/features/{{name}}/data/models/{{name}}_model.dart';

/// Talks to the API. May throw; the repository converts errors via `guard`.
@lazySingleton
class {{name.pascalCase()}}RemoteDataSource {
  {{name.pascalCase()}}RemoteDataSource(this._dio);

  final Dio _dio;

  static const _basePath = '/{{name.paramCase()}}';

  Future<List<{{name.pascalCase()}}Model>> fetchAll() async {
    final response = await _dio.get<Map<String, dynamic>>(_basePath);
    final items = response.data?['data'] as List<dynamic>? ?? const [];
    return items
        .map((json) => {{name.pascalCase()}}Model.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
