import 'package:dio/dio.dart';

/// API Client for network requests
class ApiClient {
  final Dio _dio;

  ApiClient({Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: 'https://reqres.in/api',
              connectTimeout: const Duration(seconds: 30),
              receiveTimeout: const Duration(seconds: 30),
              headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
              },
            ),
          );

  Dio get dio => _dio;

  /// POST request
  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
      );
      return response;
    } on DioException {
      rethrow;
    }
  }

  /// GET request
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.get<T>(
        path,
        queryParameters: queryParameters,
      );
      return response;
    } on DioException {
      rethrow;
    }
  }
}
