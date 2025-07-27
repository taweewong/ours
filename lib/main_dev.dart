import 'package:flutter/cupertino.dart';
import 'package:ours/initializer.dart';

import 'app.dart';

Future main() async {
  initialize();
  runApp(OursApp(flavor: 'development'));
}