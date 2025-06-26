import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:task_app/components/digital_flip_clock.dart';

import '../components/trash_tile.dart';
import '../styles/text_styles.dart';

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
    final screenWidth = MediaQuery.of(context).size.width;
    final topPadding = screenWidth * 0.2;
    final sidePadding = screenWidth * 0.04;
    final titleFontSize = screenWidth * 0.06;
    final infoFontSize = screenWidth * 0.04;
    final cardPadding = screenWidth * 0.02;

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: topPadding, left: sidePadding, right: sidePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Trash", style: heading1(context).copyWith(fontSize: titleFontSize)),
              ],
            ),

            DigitalFlipClock(),
            SizedBox(height: screenWidth * 0.05),

            Container(
              padding: EdgeInsets.all(cardPadding),
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.black87),
                borderRadius: BorderRadius.circular(50),
                color: Colors.blueGrey,
              ),
              child: Text(
                "Deleted tasks will appear here. You can restore or permanently delete them.",
                style: paraText(context).copyWith(fontSize: infoFontSize),
                textAlign: TextAlign.center,
              ),
            ),

            SizedBox(height: screenWidth * 0.05),

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
                          (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now();

                      return TrashTile(
                        key: ValueKey(doc.id),
                        title: title,
                        createdAt: createdAt,
                        onRestore: () => restoreTask(doc.id),
                        onPermanentDelete: () => permanentlyDelete(doc.id),
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
