import 'package:dio/dio.dart';
import 'package:{{project_name.snakeCase()}}/core/error/failure.dart';

/// Converts any thrown object into a [Failure]. Only repositories (via
/// `guard`) should call this.
Failure mapError(Object error) {
  if (error is Failure) return error;
  if (error is! DioException) return const UnknownFailure();

  switch (error.type) {
    case DioExceptionType.connectionError:
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.transformTimeout:
    case DioExceptionType.sendTimeout:
      return const NetworkFailure();
    case DioExceptionType.badResponse:
      final status = error.response?.statusCode;
      if (status == 401) return const UnauthorizedFailure();
      final message = _serverMessage(error.response?.data);
      if (status == 422 && message != null) return ValidationFailure(message);
      return ServerFailure(
        message ?? const UnknownFailure().message,
        statusCode: status,
      );
    case DioExceptionType.cancel:
    case DioExceptionType.badCertificate:
    case DioExceptionType.unknown:
      return const UnknownFailure();
  }
}

String? _serverMessage(Object? data) {
  if (data is Map<String, dynamic>) {
    final message = data['message'];
    if (message is String && message.isNotEmpty) return message;
  }
  return null;
}
