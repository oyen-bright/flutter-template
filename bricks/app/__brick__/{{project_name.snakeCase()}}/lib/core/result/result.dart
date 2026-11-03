import 'dart:developer';

import 'package:{{project_name.snakeCase()}}/core/error/error_mapper.dart';
import 'package:{{project_name.snakeCase()}}/core/error/failure.dart';

/// What every repository method returns. Repositories never throw.
sealed class Result<T> {
  const Result();

  R fold<R>({
    required R Function(T data) onSuccess,
    required R Function(Failure failure) onFailure,
  }) => switch (this) {
    Ok<T>(:final data) => onSuccess(data),
    Err<T>(:final failure) => onFailure(failure),
  };
}

final class Ok<T> extends Result<T> {
  const Ok(this.data);
  final T data;
}

final class Err<T> extends Result<T> {
  const Err(this.failure);
  final Failure failure;
}

/// Runs [body] and converts any exception into an [Err]. Wrap every
/// repository method body in this - it is the only try/catch in a feature.
Future<Result<T>> guard<T>(Future<T> Function() body) async {
  try {
    return Ok(await body());
  } on Object catch (error, stackTrace) {
    log('Repository error', error: error, stackTrace: stackTrace);
    return Err(mapError(error));
  }
}
