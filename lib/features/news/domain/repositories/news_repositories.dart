import 'package:dartz/dartz.dart';
import 'package:newsapp/core/error/failure.dart';
import 'package:newsapp/features/news/data/datamodel/news_model.dart';

abstract class NewsRepositories {
  Future<Either<Failure, List<NewsModel>>> getNewsEverything(
      String keyword, String page);
  Future<Either<Failure, List<NewsModel>>> getNewsHeadline(
      String keyword, String page);
}
