import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';

void initialize() async {
  initialFirebase();
}

void initialFirebase() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
}