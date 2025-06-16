import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TrashTile extends StatelessWidget {
  final String title;
  final DateTime createdAt;
  final VoidCallback onRestore;
  final VoidCallback onPermanentDelete;

  const TrashTile({
    super.key,
    required this.title,
    required this.createdAt,
    required this.onRestore,
    required this.onPermanentDelete,
  });

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat.yMMMMd().format(createdAt);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: .5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w500)),
          const SizedBox(height: 6),
          Text("Deleted on $formattedDate",
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                onPressed: onRestore,
                icon: const Icon(Icons.restore, color: Colors.green),
                label: const Text("Restore"),
              ),
              const SizedBox(width: 10),
              TextButton.icon(
                onPressed: onPermanentDelete,
                icon: const Icon(Icons.delete_forever, color: Colors.red),
                label: const Text("Delete"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
