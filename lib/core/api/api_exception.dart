import 'package:dio/dio.dart';

class ApiException implements Exception {
  const ApiException(this.message, {this.statusCode});

  factory ApiException.fromDio(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const ApiException(
            'The request timed out. Check your connection and try again.');
      case DioExceptionType.connectionError:
        return const ApiException(
            'No internet connection. Please check your network.');
      default:
        break;
    }
    final status = error.response?.statusCode;
    if (status == 401) {
      return ApiException(
          'TMDB rejected the access token. Check TMDB_ACCESS_TOKEN in your .env file.',
          statusCode: status);
    }
    if (status == 404) {
      return const ApiException('Content not found.', statusCode: 404);
    }
    if (status == 429) {
      return const ApiException('Too many requests. Please wait a moment.',
          statusCode: 429);
    }
    final data = error.response?.data;
    final detail = data is Map ? data['status_message'] as String? : null;
    return ApiException(detail ?? 'Something went wrong while contacting TMDB.',
        statusCode: status);
  }

  final String message;
  final int? statusCode;

  @override
  String toString() => 'ApiException($statusCode): $message';
}

/// Converts any error into a message safe to show to the user.
String describeError(Object error) =>
    error is ApiException ? error.message : 'Something went wrong. Please try again.';
