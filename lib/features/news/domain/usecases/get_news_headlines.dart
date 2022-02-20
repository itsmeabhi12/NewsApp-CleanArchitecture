import 'package:newsapp/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:newsapp/core/usecases/usecases.dart';
import 'package:newsapp/features/news/domain/entities/news.dart';
import 'package:newsapp/features/news/domain/repositories/news_repositories.dart';

class GetNewsHeadline extends UseCases<List<News>, HeadlineParams> {
  final NewsRepositories newsRepositories;

  GetNewsHeadline({required this.newsRepositories});
  @override
  Future<Either<Failure, List<News>>> call(params) async {
    return await newsRepositories.getNewsHeadline(params.query, params.page);
  }
}

class HeadlineParams {
  final String query;
  final String page;
  HeadlineParams({required this.query, required this.page});
}
