
import '/core/utils/result.dart';
import '/features/home/domain/entities/article.dart';

abstract class NewsRepository {
  Future<Result<List<Article>>> getNews();
}
