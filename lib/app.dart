import 'package:flutter/material.dart';

class OursApp extends StatelessWidget {
  final String flavor;

  const OursApp({super.key, required this.flavor});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Ours application",
      home: Scaffold(body: Center(child: Text(flavor))),
    );
  }
}
