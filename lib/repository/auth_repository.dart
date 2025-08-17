import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ours/const/error_code.dart';
import 'package:ours/datasource/network/auth_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_repository.g.dart';

abstract class AuthRepository {
  Future<AsyncValue<User?>> login({required String email, required String password});
}

class AuthRepositoryImpl extends AuthRepository {
  AuthService service;

  AuthRepositoryImpl(this.service);

  @override
  Future<AsyncValue<User?>> login({
    required String email,
    required String password,
  }) async {
    return service.login(email: email, password: password);
  }
}

@Riverpod(keepAlive: true)
AuthRepository authRepository(ref) {
  AuthService authService = ref.watch(authServiceProvider);
  return AuthRepositoryImpl(authService);
}
