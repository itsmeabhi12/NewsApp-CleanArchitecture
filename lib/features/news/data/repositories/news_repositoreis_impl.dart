import 'package:newsapp/core/error/error.dart';
import 'package:newsapp/core/network/network_checker.dart';
import 'package:newsapp/features/news/data/datamodel/news_model.dart';
import 'package:newsapp/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:newsapp/features/news/data/datasource/news_local_data_source.dart';
import 'package:newsapp/features/news/data/datasource/news_remote_data_source.dart';
import 'package:newsapp/features/news/domain/repositories/news_repositories.dart';

class NewsRepositoriesImpl extends NewsRepositories {
  final LocalDataSource localDataSource;
  final RemoteDataSource remoteDataSource;
  final Networkinfo networkinfo;

  NewsRepositoriesImpl(
      {required this.localDataSource,
      required this.remoteDataSource,
      required this.networkinfo});
  @override
  Future<Either<Failure, List<NewsModel>>> getNewsEverything(
      String keyword, String page) async {
    final isconnected = await networkinfo.isConnected;
    if (isconnected) {
      try {
        final List<NewsModel> newsArticles =
            await remoteDataSource.getNewsEverythings(keyword, page);
        localDataSource.cacheNews(newsArticles);

        return Right(newsArticles);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      try {
        final List<NewsModel> newsArticles =
            localDataSource.getLatestCachedNews();
        return Right(newsArticles);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, List<NewsModel>>> getNewsHeadline(
      String keyword, String page) async {
    if (await networkinfo.isConnected) {
      try {
        final List<NewsModel> newsArticles =
            await remoteDataSource.getNewsHeadlines(keyword, page);
        return Right(newsArticles);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      try {
        final List<NewsModel> newsArticles =
            localDataSource.getLatestCachedNews();
        return Right(newsArticles);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
