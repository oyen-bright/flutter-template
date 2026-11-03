import 'package:equatable/equatable.dart';

/// Business object used by the UI and other features. No JSON here.
class {{name.pascalCase()}} extends Equatable {
  const {{name.pascalCase()}}({required this.id, required this.name});

  final String id;
  final String name;

  @override
  List<Object?> get props => [id, name];
}
