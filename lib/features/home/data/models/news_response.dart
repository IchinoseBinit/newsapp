import 'package:json_annotation/json_annotation.dart';

part 'news_response.g.dart';

@JsonSerializable()
class NewsResponse {
  final List<ArticleModel> results;

  NewsResponse({required this.results});

  factory NewsResponse.fromJson(Map<String, dynamic> json) =>
      _$NewsResponseFromJson(json);
  Map<String, dynamic> toJson() => _$NewsResponseToJson(this);
}

@JsonSerializable()
class ArticleModel {
  @JsonKey(name: 'article_id')
  final String articleId;
  final String title;
  final String description;
  bool isFavorite;

  ArticleModel(
      {required this.articleId,
      required this.title,
      required this.description,
      this.isFavorite = false});

  factory ArticleModel.fromJson(Map<String, dynamic> json) =>
      _$ArticleModelFromJson(json);
  Map<String, dynamic> toJson() => _$ArticleModelToJson(this);
}
