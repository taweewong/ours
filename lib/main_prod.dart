import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:ours/initializer.dart';

import 'app.dart';

Future main() async {
  await initialize();
  runApp(
    EasyLocalization(
      path: 'assets/lang',
      supportedLocales: [Locale('en', 'US'), Locale('th', 'TH')],
      fallbackLocale: Locale('en', 'US'),
      child: OursApp(flavor: 'production'),
    ),
  );
}