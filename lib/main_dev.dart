import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:ours/initializer.dart';

import 'app.dart';

Future main() async {
  initialize();
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  runApp(OursApp(flavor: 'development'));
}