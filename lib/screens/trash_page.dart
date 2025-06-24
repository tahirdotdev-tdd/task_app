import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:task_app/components/digital_flip_clock.dart';

import '../components/trash_tile.dart';
import '../styles/text_styles.dart'; // Import your tile

class TrashPage extends StatelessWidget {
  const TrashPage({super.key});

  void restoreTask(String id) {
    FirebaseFirestore.instance.collection('tasks').doc(id).update({
      'isTrashed': false,
    });
  }

  void permanentlyDelete(String id) {
    FirebaseFirestore.instance.collection('tasks').doc(id).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: const Text("Trash",style:TextStyle(color: Colors.white),)),
      //
      body: Padding(
        padding: const EdgeInsets.only(top: 80, left: 15, right: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Trash", style: heading1(context))],
            ),

            DigitalFlipClock(),
            const SizedBox(height: 20),
            Text(
              "Deleted tasks will appear here. You can restore or permanently delete them.",
              style: paraText(context),
              textAlign: TextAlign.left,
            ),

            // This Flexible avoids conflict with unbounded height
            Flexible(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('tasks')
                    .where('isTrashed', isEqualTo: true)
                    .orderBy('createdAt', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(child: Text("Error loading trash"));
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final docs = snapshot.data!.docs;
                  if (docs.isEmpty) {
                    return const Center(child: Text("Trash is empty"));
                  }

                  return ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final doc = docs[index];
                      final data = doc.data()! as Map<String, dynamic>;
                      final title = data['task'] ?? "No content";
                      final createdAt =
                          (data['createdAt'] as Timestamp?)?.toDate() ??
                          DateTime.now();

                      return TrashTile(
                        key: ValueKey(doc.id),
                        title: title,
                        createdAt: createdAt,
                        onRestore: () {
                          FirebaseFirestore.instance
                              .collection('tasks')
                              .doc(doc.id)
                              .update({'isTrashed': false});
                        },
                        onPermanentDelete: () {
                          FirebaseFirestore.instance
                              .collection('tasks')
                              .doc(doc.id)
                              .delete();
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/*

 */
