import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:{{project_name.snakeCase()}}/core/storage/token_storage.dart';

@lazySingleton
class AuthInterceptor extends QueuedInterceptor {
  AuthInterceptor(this._tokenStorage);

  final TokenStorage _tokenStorage;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _tokenStorage.readAccessToken();
    if (token != null) options.headers['Authorization'] = 'Bearer $token';
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // Token refresh belongs here when the backend supports it. Until then a
    // 401 clears the session and the error maps to UnauthorizedFailure.
    if (err.response?.statusCode == 401) await _tokenStorage.clear();
    handler.next(err);
  }
}
