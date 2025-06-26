import 'package:flutter/cupertino.dart';
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
    final screenWidth = MediaQuery.of(context).size.width;

    // Responsive dimensions
    double fontSize = screenWidth * 0.040; // ~16 on 400 width
    double dateFontSize = screenWidth * 0.032; // ~12
    double paddingAll = screenWidth * 0.03;
    double iconSize = screenWidth * 0.05;
    double spacing = screenWidth * 0.025;

    final formattedDate = DateFormat.yMMMMd().format(createdAt);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: paddingAll, vertical: spacing),
      padding: EdgeInsets.all(paddingAll),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: spacing),
          Text(
            "Deleted on $formattedDate",
            style: TextStyle(color: Colors.grey.shade600, fontSize: dateFontSize),
          ),
          SizedBox(height: spacing * 1.5),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                onPressed: onRestore,
                icon: Icon(CupertinoIcons.gobackward, color: Colors.green, size: iconSize),
                label: Text(
                  "Restore",
                  style: TextStyle(fontSize: dateFontSize),
                ),
              ),
              SizedBox(width: spacing),
              TextButton.icon(
                onPressed: onPermanentDelete,
                icon: Icon(CupertinoIcons.delete_solid, color: Colors.red, size: iconSize),
                label: Text(
                  "Delete",
                  style: TextStyle(fontSize: dateFontSize),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
