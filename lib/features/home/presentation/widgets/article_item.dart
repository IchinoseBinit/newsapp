import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/features/auth/presentation/providers/auth_provider.dart';
import '/features/home/domain/entities/article.dart';
import '/features/home/presentation/providers/news_provider.dart';
import '/router/app_router.gr.dart';

class ArticleItem extends StatelessWidget {
  final Article article;

  const ArticleItem({
    super.key,
    required this.article,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.white
                  : Colors.white10,
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4.0,
                  spreadRadius: 2.0,
                  offset: Offset(2.0, 2.0),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    constraints: const BoxConstraints(minHeight: 40, maxHeight: 120),
                    width: MediaQuery.of(context).size.width * .8,
                    child: Text(
                      article.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    article.description,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.justify,
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: Consumer(
              builder: (context, ref, _) {
                final isLoggedIn = ref.watch(authNotifierProvider).isLoggedIn;
                return GestureDetector(
                  onTap: () {
                    if (isLoggedIn) {
                      ref.read(newsProvider.notifier).toggleFavorite(article);
                    } else {
                      AutoRouter.of(context).push(const LoginScreenRoute());
                    }
                  },
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4.0,
                          spreadRadius: 2.0,
                          offset: Offset(2.0, 2.0),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      isLoggedIn && article.isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: isLoggedIn && article.isFavorite ? Colors.red : Colors.grey,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
