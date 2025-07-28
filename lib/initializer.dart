import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';

Future<void> initialize() async {
  await initialFirebase();
}

Future<void> initialFirebase() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
}
