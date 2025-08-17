import 'package:firebase_auth/firebase_auth.dart';
import 'package:ours/const/error_code.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_service.g.dart';

abstract class AuthService {
  Future<AsyncValue<User?>> login({
    required String email,
    required String password,
  });
}

class AuthServiceImpl extends AuthService {
  @override
  Future<AsyncValue<User?>> login({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return AsyncValue.data(credential.user);
    } on FirebaseException catch (e, st) {
      if (e.code == firebaseErrorUserNotFound) {
        return AsyncValue.error(
          Exception("user not found."), st,
        );
      } else {
        return AsyncValue.error(
          Exception("Incorrect username or password."), st,
        );
      }
    }
  }
}

@Riverpod(keepAlive: true)
AuthService authService(ref) {
  return AuthServiceImpl();
}
