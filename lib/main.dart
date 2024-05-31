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
  await dotenv.load(fileName: "assets/env/.env");
  await Hive.initFlutter();
  await Hive.openBox<List<String>>(HiveConstants.boxKey);

  final box = await Hive.openBox(HiveConstants.themeBoxKey);
  final themeModeIndex =
      box.get(HiveConstants.themeModeKey, defaultValue: ThemeMode.system.index);
  final themeMode = ThemeMode.values[themeModeIndex];

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    ProviderScope(
      overrides: [
        initialThemeModeProvider.overrideWithValue(themeMode),
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
