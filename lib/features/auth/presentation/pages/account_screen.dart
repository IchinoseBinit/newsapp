import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/features/auth/presentation/providers/auth_provider.dart';
import '/theme/theme_notifier.dart';

class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    final themeMode = ref.watch(themeNotifierProvider);
  

    return Scaffold(
      appBar: AppBar(title: const Text("Account")),
      body: Column(
        children: [
          if (authState is Authenticated)
            Column(
              children: [
                Text("Name: ${authState.user.name}"),
                Text("Email: ${authState.user.email}"),
              ],
            ),
          ElevatedButton(
            onPressed: () {
              ref.read(authNotifierProvider.notifier).logoutUser();
            },
            child: const Text("Logout"),
          ),
          SwitchListTile(
            title: const Text("Dark Theme"),
            value: themeMode == ThemeMode.dark,
            onChanged: (val) {
              ref.read(themeNotifierProvider.notifier).toggleTheme();
            },
          ),
          if (authState is AuthLoading) const CircularProgressIndicator(),
            if (authState is AuthError)
              Text(authState.message, style: const TextStyle(color: Colors.red)),
        ],
      ),
    );
  }
}
