class Article {
  final String id;
  final String title;
  final String description;
  bool isFavorite;

  Article({
  required this.id,
    required this.title,
    required this.description,
    this.isFavorite = false,
  });
}
