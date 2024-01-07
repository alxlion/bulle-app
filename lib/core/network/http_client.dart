import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class HttpClient {
  static HttpClient? _instance;
  final Dio dio;

  HttpClient._internal() : dio = Dio(BaseOptions(baseUrl: kIsWeb ? 'http://localhost:3000' : 'http://192.0.0.2:3000'));

  static HttpClient get instance {
    _instance ??= HttpClient._internal();
    return _instance!;
  }
}
