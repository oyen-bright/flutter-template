import 'package:{{package}}/core/result/result.dart';
import 'package:{{package}}/features/{{name}}/domain/entities/{{name}}.dart';

/// Every method returns a [Result] and never throws.
// ignore: one_member_abstracts
abstract interface class {{name.pascalCase()}}Repository {
  Future<Result<List<{{name.pascalCase()}}>>> fetchAll();
}
