import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/env.dart';
import 'api_exception.dart';
import 'dio_client.dart';

/// Thin wrapper around Dio that returns decoded JSON and normalises errors.
class TmdbApiService {
  TmdbApiService(this._dio);

  final Dio _dio;

  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, dynamic>? query,
  }) async {
    if (!Env.hasToken) {
      throw const ApiException(
          'TMDB token missing. Copy .env.example to .env and add your access token.');
    }
    try {
      final response =
          await _dio.get<Map<String, dynamic>>(path, queryParameters: query);
      return response.data ?? <String, dynamic>{};
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }
}

final tmdbApiProvider =
    Provider<TmdbApiService>((ref) => TmdbApiService(ref.watch(dioProvider)));
