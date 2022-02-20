import 'package:dartz/dartz.dart';
import 'package:newsapp/core/error/failure.dart';

abstract class UseCases<T, P> {
  Future<Either<Failure, T>> call(P params);
}
