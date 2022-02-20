import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsapp/features/news/presentation/bloc/filter_bloc/news_filter_bloc.dart';
import 'package:newsapp/features/news/presentation/bloc/filter_bloc/news_filter_event.dart';
import 'package:newsapp/features/news/presentation/bloc/filter_bloc/news_filter_state.dart';
import 'package:newsapp/features/news/presentation/bloc/news_bloc/news_bloc.dart';
import 'package:newsapp/features/news/presentation/bloc/news_bloc/news_event.dart';
import 'package:newsapp/features/news/presentation/bloc/news_bloc/news_state.dart';
import 'package:newsapp/features/news/presentation/widgets/news_card.dart';

import '../../domain/entities/news.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _textEditingController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<News> newsarticles = [];

  @override
  void initState() {
    _scrollController.addListener(_onScroll);
    super.initState();
  }

  _onScroll() {
    if (_isBottom) {
      final filterState = BlocProvider.of<FilterBloc>(context).state;
      BlocProvider.of<NewsBloc>(context).add(LoadMoreNews(
        currentEvent: filterState is AllSelected
            ? GetAllNews(
                keyword: _textEditingController.text,
                page: (((newsarticles.length) / 20) + 1).toInt().toString())
            : GetHeadlineNews(
                page: (((newsarticles.length) / 20) + 1).toInt().toString(),
                keyword: _textEditingController.text),
      ));
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 50,
              child: TextField(
                controller: _textEditingController,
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),
            ),
            BlocBuilder<FilterBloc, NewsFilterState>(
              builder: (context, state) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: state is AllSelected
                                ? Colors.blue
                                : Colors.white),
                        onPressed: () {
                          BlocProvider.of<FilterBloc>(context).add(All());
                          BlocProvider.of<NewsBloc>(context).add(GetAllNews(
                              keyword: _textEditingController.text, page: "1"));
                        },
                        child: const Text("All"),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: state is HeadlineSelected
                                ? Colors.blue
                                : Colors.white),
                        onPressed: () {
                          BlocProvider.of<FilterBloc>(context).add(Headline());
                          BlocProvider.of<NewsBloc>(context).add(
                              GetHeadlineNews(
                                  keyword: _textEditingController.text,
                                  page: "1"));
                        },
                        child: const Text("Headlines"),
                      ),
                    )
                  ],
                );
              },
            ),
            Expanded(
              child: BlocBuilder<NewsBloc, NewsState>(
                builder: (context, state) {
                  if (state is Initial) {
                    return const Center(
                      child: Text('Search News'),
                    );
                  } else if (state is Empty) {
                    return const Center(
                      child: Text('Didnot Found Anything Try Another Keyword'),
                    );
                  } else if (state is Loading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is Error) {
                    return Center(
                      child: Text(
                        state.message,
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  } else {
                    newsarticles = (state as Loaded).news;
                    return ListView.separated(
                      controller: _scrollController,
                      separatorBuilder: (context, index) => const SizedBox(
                        height: 16,
                      ),
                      itemCount: newsarticles.length + 1,
                      itemBuilder: (context, index) {
                        if (index == newsarticles.length) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return NewsCard(
                          news: newsarticles[index],
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
