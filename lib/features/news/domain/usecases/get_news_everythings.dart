import 'package:newsapp/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:newsapp/core/usecases/usecases.dart';
import 'package:newsapp/features/news/domain/entities/news.dart';
import 'package:newsapp/features/news/domain/repositories/news_repositories.dart';

class GetNewsEverything extends UseCases<List<News>, EverythingParams> {
  final NewsRepositories newsRepositories;

  GetNewsEverything({required this.newsRepositories});
  @override
  Future<Either<Failure, List<News>>> call(params) async {
    return await newsRepositories.getNewsEverything(params.query, params.page);
  }
}

class EverythingParams {
  final String query;
  final String page;
  EverythingParams({required this.query, required this.page});
}
