import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:newsapp/features/news/presentation/bloc/filter_bloc/news_filter_bloc.dart';
import 'package:newsapp/features/news/presentation/bloc/news_bloc/news_bloc.dart';
import 'package:newsapp/features/news/presentation/bloc/news_bloc/news_event.dart';
import 'package:newsapp/features/news/presentation/pages/home_page.dart';
import 'package:newsapp/injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NewsAPI',
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
      ),
      home: BlocProvider<NewsBloc>(
          create: (context) => di.sl<NewsBloc>()..add(GetCacheNews()),
          child: BlocProvider<FilterBloc>(
              create: (context) => di.sl<FilterBloc>(),
              child: const MyHomePage(title: 'News App'))),
    );
  }
}
