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
    required this.createdAt,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Responsive values
    double fontSize = screenWidth * 0.040; // ~16 on 400 width
    double subtitleSize = screenWidth * 0.032; // ~12
    double paddingH = screenWidth * 0.04; // horizontal padding
    double iconSize = screenWidth * 0.055; // ~22 on 400 width
    double marginV = screenWidth * 0.02;

    final String formattedDate = DateFormat.yMMMMd().format(createdAt);

    return Material(
      color: Colors.transparent,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: paddingH, vertical: marginV),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 0.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          dense: true,
          visualDensity: VisualDensity.compact,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: paddingH,
            vertical: screenWidth * 0.02,
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
              fontSize: fontSize,
              fontWeight: FontWeight.w500,
              decoration: isChecked ? TextDecoration.lineThrough : null,
            ),
          ),
          subtitle: Text(
            "Added on $formattedDate",
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: subtitleSize,
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: onUpdate,
                icon: Icon(
                  CupertinoIcons.pencil,
                  size: iconSize,
                  color: Colors.blue,
                ),
              ),
              IconButton(
                onPressed: onDelete,
                icon: Icon(
                  CupertinoIcons.delete,
                  size: iconSize,
                  color: Colors.redAccent,
                ),
                tooltip: 'Delete Task',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
