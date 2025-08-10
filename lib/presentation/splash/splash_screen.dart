import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ours/presentation/resource/theme_provider.dart';
import 'package:ours/presentation/resource/themes.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('testing').snapshots(),
        builder: (
          BuildContext buildContext,
          AsyncSnapshot<QuerySnapshot> snapshots,
        ) {
          final docs = snapshots.data?.docs;
          if (!snapshots.hasData) return SizedBox.shrink();

          return Expanded(
            child: Container(
              color: context.theme.primaryColor,
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: docs?.length,
                      itemBuilder: (BuildContext context, int index) {
                        final data = docs?[index].data() as Map;
                        final item = data['name'];
                        return ListTile(
                          title: Text(
                            item,
                            style: context.theme.textTheme.titleLarge?.copyWith(
                              color: context.theme.customColors?.secondaryColor
                            ),
                          )
                        );
                      },
                    ),
                  ),
                  SafeArea(
                    child: SizedBox(
                      width: double.infinity,
                      child: Container(
                        color: context.theme.customColors?.accentColor,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Wrap(
                            // mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              MaterialButton(
                                color: Colors.amber,
                                onPressed: () {
                                  context.go('/login');
                                },
                                child: Text(buildContext.tr('app.goToLogin')),
                              ),
                              SizedBox(
                                width: 16,
                              ),
                              MaterialButton(
                                color: Colors.amber,
                                onPressed: () {
                                  if (buildContext.locale.toString() == "en_US") {
                                    buildContext.setLocale(Locale('th', 'TH'));
                                  } else {
                                    buildContext.setLocale(Locale('en', 'US'));
                                  }
                                },
                                child: Text(buildContext.tr('app.changeLang')),
                              ),
                              SizedBox(
                                width: 16,
                              ),
                              MaterialButton(
                                color: Colors.amber,
                                onPressed: () {
                                  ref.read(themeStateNotifierProvider.notifier).switchTheme();
                                },
                                child: Text(buildContext.tr('app.changeTheme')),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
