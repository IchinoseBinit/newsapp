import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import '/features/auth/presentation/pages/splash_screen.dart';
import '/features/home/presentation/pages/home_screen.dart';

import '/features/auth/presentation/pages/login_screen.dart';
import '/features/auth/presentation/pages/register_screen.dart';

@MaterialAutoRouter(
  routes: <AutoRoute>[
    AutoRoute(page: SplashScreen, initial: true),
    AutoRoute(page: HomeScreen),
    AutoRoute(page: LoginScreen),
    AutoRoute(page: RegisterScreen),
  ],
)
class $AppRouter {}
