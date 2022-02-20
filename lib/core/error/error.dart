class ServerException implements Exception {
  final String message;
  final String prefix;

  ServerException(this.message, this.prefix);

  @override
  String toString() => prefix + message;
}

class FetchDataException extends ServerException {
  FetchDataException(String message)
      : super(message, "Error During Communication: ");
}

class BadRequestException extends ServerException {
  BadRequestException(String message) : super(message, "Invalid Request: ");
}

class UnauthorisedException extends ServerException {
  UnauthorisedException(String message) : super(message, "Unauthorised: ");
}

class InvalidInputException extends ServerException {
  InvalidInputException(String message) : super(message, "Invalid Input: ");
}

class NotFoundException extends ServerException {
  NotFoundException(String message) : super(message, "Not Found: ");
}

class InternalServerException extends ServerException {
  InternalServerException(String message)
      : super(message, "Internal Server Error: ");
}

class CacheException implements Exception {}
