import 'package:newsapp/features/news/data/datamodel/news_model.dart';

class SourceModel {
  final String status;
  final String totalResult;
  final List<NewsModel> articles;

  SourceModel(
      {required this.status,
      required this.totalResult,
      required this.articles});

  factory SourceModel.fromJson(Map<String, dynamic> newsmodel) {
    return SourceModel(
        status: newsmodel['status'],
        totalResult: newsmodel['totalResults'],
        articles: newsmodel["articles"]);
  }
}
