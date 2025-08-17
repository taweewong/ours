import 'package:firebase_auth/firebase_auth.dart';
import 'package:ours/repository/auth_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'login_state.g.dart';

@riverpod
class LoginStateNotifier extends _$LoginStateNotifier {

  @override
  FutureOr<User?> build() {
    return null;
  }

  void login({required String email, required String password}) async {
    state = const AsyncValue.loading();

    AuthRepository authRepository = ref.watch(authRepositoryProvider);
    state = await authRepository.login(email: email, password: password);
  }
}
