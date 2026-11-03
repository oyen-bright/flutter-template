part of '{{name}}_cubit.dart';

sealed class {{name.pascalCase()}}State extends Equatable {
  const {{name.pascalCase()}}State();

  @override
  List<Object?> get props => [];
}

final class {{name.pascalCase()}}Initial extends {{name.pascalCase()}}State {
  const {{name.pascalCase()}}Initial();
}

final class {{name.pascalCase()}}Loading extends {{name.pascalCase()}}State {
  const {{name.pascalCase()}}Loading();
}

final class {{name.pascalCase()}}Loaded extends {{name.pascalCase()}}State {
  const {{name.pascalCase()}}Loaded(this.items);

  final List<{{data_type}}> items;

  @override
  List<Object?> get props => [items];
}

final class {{name.pascalCase()}}Failure extends {{name.pascalCase()}}State {
  const {{name.pascalCase()}}Failure(this.failure);

  final Failure failure;

  @override
  List<Object?> get props => [failure];
}
