import '/core/error/failures.dart';
import '/core/error/exceptions.dart';
import '/features/auth/data/datasources/auth_remote_data_source.dart';
import '/features/auth/domain/entities/user.dart';
import '/features/auth/domain/repositories/auth_repository.dart';
import '/core/models/either.dart';  

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, User>> login(String email, String password) async {
    try {
      final user = await remoteDataSource.login(email, password);
      return Right(user);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, User>> register(String email, String password) async {
    try {
      final user = await remoteDataSource.register(email, password);
      return Right(user);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Unexpected error occurred'));
    }
  }
}
