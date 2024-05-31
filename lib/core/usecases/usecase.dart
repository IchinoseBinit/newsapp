import '/core/error/failures.dart';
import '/core/models/either.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}
