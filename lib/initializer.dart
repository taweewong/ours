import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';

Future<void> initialize() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initialFirebase();
  await initialLocalization();
}

Future<void> initialFirebase() async {
  await Firebase.initializeApp();
}

Future<void> initialLocalization() async {
  await EasyLocalization.ensureInitialized();
}
