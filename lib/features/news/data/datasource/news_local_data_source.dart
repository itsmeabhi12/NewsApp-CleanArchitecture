import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:newsapp/core/error/error.dart';
import 'package:newsapp/features/news/data/datamodel/news_model.dart';

abstract class LocalDataSource {
  void cacheNews(List<NewsModel> newsmodel);
  List<NewsModel> getLatestCachedNews();
}

class LocalDataSourceImpl extends LocalDataSource {
  final Box<List> newsBox;
  LocalDataSourceImpl({required this.newsBox});

  @override
  void cacheNews(List<NewsModel> newsmodel) {
    final news = newsmodel.map((e) => json.encode(e.toJson(e))).toList();
    newsBox.put('CACHED_NEWS', news);
  }

  @override
  List<NewsModel> getLatestCachedNews() {
    final cachedNews = newsBox.get('CACHED_NEWS');
    if (cachedNews == null) {
      throw CacheException();
    }
    return cachedNews
        .map<NewsModel>((e) => NewsModel.fromJson(json.decode(e)))
        .toList();
  }
}
