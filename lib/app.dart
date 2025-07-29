import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ours/app_navigation.dart';

class OursApp extends StatelessWidget {
  final String flavor;

  const OursApp({super.key, required this.flavor});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: "Ours application",
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      routerConfig: AppRouter.router,
    );
  }
}
