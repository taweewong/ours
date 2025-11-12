import 'package:camera/camera.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ours/presentation/resource/themes.dart';

import '../resource/theme_state.dart';

class ParkingScreen extends ConsumerStatefulWidget {
  const ParkingScreen({super.key});

  @override
  ConsumerState<ParkingScreen> createState() =>
      _ParkingScreenState();
}

class _ParkingScreenState extends ConsumerState<ParkingScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.primaryColor,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MaterialButton(
                color: Colors.amber,
                onPressed: () {
                  context.push('/parking/preview');
                },
                child: Text(context.tr('app.goToParkingPreview')),
              ),
              SizedBox(height: 16),
              MaterialButton(
                color: Colors.amber,
                onPressed: () {
                  context.push('/camera');
                },
                child: Text(context.tr('app.goToParkingCamera')),
              ),
              SizedBox(width: 16),
              MaterialButton(
                color: Colors.amber,
                onPressed: () {
                  if (context.locale.toString() == "en_US") {
                    context.setLocale(Locale('th', 'TH'));
                  } else {
                    context.setLocale(Locale('en', 'US'));
                  }
                },
                child: Text(context.tr('app.changeLang')),
              ),
              SizedBox(width: 16),
              MaterialButton(
                color: Colors.amber,
                onPressed: () {
                  ref.read(themeStateNotifierProvider.notifier).switchTheme();
                },
                child: Text(context.tr('app.changeTheme')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
