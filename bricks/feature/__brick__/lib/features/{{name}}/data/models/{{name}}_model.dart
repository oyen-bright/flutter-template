import 'package:equatable/equatable.dart';
{{#domain}}import 'package:{{package}}/features/{{name}}/domain/entities/{{name}}.dart';{{/domain}}

/// API shape of a {{name.sentenceCase()}}. Replace the placeholder fields with the real response.
class {{name.pascalCase()}}Model extends Equatable {
  const {{name.pascalCase()}}Model({required this.id, required this.name});

  factory {{name.pascalCase()}}Model.fromJson(Map<String, dynamic> json) =>
      {{name.pascalCase()}}Model(
        id: json['id'].toString(),
        name: json['name'] as String? ?? '',
      );
{{#domain}}
  factory {{name.pascalCase()}}Model.fromEntity({{name.pascalCase()}} entity) =>
      {{name.pascalCase()}}Model(id: entity.id, name: entity.name);
{{/domain}}
  final String id;
  final String name;

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
{{#domain}}
  {{name.pascalCase()}} toEntity() => {{name.pascalCase()}}(id: id, name: name);
{{/domain}}
  @override
  List<Object?> get props => [id, name];
}
