import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_user.freezed.dart';

part 'login_user.g.dart';

@freezed
@JsonSerializable()
class LoginUser with _$LoginUser {
  @override String uid;
  @override String displayName;
  @override String email;

  LoginUser({
    required this.uid,
    required this.displayName,
    required this.email,
  });

  factory LoginUser.fromJson(Map<String, Object?> json) => _$LoginUserFromJson(json);
  Map<String, Object?> toJson() => _$LoginUserToJson(this);

  factory LoginUser.fromJsonString(String source) =>
      LoginUser.fromJson(jsonDecode(source) as Map<String, dynamic>);

  String toJsonString() => jsonEncode(toJson());
}
