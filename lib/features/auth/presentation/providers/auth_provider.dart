import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/router/app_router.gr.dart';

import '/core/error/failures.dart';
import '/features/auth/data/datasources/auth_remote_data_source.dart';
import '/features/auth/data/repositories/auth_repository_impl.dart';
import '/features/auth/domain/entities/user.dart' as us;
import '/features/auth/domain/repositories/auth_repository.dart';
import '/features/auth/domain/usecases/login.dart';
import '/features/auth/domain/usecases/register.dart';

// AuthState
abstract class AuthState {
  final bool isLoggedIn;

  AuthState({required this.isLoggedIn});
}

class AuthInitial extends AuthState {
  AuthInitial() : super(isLoggedIn: false);
}

class AuthLoading extends AuthState {
  AuthLoading() : super(isLoggedIn: false);
}

class Authenticated extends AuthState {
  final us.User user;

  Authenticated({required this.user}) : super(isLoggedIn: true);
}

class AuthError extends AuthState {
  final String message;

  AuthError({required this.message}) : super(isLoggedIn: false);
}

// Providers
final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSourceImpl(firebaseAuth: ref.read(firebaseAuthProvider));
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
      remoteDataSource: ref.read(authRemoteDataSourceProvider));
});

final loginUseCaseProvider = Provider<Login>((ref) {
  return Login(repository: ref.read(authRepositoryProvider));
});

final registerUseCaseProvider = Provider<Register>((ref) {
  return Register(repository: ref.read(authRepositoryProvider));
});

// StateNotifier
class AuthNotifier extends StateNotifier<AuthState> {
  final Login login;
  final Register register;

  AuthNotifier({
    required this.login,
    required this.register,
  }) : super(AuthInitial());

  Future<void> checkAuthState(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final authUser = us.User(
          id: user.uid, email: user.email ?? '', name: user.displayName ?? '');
      state = Authenticated(user: authUser);
    } else {
      state = AuthInitial();
    }
    AutoRouter.of(context).replace(const HomeScreenRoute());
  }

  Future<void> loginUser(
    BuildContext context, {
    required String email,
    required String password,
  }) async {
    state = AuthLoading();
    final result = await login(LoginParams(email: email, password: password));
    state = result.fold(
      (failure) => AuthError(message: _mapFailureToMessage(failure)),
      (user) {
        AutoRouter.of(context).replaceAll([const HomeScreenRoute()]);
        return Authenticated(user: user);
      },
    );
  }

  Future<void> registerUser(
    BuildContext context, {
    required String email,
    required String password,
  }) async {
    state = AuthLoading();
    final result =
        await register(RegisterParams(email: email, password: password));
    state = result.fold(
      (failure) => AuthError(message: _mapFailureToMessage(failure)),
      (user) {
        AutoRouter.of(context).replaceAll([const HomeScreenRoute()]);

        return Authenticated(user: user);
      },
    );
  }

  Future<void> logoutUser() async {
    state = AuthLoading();
    try {
      await FirebaseAuth.instance.signOut();

      state = AuthInitial();
    } catch (e) {
      state = AuthError(message: 'Logout Failed');
    }
  }

  String _mapFailureToMessage(Failure failure) {
    return switch (failure) {
      ServerFailure() => failure.toString(),
      _ => 'Unexpected Error',
    };
  }
}

final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) {

  return AuthNotifier(
    login: ref.read(loginUseCaseProvider),
    register: ref.read(registerUseCaseProvider),
  );
});
