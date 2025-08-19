import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ours/const/error_code.dart';
import 'package:ours/datasource/network/auth_service.dart';
import 'package:ours/model/login/mapper/login_user_mapper.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../model/login/login_user.dart';

part 'auth_repository.g.dart';

abstract class AuthRepository {
  Future<AsyncValue<LoginUser?>> login({
    required String email,
    required String password,
  });
}

class AuthRepositoryImpl extends AuthRepository {
  AuthService service;

  AuthRepositoryImpl(this.service);

  @override
  Future<AsyncValue<LoginUser?>> login({
    required String email,
    required String password,
  }) async {
    return AsyncValue.guard(() async {
      final result = await service.login(email: email, password: password);
      return result?.toLoginUser();
    });
  }
}

@Riverpod(keepAlive: true)
AuthRepository authRepository(ref) {
  AuthService authService = ref.watch(authServiceProvider);
  return AuthRepositoryImpl(authService);
}
