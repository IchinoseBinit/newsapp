
import '/core/utils/result.dart';
import '/features/home/domain/entities/article.dart';
import '/features/home/domain/repositories/news_repository.dart';

class GetNews {
  final NewsRepository repository;

  GetNews(this.repository);

  Future<Result<List<Article>>> call() {
    return repository.getNews();
  }
}
