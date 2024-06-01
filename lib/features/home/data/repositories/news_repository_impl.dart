import 'dart:developer';

import '/core/utils/result.dart';
import '/features/home/data/datasources/news_remote_data_source.dart';
import '/features/home/domain/entities/article.dart';
import '/features/home/domain/repositories/news_repository.dart';

class NewsRepositoryImpl implements NewsRepository {
  final NewsRemoteDataSource _remoteDataSource = NewsRemoteDataSource();

  @override
  Future<Result<List<Article>>> getNews() async {
    try {
      final response = await _remoteDataSource.fetchNews();
      // Using tear offs in map
      final articles = response.results
          .map(Article.fromModel)
          .toList();
      return Result(data: articles);
    } catch (e) {
      debugger();
      return Result(error: e.toString());
    }
  }
}
