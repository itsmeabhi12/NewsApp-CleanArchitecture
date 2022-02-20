import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:newsapp/core/error/error.dart';
import 'package:newsapp/features/news/data/datamodel/news_model.dart';

abstract class RemoteDataSource {
  Future<List<NewsModel>> getNewsEverythings(String keyword, String page);
  Future<List<NewsModel>> getNewsHeadlines(String keyword, String page);
}

//2598fb2faaa843bf8b5f976c70c19e02
class RemoteDataSourceImpl extends RemoteDataSource {
  final http.Client client;
  RemoteDataSourceImpl({required this.client});

  @override
  Future<List<NewsModel>> getNewsEverythings(
      String keyword, String page) async {
    final http.Response response = await http.get(Uri.https(
        "newsapi.org", "/v2/everything", {
      'q': keyword,
      'page': page,
      'apiKey': '2598fb2faaa843bf8b5f976c70c19e02'
    }));

    switch (response.statusCode) {
      case 200:
        return jsonDecode(response.body)['articles']
            .map<NewsModel>((articles) => NewsModel.fromJson(articles))
            .toList();
      case 400:
        throw BadRequestException(jsonDecode(response.body)['message']);
      case 401:
        throw UnauthorisedException(jsonDecode(response.body)['message']);
      case 404:
        throw NotFoundException(jsonDecode(response.body)['message']);
      case 500:
        throw InternalServerException(jsonDecode(response.body)['message']);
      default:
        throw FetchDataException(jsonDecode(response.body)['message']);
    }
  }

  @override
  Future<List<NewsModel>> getNewsHeadlines(String keyword, String page) async {
    final http.Response response = await http.get(Uri.https(
        "newsapi.org", "/v2/top-headlines", {
      'q': keyword,
      'page': page,
      'apiKey': '2598fb2faaa843bf8b5f976c70c19e02'
    }));
    switch (response.statusCode) {
      case 200:
        return jsonDecode(response.body)['articles']
            .map<NewsModel>((articles) => NewsModel.fromJson(articles))
            .toList();
      case 400:
        throw BadRequestException(jsonDecode(response.body)['message']);
      case 401:
        throw UnauthorisedException(jsonDecode(response.body)['message']);
      case 404:
        throw NotFoundException(jsonDecode(response.body)['message']);
      case 500:
        throw InternalServerException(jsonDecode(response.body)['message']);
      default:
        throw FetchDataException(jsonDecode(response.body)['message']);
    }
  }
}
