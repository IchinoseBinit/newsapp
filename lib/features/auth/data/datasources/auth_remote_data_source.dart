import 'package:firebase_auth/firebase_auth.dart';
import '/features/auth/data/models/user_model.dart';
import '/core/error/exceptions.dart';  // Assuming you have a custom exception file

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
  Future<UserModel> register(String email, String password);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;

  AuthRemoteDataSourceImpl({required this.firebaseAuth});

  @override
  Future<UserModel> login(String email, String password) async {
    try {
      final userCredential = await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      final user = userCredential.user!;
      return UserModel(id: user.uid, name: user.displayName ?? '', email: user.email!);
    } on FirebaseAuthException catch (e) {
      throw ServerException(message: e.message);
    }
  }

  @override
  Future<UserModel> register(String email, String password) async {
    try {
      final userCredential = await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      final user = userCredential.user!;
      return UserModel(id: user.uid, name: user.displayName ?? '', email: user.email!);
    } on FirebaseAuthException catch (e) {
      throw ServerException(message: e.message);
    }
  }
}
