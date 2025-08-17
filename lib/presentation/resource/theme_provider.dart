import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../const/shared_pref_key.dart';

part 'theme_provider.g.dart';

@riverpod
class ThemeStateNotifier extends _$ThemeStateNotifier {

  static const String light = "light";
  static const String dark = "dark";

  @override
  Future<String> build() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var savedTheme = sharedPreferences.getString(keyTheme) ?? light;
    state = AsyncValue.data(savedTheme);
    return state.value ?? light;
  }

  void switchTheme() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    switch (state.value) {
      case light:
        sharedPreferences.setString(keyTheme, dark);
        state = AsyncValue.data(dark);
        break;
      default:
        sharedPreferences.setString(keyTheme, light);
        state = AsyncValue.data(light);
        break;
    }
  }
}