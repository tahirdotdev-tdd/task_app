import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_app/components/digital_flip_clock.dart';
import 'package:task_app/components/my_tile.dart';

import '../styles/text_styles.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  final TextEditingController _taskController = TextEditingController();

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  void addTaskDialog() {
    _taskController.clear();
    final screenWidth = MediaQuery.of(context).size.width;
    final fontSize = screenWidth * 0.045;
    final padding = screenWidth * 0.05;

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 1,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: EdgeInsets.all(padding),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("New Task", style: secHead(context).copyWith(fontSize: fontSize)),
                  SizedBox(height: padding * 0.75),
                  TextField(
                    controller: _taskController,
                    maxLines: 3,
                    style: Theme.of(context).textTheme.bodyMedium,
                    decoration: InputDecoration(
                      labelText: "Task Details",
                      labelStyle: secHead(context).copyWith(fontSize: fontSize * 0.9),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: padding),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        foregroundColor: Colors.black54,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () async {
                        final task = _taskController.text.trim();
                        if (task.isEmpty) return;

                        await FirebaseFirestore.instance.collection('tasks').add({
                          'task': task,
                          'isDone': false,
                          'isTrashed': false,
                          'createdAt': Timestamp.now(),
                        });

                        Navigator.pop(context);
                      },
                      child: Text("Add", style: secHead(context).copyWith(fontSize: fontSize)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void showUpdateDialog(String docId, String oldTitle) {
    TextEditingController controller = TextEditingController(text: oldTitle);
    final screenWidth = MediaQuery.of(context).size.width;
    final fontSize = screenWidth * 0.045;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Edit Task", style: TextStyle(fontSize: fontSize)),
        content: TextField(
          controller: controller,
          style: TextStyle(fontSize: fontSize),
        ),
        actions: [
          TextButton(
            onPressed: () {
              updateTaskInFirestore(docId, controller.text);
              Navigator.pop(context);
            },
            child: Text("Update", style: TextStyle(fontSize: fontSize)),
          )
        ],
      ),
    );
  }

  void updateTaskInFirestore(String docId, String newTitle) async {
    await FirebaseFirestore.instance.collection('tasks').doc(docId).update({
      'task': newTitle,
      'updatedAt': DateTime.now(),
    });
  }

  void deleteTask(String id) {
    FirebaseFirestore.instance.collection('tasks').doc(id).update({
      'isTrashed': true,
    });
  }

  void updateTaskStatus(String id, bool isChecked) {
    FirebaseFirestore.instance.collection('tasks').doc(id).update({
      'isDone': isChecked,
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final topPadding = screenWidth * 0.2;
    final sidePadding = screenWidth * 0.04;
    final titleFontSize = screenWidth * 0.06;

    return Padding(
      padding: EdgeInsets.only(top: topPadding, left: sidePadding, right: sidePadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Tasks", style: heading1(context).copyWith(fontSize: titleFontSize)),
              FloatingActionButton(
                onPressed: addTaskDialog,
                backgroundColor: Colors.black87,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: const BorderSide(width: 1, color: Colors.white38),
                ),
                child: Icon(CupertinoIcons.add, color: Colors.white, size: screenWidth * 0.06),
              ),
            ],
          ),
          DigitalFlipClock(),
          // Realtime Task List
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('tasks')
                  .where('isTrashed', isEqualTo: false)
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text("Error loading tasks", style: secHead(context)),
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final docs = snapshot.data!.docs;

                if (docs.isEmpty) {
                  return Center(
                    child: Text(
                      "No tasks yet.",
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.045,
                        color: Colors.grey,
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final doc = docs[index];
                    final data = doc.data()! as Map<String, dynamic>;
                    final taskText = data['task'] ?? "No content";
                    final isDone = data['isDone'] ?? false;
                    final createdAt = (data['createdAt'] as Timestamp).toDate();

                    return MyTile(
                      key: ValueKey(doc.id),
                      title: taskText,
                      isChecked: isDone,
                      onCheckChanged: (value) => updateTaskStatus(doc.id, value ?? false),
                      onDelete: () => deleteTask(doc.id),
                      createdAt: createdAt,
                      onUpdate: () => showUpdateDialog(doc.id, taskText),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
