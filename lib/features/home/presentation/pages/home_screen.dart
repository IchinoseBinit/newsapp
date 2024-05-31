import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/features/auth/presentation/pages/account_screen.dart';
import '/features/auth/presentation/providers/auth_provider.dart';
import '/features/home/presentation/pages/favourites_screen.dart';
import '/features/home/presentation/pages/news_screen.dart';
import '/features/home/presentation/providers/news_provider.dart';
import '/router/app_router.gr.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(newsProvider.notifier).fetchNews();
    });
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    late List<Widget> pages;
    late List<BottomNavigationBarItem> items;
    if (authState.isLoggedIn) {
       pages =[const NewsScreen(), const FavouritesScreen(), const AccountScreen()];
       items =  [
            const BottomNavigationBarItem(
                icon: Icon(Icons.home), label: 'Home'),
            const BottomNavigationBarItem(
                icon: Icon(Icons.favorite), label: 'Favourites'),
            const BottomNavigationBarItem(
                icon: Icon(Icons.account_circle), label: 'Account'),
          ];
    } else {
      pages =[const NewsScreen(), const FavouritesScreen()];
       items =  [
            const BottomNavigationBarItem(
                icon: Icon(Icons.home), label: 'Home'),
            const BottomNavigationBarItem(
                icon: Icon(Icons.favorite), label: 'Favourites'),
          ];
        _currentIndex = 0;
    }
    
    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == 1 && !authState.isLoggedIn) {
            // Redirect to login screen if not logged in and trying to access favorites
            AutoRouter.of(context).push(const LoginScreenRoute());
          } else {
            _onTabTapped(index);
          }
        },
        items: items,
      ),
    );
  }
}
