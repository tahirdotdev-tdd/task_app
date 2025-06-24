import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyTile extends StatelessWidget {
  final String title;
  final bool isChecked;
  final ValueChanged<bool?> onCheckChanged;
  final VoidCallback onDelete;
  final DateTime createdAt;
  final VoidCallback onUpdate;

  const MyTile({
    super.key,
    required this.title,
    required this.isChecked,
    required this.onCheckChanged,
    required this.onDelete,
    required this.createdAt, required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    // Use lazy formatting
    final String formattedDate = DateFormat.yMMMMd().format(createdAt);

    return Material(
      color: Colors.transparent,
      child: Container(
        height: 130,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          // color: Colors.white38,
          border: Border.all(color: Colors.grey, width: .5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          dense: true,
          visualDensity: VisualDensity.compact,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          leading: Checkbox.adaptive(
            value: isChecked,
            onChanged: onCheckChanged,
            activeColor: Colors.grey,
          ),
          title: Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              decoration: isChecked ? TextDecoration.lineThrough : null,
            ),
          ),
          subtitle: Text(
            "Added on $formattedDate",
            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: onUpdate,
                icon: const Icon(CupertinoIcons.pencil, color: Colors.blue),
              ),
              IconButton(
                onPressed: onDelete,
                icon: const Icon(CupertinoIcons.delete, size: 20, color: Colors.redAccent),
                tooltip: 'Delete Task',
              ),
            ],
          )
        ),
      ),
    );
  }
}
