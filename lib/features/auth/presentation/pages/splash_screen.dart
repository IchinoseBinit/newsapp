import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/common/constants/image_constants.dart';
import '/features/auth/presentation/providers/auth_provider.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future.delayed(const Duration(seconds: 2)).then(
      (value) => ref.read(authNotifierProvider.notifier).checkAuthState(context),
    );

    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height - MediaQuery.of(context).viewPadding.top,
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                ImageConstants.logo,
                height: 200,
              ),
              const SizedBox(height: 24),
              const CircularProgressIndicator.adaptive(),
              
            ],
          ),
        ),
      ),
    );
  }
}
