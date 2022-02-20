import 'package:newsapp/features/news/domain/entities/news.dart';

abstract class NewsState {}

class Initial extends NewsState {}

class Loading extends NewsState {}

class Loaded extends NewsState {
  final List<News> news;
  Loaded({required this.news});
}

class Empty extends NewsState {}

class Error extends NewsState {
  final String message;
  Error({required this.message});
}
