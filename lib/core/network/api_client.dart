import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '/core/network/news_api_service.dart';

class ApiClient {
  static final Dio _dio = Dio();
  static final NewsApiService _newsApiService = NewsApiService(_dio);

  static NewsApiService get newsApiService => _newsApiService;

  static String get apiKey {
    final val = dotenv.env['API_KEY'] ?? '';
    if (val.isNotEmpty) {
      // Convert the base64 to uint8list (bytes), then convert it to string using utf
      return utf8.decode(base64Decode(val));
    }
    return '';
  }
}
