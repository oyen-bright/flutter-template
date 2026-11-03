{{#persist}}import 'package:hydrated_bloc/hydrated_bloc.dart';{{/persist}}{{^persist}}import 'package:bloc/bloc.dart';{{/persist}}
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:{{package}}/core/error/failure.dart';
import 'package:{{package}}/features/{{name}}/{{{data_import}}}';
import 'package:{{package}}/features/{{name}}/{{{repo_import}}}';
{{#persist}}{{#domain}}import 'package:{{package}}/features/{{name}}/data/models/{{name}}_model.dart';{{/domain}}{{/persist}}

part '{{name}}_event.dart';
part '{{name}}_state.dart';

// Bloc: <why a Bloc fits - transformer / streams / multi-step / audit, see AGENTS.md section 2>
@injectable
class {{name.pascalCase()}}Bloc extends {{#persist}}HydratedBloc{{/persist}}{{^persist}}Bloc{{/persist}}<{{name.pascalCase()}}Event, {{name.pascalCase()}}State> {
  {{name.pascalCase()}}Bloc(this._repository) : super(const {{name.pascalCase()}}Initial()) {
    // Pick a transformer for EVERY event:
    //   restartable() - newest wins (load, search)
    //   droppable()   - ignore while busy (submit, pay, OTP)
    //   sequential()  - run in order (queues)
    on<{{name.pascalCase()}}Requested>(_onRequested, transformer: restartable());
  }

  final {{name.pascalCase()}}Repository _repository;

  Future<void> _onRequested(
    {{name.pascalCase()}}Requested event,
    Emitter<{{name.pascalCase()}}State> emit,
  ) async {
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
