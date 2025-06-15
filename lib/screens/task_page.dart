import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              // Avoid overflow
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("New Task", style: secHead(context)),
                  const SizedBox(height: 15),
                  TextField(
                    controller: _taskController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: "Task Details",
                      labelStyle: secHead(context),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () async {
                        final task = _taskController.text.trim();
                        if (task.isEmpty) return;

                        await FirebaseFirestore.instance
                            .collection('tasks')
                            .add({
                              'task': task,
                              'isDone': false,
                              'createdAt': Timestamp.now(),
                            });

                        Navigator.pop(context);
                      },
                      child: Text("Add", style: secHead(context)),
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

  void deleteTask(String id) {
    FirebaseFirestore.instance.collection('tasks').doc(id).delete();
  }

  void updateTaskStatus(String id, bool isChecked) {
    FirebaseFirestore.instance.collection('tasks').doc(id).update({
      'isDone': isChecked,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 80, left: 15, right: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Tasks", style: heading1(context)),
              FloatingActionButton(
                onPressed: addTaskDialog,
                backgroundColor: Colors.black87,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(width: 1, color: Colors.white38),
                ),
                child: Icon(Icons.add, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Realtime Task List
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('tasks')
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError)
                  return Center(
                    child: Text("Error loading tasks", style: secHead(context)),
                  );
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final docs = snapshot.data!.docs;

                if (docs.isEmpty) {
                  return Center(
                    child: Text(
                      "No tasks yet.",
                      style: GoogleFonts.poppins(
                        fontSize: 18,
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
                      key: ValueKey(
                        doc.id,
                      ), // 🔑 helps Flutter track widget identity
                      title: taskText,
                      isChecked: isDone,
                      onCheckChanged: (value) =>
                          updateTaskStatus(doc.id, value ?? false),
                      onDelete: () => deleteTask(doc.id),
                      createdAt: createdAt,
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
