import 'package:flutter/cupertino.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'theme_provider.g.dart';

@riverpod
class ThemeStateNotifier extends _$ThemeStateNotifier {

  static const String light = "light";
  static const String dark = "dark";

  @override
  String build() {
    state = light;
    return state;
  }

  void switchTheme() {
    switch (state) {
      case light:
        state = dark;
        break;
      default:
        state = light;
        break;
    }
  }
}