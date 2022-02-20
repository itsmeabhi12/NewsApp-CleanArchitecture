abstract class Failure {}

class ServerFailure extends Failure {
  final String message;
  ServerFailure({required this.message});
}

class CacheFailure extends Failure {}
