abstract class NewsEvent {}

class GetAllNews extends NewsEvent {
  final String page;
  final String keyword;
  GetAllNews({required this.keyword, required this.page});
}

class GetHeadlineNews extends NewsEvent {
  final String keyword;
  final String page;
  GetHeadlineNews({required this.keyword, required this.page});
}

class LoadMoreNews extends NewsEvent {
  final NewsEvent currentEvent;
  LoadMoreNews({required this.currentEvent});
}

class GetCacheNews extends NewsEvent {}
