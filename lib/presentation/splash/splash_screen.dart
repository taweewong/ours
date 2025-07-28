import 'package:cloud_firestore/cloud_firestore.dart';
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
                    child: MaterialButton(
                      onPressed: () {
                        context.go('/login');
                      },
                      child: Text("go to login"),
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
