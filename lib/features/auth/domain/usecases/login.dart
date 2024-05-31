import '/core/models/either.dart';
import '/features/auth/domain/entities/user.dart';
import '/features/auth/domain/repositories/auth_repository.dart';

import '/core/error/failures.dart';
import '/core/usecases/usecase.dart';

class Login implements UseCase<User, LoginParams> {
  final AuthRepository repository;

  Login({required this.repository});

  @override
  Future<Either<Failure, User>> call(LoginParams params) {
    return repository.login(params.email, params.password);
  }
}

class LoginParams {
  final String email;
  final String password;

  LoginParams({required this.email, required this.password});
}
