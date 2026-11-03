part of '{{name}}_bloc.dart';

/// One event per user intent. Name them in the past tense of what happened.
sealed class {{name.pascalCase()}}Event extends Equatable {
  const {{name.pascalCase()}}Event();

  @override
  List<Object?> get props => [];
}

/// The screen asked for data (first load, pull-to-refresh, retry).
final class {{name.pascalCase()}}Requested extends {{name.pascalCase()}}Event {
  const {{name.pascalCase()}}Requested();
}
