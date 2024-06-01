import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '/common/constants/hive_constants.dart';

enum ThemeModeType { light, dark }


class ThemeNotifier extends StateNotifier<ThemeMode> {
  
  ThemeNotifier(super.initialThemeMode);
  // Initialize the notifier with the theme from the hive


  void toggleTheme() async {
    if (state == ThemeMode.light) {
      state = ThemeMode.dark;
    } else {
      state = ThemeMode.light;
    }
    // Open the hive box and put the value of the theme for persistence
    final box = await Hive.openBox(HiveConstants.themeBoxKey);
    await box.put(HiveConstants.themeModeKey, state.index);
  }

}

final themeNotifierProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>(
  (ref) {
    final initialThemeMode = ref.watch(initialThemeModeProvider);
    return ThemeNotifier(initialThemeMode);
  },
);

// Define an initial theme mode provider
// Used for passing the initial theme in the startup of the app
final initialThemeModeProvider = Provider<ThemeMode>((ref) {
  throw UnimplementedError();
});
