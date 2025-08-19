import 'package:firebase_auth/firebase_auth.dart';
import 'package:ours/const/shared_pref_key.dart';
import 'package:ours/model/login/login_user.dart';
import 'package:ours/repository/auth_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'login_state.g.dart';

@riverpod
class LoginStateNotifier extends _$LoginStateNotifier {

  @override
  FutureOr<LoginUser?> build() {
    return _getCredential();
  }

  void login({required String email, required String password}) async {
    state = const AsyncValue.loading();

    AuthRepository authRepository = ref.watch(authRepositoryProvider);
    AsyncValue<LoginUser?>? result = await authRepository.login(email: email, password: password);

    if (result.hasValue) {
      _saveCredential(result.value);
    }

    state = result;
  }

  void _saveCredential(LoginUser? user) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(keyCredential, user?.toJsonString() ?? '');
  }

  Future<LoginUser?> _getCredential() async {
    try {
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      String? credential = sharedPreferences.getString(keyCredential);
      if (credential != null && credential.isNotEmpty) {
        LoginUser user = LoginUser.fromJsonString(sharedPreferences.getString(keyCredential) ?? '');
        return user;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
