import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:newsapp/core/network/network_checker.dart';
import 'package:newsapp/features/news/data/datasource/news_local_data_source.dart';
import 'package:newsapp/features/news/data/datasource/news_remote_data_source.dart';
import 'package:newsapp/features/news/data/repositories/news_repositoreis_impl.dart';
import 'package:newsapp/features/news/domain/repositories/news_repositories.dart';
import 'package:newsapp/features/news/domain/usecases/get_news_everythings.dart';
import 'package:newsapp/features/news/domain/usecases/get_news_headlines.dart';
import 'package:newsapp/features/news/presentation/bloc/filter_bloc/news_filter_bloc.dart';
import 'package:newsapp/features/news/presentation/bloc/news_bloc/news_bloc.dart';
import 'package:http/http.dart' as http;

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerFactory<NewsBloc>(() => NewsBloc(
      getNewsEverything: sl(), getNewsHeadline: sl(), networkinfo: sl()));

  sl.registerFactory<FilterBloc>(() => FilterBloc());

  //usecases
  sl.registerLazySingleton(() => GetNewsEverything(newsRepositories: sl()));
  sl.registerLazySingleton(() => GetNewsHeadline(newsRepositories: sl()));

  //repo
  sl.registerLazySingleton<NewsRepositories>(() => NewsRepositoriesImpl(
      localDataSource: sl(), remoteDataSource: sl(), networkinfo: sl()));

  //datasource
  sl.registerLazySingleton<LocalDataSource>(
      () => LocalDataSourceImpl(newsBox: sl()));
  sl.registerLazySingleton<RemoteDataSource>(
      () => RemoteDataSourceImpl(client: sl()));

  //External
  final Box<List> box = await Hive.openBox('news');
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => box);
  sl.registerLazySingleton<Networkinfo>(
      () => NetworkinfoImpl(connectivity: sl()));
  sl.registerLazySingleton(() => Connectivity());
}
