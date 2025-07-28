import 'package:flutter/material.dart';
import 'package:ours/app_navigation.dart';

class OursApp extends StatelessWidget {
  final String flavor;

  const OursApp({super.key, required this.flavor});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: "Ours application",
      routerConfig: AppRouter.router,
    );
  }
}
