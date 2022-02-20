class News {
  Map<String, dynamic> source;
  String? author;
  String title;
  String description;
  String url;
  String urlToImage;
  String publishedAt;
  String content;

  News(
      {this.author,
      required this.content,
      required this.description,
      required this.publishedAt,
      required this.source,
      required this.title,
      required this.url,
      required this.urlToImage});
}
