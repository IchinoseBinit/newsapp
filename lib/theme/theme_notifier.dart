import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '/common/constants/hive_constants.dart';

enum ThemeModeType { light, dark }


class ThemeNotifier extends StateNotifier<ThemeMode> {
  
  ThemeNotifier(super.initialThemeMode);


  void toggleTheme() async {
    if (state == ThemeMode.light) {
      state = ThemeMode.dark;
    } else {
      state = ThemeMode.light;
    }


    final box = await Hive.openBox(HiveConstants.themeBoxKey);
    await box.put(HiveConstants.themeModeKey, state.index);
  }

  void setThemeMode(ThemeMode mode) async {
    state = mode;
  }
}

final themeNotifierProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>(
  (ref) {
    final initialThemeMode = ref.watch(initialThemeModeProvider);
    return ThemeNotifier(initialThemeMode);
  },
);

// Define an initial theme mode provider
final initialThemeModeProvider = Provider<ThemeMode>((ref) {
  throw UnimplementedError();
});
