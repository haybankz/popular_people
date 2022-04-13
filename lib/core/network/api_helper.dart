import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:popular_people/core/errors/errors.dart';

import '../constants/strings.dart';

class ApiBaseHelper {
  BaseOptions options = BaseOptions(
      baseUrl: Strings.baseUrl,
      connectTimeout: 1000 * 60, //60sec
      receiveTimeout: 1000 * 60, //60sec
      contentType: 'application/json',
      validateStatus: (status) {
        return status! < 500;
      });

  late Dio _dio;

  ApiBaseHelper() {
    _dio = Dio(options);

    // add log interceptor if in debug mode
    if (kDebugMode) {
      _dio.interceptors.add(LogInterceptor(
          responseBody: true,
          error: true,
          requestHeader: true,
          responseHeader: false,
          request: true,
          requestBody: true));
    }
  }

  Future<Response<dynamic>> get(String url, String token) async {
    Response<dynamic> response;

    try {
      response = await _dio.get(
        url,
        options: Options(headers: {"authorization": "Bearer $token"}),
      );
    } on DioError catch (e) {
      throw e.toServerException();
    } catch (e) {
      throw ServerException(e.toString());
    }

    return response;
  }
}
