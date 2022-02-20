import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsapp/features/news/presentation/bloc/filter_bloc/news_filter_event.dart';
import 'package:newsapp/features/news/presentation/bloc/filter_bloc/news_filter_state.dart';

class FilterBloc extends Bloc<NewsFilterEvent, NewsFilterState> {
  FilterBloc() : super(AllSelected()) {
    on<All>((event, emit) => emit(AllSelected()));
    on<Headline>(((event, emit) => emit(HeadlineSelected())));
  }
}
