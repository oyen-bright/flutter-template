import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:{{project_name.snakeCase()}}/core/error/failure.dart';
import 'package:{{project_name.snakeCase()}}/core/result/result.dart';

void main() {
  group('guard', () {
    test('returns Ok with the value', () async {
      final result = await guard(() async => 42);
      expect(result, isA<Ok<int>>().having((r) => r.data, 'data', 42));
    });

    test('maps a 401 to UnauthorizedFailure', () async {
      final request = RequestOptions(path: '/x');
      final result = await guard<int>(
        () => throw DioException(
          requestOptions: request,
          type: DioExceptionType.badResponse,
          response: Response(requestOptions: request, statusCode: 401),
        ),
      );
      expect(
        result,
        isA<Err<int>>().having(
          (r) => r.failure,
          'failure',
          isA<UnauthorizedFailure>(),
        ),
      );
    });

    test('maps unknown errors to UnknownFailure', () async {
      final result = await guard<int>(() => throw StateError('boom'));
      expect(
        result,
        isA<Err<int>>().having((r) => r.failure, 'failure', const UnknownFailure()),
      );
    });
  });
}
