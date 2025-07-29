import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: docs?.length,
                    itemBuilder: (BuildContext context, int index) {
                      final data = docs?[index].data() as Map;
                      final item = data['name'];
                      return ListTile(title: Text(item));
                    },
                  ),
                ),
                SafeArea(
                  child: SizedBox(
                    height: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
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
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
