import 'package:newsapp/features/home/data/models/news_response.dart';

class Article {
  late final String id;
  late final String title;
  late final String description;
  late bool isFavorite;

  Article({
    required this.id,
    required this.title,
    required this.description,
    this.isFavorite = false,
  });

  Article.fromModel(ArticleModel model) {
    id = model.articleId;
    title = model.title;
    description = model.description;
    isFavorite = false;
  }
}
