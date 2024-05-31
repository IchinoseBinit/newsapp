import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/features/home/presentation/widgets/article_item.dart';
import '/features/home/presentation/providers/news_provider.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('News')),
      body: Consumer(builder: (_, ref, __) {
        final newsState = ref.watch(newsProvider);

        return newsState.isSuccess
            ? ListView.builder(
                itemCount: newsState.data?.length ?? 0,
                itemBuilder: (context, index) {
                  final article = newsState.data![index];
                  return ArticleItem(
                    article: article,
                  );
                },
              )
            : newsState.error != null
                ? Center(
                    child: Text(newsState.error!),
                  )
                : const Center(
                    child: CircularProgressIndicator(),
                  );
      }),
    );
  }
}
