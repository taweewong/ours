import 'package:firebase_auth/firebase_auth.dart';

import '../login_user.dart';

extension UserToLoginUserMapper on User? {
  LoginUser toLoginUser() {
    return LoginUser(
      uid: this?.uid ?? '',
      displayName: this?.displayName ?? '',
      email: this?.email ?? '',
    );
  }
}
