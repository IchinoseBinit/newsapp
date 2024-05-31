

import '/core/network/api_client.dart';
import '/core/network/news_api_service.dart';
import '/features/home/data/models/news_response.dart';

class NewsRemoteDataSource {
  final NewsApiService _apiService = ApiClient.newsApiService;

  Future<NewsResponse> fetchNews() {
    return _apiService.getNews(ApiClient.apiKey, "np");
  }
}
