import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/features/home/presentation/widgets/article_item.dart';
import '/features/home/presentation/providers/news_provider.dart';

class FavouritesScreen extends StatelessWidget {
  const FavouritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favourites')),
      body: Consumer(builder: (_, ref, __) {
        final newsState = ref.watch(newsProvider);
        final favorites = newsState.isSuccess
            ? ref.watch(newsProvider.notifier).favorites
            : [];
        return newsState.isSuccess
            ? ListView.builder(
                itemCount: favorites.length,
                itemBuilder: (context, index) {
                  final article = favorites[index];
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
