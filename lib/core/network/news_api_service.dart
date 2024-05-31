import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '/features/home/data/models/news_response.dart';

part 'news_api_service.g.dart';

@RestApi(baseUrl: "https://newsdata.io/api/1/")
abstract class NewsApiService {
  factory NewsApiService(Dio dio, {String baseUrl}) = _NewsApiService;

  @GET("news")
  Future<NewsResponse> getNews(
    @Query("apikey") String apiKey,
    @Query("country") String country,
  );
}
