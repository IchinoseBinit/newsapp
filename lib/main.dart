import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '/common/constants/hive_constants.dart';
import '/default_firebase_options.dart';
import '/router/app_router.gr.dart';

import '/theme/theme_notifier.dart';
import '/theme/themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Load the dot env file for api key for news
  await dotenv.load(fileName: "assets/env/.env");
  // Initialize hive
  await Hive.initFlutter();
  // Open the box for favorites
  await Hive.openBox<List<String>>(HiveConstants.boxKey);

  // Open the box for theme
  final box = await Hive.openBox(HiveConstants.themeBoxKey);
  final themeModeIndex =
      box.get(HiveConstants.themeModeKey, defaultValue: ThemeMode.system.index);
  // Get the theme index
  final themeMode = ThemeMode.values[themeModeIndex];
  // Initialize the previously saved theme in the variable

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    ProviderScope(
      overrides: [
        initialThemeModeProvider.overrideWithValue(themeMode),
        // Override the default behavior of this provider with the saved theme state
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  MyApp({super.key});

  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeNotifierProvider);

    return MaterialApp.router(
      title: 'News App',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeMode,
      routerDelegate: _appRouter.delegate(),
      routeInformationParser: _appRouter.defaultRouteParser(),
    );
  }
}
