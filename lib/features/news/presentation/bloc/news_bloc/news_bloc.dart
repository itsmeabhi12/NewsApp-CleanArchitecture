import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsapp/core/error/failure.dart';
import 'package:newsapp/core/network/network_checker.dart';
import 'package:newsapp/features/news/domain/usecases/get_news_everythings.dart';
import 'package:newsapp/features/news/domain/usecases/get_news_headlines.dart';
import 'package:newsapp/features/news/presentation/bloc/news_bloc/news_event.dart';
import 'package:newsapp/features/news/presentation/bloc/news_bloc/news_state.dart';
import 'package:rxdart/rxdart.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final GetNewsEverything getNewsEverything;
  final GetNewsHeadline getNewsHeadline;
  final Networkinfo networkinfo;
  NewsBloc(
      {required this.getNewsEverything,
      required this.getNewsHeadline,
      required this.networkinfo})
      : super(Initial()) {
    on<GetAllNews>((event, emit) async {
      emit(Loading());
      final newsarticles = await getNewsEverything
          .call(EverythingParams(query: event.keyword, page: event.page));
      newsarticles.fold((l) {
        if (l is CacheFailure) {
          emit(Error(message: 'cache fail'));
        } else if (l is ServerFailure) {
          emit(Error(message: l.message));
        }
      }, (r) => emit(Loaded(news: r)));
    });
    on<GetHeadlineNews>((event, emit) async {
      emit(Loading());
      final newsarticle = await getNewsHeadline
          .call(HeadlineParams(query: event.keyword, page: event.page));
      newsarticle.fold((l) {
        if (l is CacheFailure) {
          emit(Error(message: 'cache fail'));
        } else if (l is ServerFailure) {
          emit(Error(message: l.message));
        }
      }, (r) => emit(Loaded(news: r)));
    });
    on<LoadMoreNews>(
      (event, emit) async {
        if (event.currentEvent is GetAllNews) {
          final newsarticles = await getNewsEverything.call(EverythingParams(
              query: (event.currentEvent as GetAllNews).keyword,
              page: (event.currentEvent as GetAllNews).page));
          newsarticles.fold((l) {
            if (l is CacheFailure) {
              emit(Error(message: 'cache fail'));
            } else if (l is ServerFailure) {
              emit(Error(message: l.message));
            }
          }, (r) {
            if (state is Loaded) {
              return emit(
                  Loaded(news: List.of((state as Loaded).news..addAll(r))));
            } else {
              emit(Error(message: 'Something Went Wrong'));
            }
          });
        } else if (event.currentEvent is GetHeadlineNews) {
          final newsarticles = await getNewsEverything.call(EverythingParams(
              query: (event.currentEvent as GetHeadlineNews).keyword,
              page: (event.currentEvent as GetHeadlineNews).page));
          newsarticles.fold((l) {
            if (l is CacheFailure) {
              emit(Error(message: 'cache fail'));
            } else if (l is ServerFailure) {
              emit(Error(message: l.message));
            }
          }, (r) {
            if (state is Loaded) {
              return emit(Loaded(news: (state as Loaded).news + r));
            } else {
              emit(Error(message: 'Something went wrong'));
            }
          });
        }
      },
      transformer: (events, mapper) => events
          .debounceTime(const Duration(milliseconds: 500))
          .flatMap((mapper)),
    );
    on<GetCacheNews>(
      (event, emit) async {
        final isconnected = await networkinfo.isConnected;
        if (!isconnected) {
          return add(
            GetAllNews(page: '', keyword: ''),
          );
        }
        emit(Initial());
      },
    ); //  we try to get last cached data so page and keyword dosent really matter
  }
}
