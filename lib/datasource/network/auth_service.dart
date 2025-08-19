import 'package:firebase_auth/firebase_auth.dart';
import 'package:ours/const/error_code.dart';
import 'package:ours/model/login/mapper/login_user_mapper.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_service.g.dart';

abstract class AuthService {
  Future<User?> login({
    required String email,
    required String password,
  });
}

class AuthServiceImpl extends AuthService {
  @override
  Future<User?> login({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } on FirebaseException catch (e) {
      if (e.code == firebaseErrorUserNotFound) {
        throw Exception("user not found.");
      } else {
        throw Exception("Incorrect username or password.");
      }
    }
  }
}

@Riverpod(keepAlive: true)
AuthService authService(ref) {
  return AuthServiceImpl();
}
