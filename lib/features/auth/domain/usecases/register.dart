import '/core/error/failures.dart';
import '/core/models/either.dart';
import '/core/usecases/usecase.dart';
import '/features/auth/domain/entities/user.dart';
import '/features/auth/domain/repositories/auth_repository.dart';

class Register implements UseCase<User, RegisterParams> {
  final AuthRepository repository;

  Register({required this.repository});

  @override
  Future<Either<Failure, User>> call(RegisterParams params) {
    return repository.register(params.email, params.password);
  }
}

class RegisterParams {
  final String email;
  final String password;

  RegisterParams({required this.email, required this.password});
}
