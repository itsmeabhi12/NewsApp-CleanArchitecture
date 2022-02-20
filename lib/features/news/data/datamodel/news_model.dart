import '../../domain/entities/news.dart';

class NewsModel extends News {
  NewsModel(
      {required String content,
      required String description,
      required String publishedAt,
      required Map<String, dynamic> source,
      required String title,
      required String url,
      required String urlToImage})
      : super(
            content: content,
            description: description,
            publishedAt: publishedAt,
            source: source,
            title: title,
            url: url,
            urlToImage: urlToImage);

  factory NewsModel.fromJson(Map<dynamic, dynamic> newsmodel) {
    return NewsModel(
        content: newsmodel['content'],
        description: newsmodel['description'],
        publishedAt: newsmodel['publishedAt'],
        source: newsmodel['source'],
        title: newsmodel['title'],
        url: newsmodel['url'],
        urlToImage: newsmodel['urlToImage']);
  }
  Map<String, dynamic> toJson(NewsModel newsModel) {
    return {
      "author": newsModel.author,
      "content": newsModel.content,
      "description": newsModel.description,
      "publishedAt": newsModel.publishedAt,
      "source": newsModel.source,
      "title": newsModel.title,
      "url": newsModel.url,
      "urlToImage": newsModel.urlToImage
    };
  }
}
