{{#persist}}import 'package:hydrated_bloc/hydrated_bloc.dart';{{/persist}}{{^persist}}import 'package:bloc/bloc.dart';{{/persist}}
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:{{package}}/core/error/failure.dart';
import 'package:{{package}}/features/{{name}}/{{{data_import}}}';
import 'package:{{package}}/features/{{name}}/{{{repo_import}}}';
{{#persist}}{{#domain}}import 'package:{{package}}/features/{{name}}/data/models/{{name}}_model.dart';{{/domain}}{{/persist}}

part '{{name}}_state.dart';

// Cubit: <why a Cubit fits - see AGENTS.md section 2>
@injectable
class {{name.pascalCase()}}Cubit extends {{#persist}}HydratedCubit{{/persist}}{{^persist}}Cubit{{/persist}}<{{name.pascalCase()}}State> {
  {{name.pascalCase()}}Cubit(this._repository) : super(const {{name.pascalCase()}}Initial());

  final {{name.pascalCase()}}Repository _repository;

  Future<void> load() async {
    {{#persist}}// Keep showing cached data while refreshing.
    if (state is! {{name.pascalCase()}}Loaded) emit(const {{name.pascalCase()}}Loading());{{/persist}}{{^persist}}emit(const {{name.pascalCase()}}Loading());{{/persist}}
    final result = await _repository.fetchAll();
    emit(
      result.fold<{{name.pascalCase()}}State>(
        onSuccess: {{name.pascalCase()}}Loaded.new,
        onFailure: {{name.pascalCase()}}Failure.new,
      ),
    );
  }
{{#persist}}
  @override
  {{name.pascalCase()}}State? fromJson(Map<String, dynamic> json) {
    final items = json['items'];
    if (items is! List) return null;
    return {{name.pascalCase()}}Loaded(
      items
          .map((e) => {{name.pascalCase()}}Model.fromJson(e as Map<String, dynamic>){{#domain}}.toEntity(){{/domain}})
          .toList(),
    );
  }

  @override
  Map<String, dynamic>? toJson({{name.pascalCase()}}State state) => switch (state) {
    {{name.pascalCase()}}Loaded(:final items) => {
      'items': items.map((e) => {{#domain}}{{name.pascalCase()}}Model.fromEntity(e).toJson(){{/domain}}{{^domain}}e.toJson(){{/domain}}).toList(),
    },
    _ => null,
  };
{{/persist}}
}
