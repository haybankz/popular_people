import 'package:dio/dio.dart';

import '../constants/strings.dart';

class ServerException implements Exception {
  String message = "";
  ServerException(this.message) : super();

  @override
  String toString() {
    return message;
  }
}

class CacheException implements Exception {
  String message;
  CacheException(this.message) : super();

  @override
  String toString() {
    return message;
  }
}

extension DioErrorExtension on DioError {
  ServerException toServerException() {
    String message = "";
    switch (type) {
      case DioErrorType.cancel:
        message = Strings.connectionCancelled;
        break;

      case DioErrorType.other:
        message = Strings.noInternet;
        break;

      case DioErrorType.connectTimeout:
      case DioErrorType.receiveTimeout:
      case DioErrorType.sendTimeout:
        message = Strings.connectionTimeOut;
        break;

      default:
        message = "Something went wrong";
        break;
    }
    return ServerException(message);
  }
}
