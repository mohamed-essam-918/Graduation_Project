class NewsModel {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final DateTime date;
  final String source;
  final String? category;

  NewsModel({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.date,
    required this.source,
    this.category,
  });
}
