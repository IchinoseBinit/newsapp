import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '/common/constants/hive_constants.dart';
import '/core/utils/result.dart';
import '/features/auth/presentation/providers/auth_provider.dart';
import '/features/home/data/repositories/news_repository_impl.dart';
import '/features/home/domain/entities/article.dart';
import '/features/home/domain/usecases/get_news.dart';

final newsProvider =
    StateNotifierProvider<NewsNotifier, Result<List<Article>>>((ref) {
  return NewsNotifier(GetNews(NewsRepositoryImpl()), ref);
});

class NewsNotifier extends StateNotifier<Result<List<Article>>> {
  final GetNews getNewsUseCase;
  final Ref ref;
  Box<List<String>>? _favoritesBox;

  Box<List<String>> get favoritesBox {
    _favoritesBox ??= Hive.box(HiveConstants.boxKey);
    return _favoritesBox!;
  }

  NewsNotifier(this.getNewsUseCase, this.ref) : super(Result());

  Future<void> fetchNews() async {
    state = Result();
    final result = await getNewsUseCase();
    if (result.isSuccess) {
      final List<Article> articles = result.data!;
      final authState = ref.read(authNotifierProvider);
      if (authState is Authenticated) {
        final user = authState.user;
        final favoriteIds =
            favoritesBox.get(user.id, defaultValue: <String>[]) as List<String>;
        for (final article in articles) {
          article.isFavorite = favoriteIds.contains(article.id);
        }
      }
      state = Result(data: articles);
    } else {
      state = result;
    }
  }

  void toggleFavorite(Article article) {
    final authState = ref.read(authNotifierProvider);
    if (authState is Authenticated) {
      final user = authState.user;
      final favoriteIds =
          favoritesBox.get(user.id, defaultValue: <String>[]) as List<String>;
      if (article.isFavorite) {
        favoriteIds.remove(article.id);
      } else {
        favoriteIds.add(article.id);
      }
      favoritesBox.put(user.id, favoriteIds);
      article.isFavorite = !article.isFavorite;
      state = Result(data: List<Article>.from(state.data!));
    }
  }

  List<Article> get favorites {
    final authState = ref.read(authNotifierProvider);
    if (authState is Authenticated) {
      final user = authState.user;
      final favoriteIds =
          favoritesBox.get(user.id, defaultValue: <String>[]) as List<String>;
      return state.data
              ?.where((article) => favoriteIds.contains(article.id))
              .toList() ??
          [];
    }
    return [];
  }
}
