import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OursApp extends StatelessWidget {
  final String flavor;

  const OursApp({super.key, required this.flavor});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Ours application",
      home: Scaffold(
        body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('testing').snapshots(),
          builder: (
            BuildContext buildContext,
            AsyncSnapshot<QuerySnapshot> snapshots,
          ) {
            final docs = snapshots.data?.docs;
            if (!snapshots.hasData) return SizedBox.shrink();
            return ListView.builder(
              itemCount: docs?.length,
              itemBuilder: (BuildContext context, int index) {
                final data = docs?[index].data() as Map;
                final item = data['name'];
                return ListTile(title: Text(item));
              },
            );
          },
        ),
      ),
    );
  }
}
