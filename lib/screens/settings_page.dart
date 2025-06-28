import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:task_app/components/digital_flip_clock.dart';
import 'package:task_app/services/noti_service.dart';

import '../providers/theme_provider.dart';
import '../styles/text_styles.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  static const platform = MethodChannel('com.tahirdotdev.browser');
  bool _notificationsEnabled = false;

  @override
  void initState() {
    super.initState();
    loadNotificationSetting();
  }

  Future<void> loadNotificationSetting() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();
    if (doc.exists) {
      final settings = doc.data()?['settings'];
      if (settings != null && settings['notificationsEnabled'] != null) {
        setState(() {
          _notificationsEnabled = settings['notificationsEnabled'];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Responsive padding and sizes
    double topPadding = screenWidth * 0.2; // ~80 on 400 width
    double sidePadding = screenWidth * 0.04; // ~15
    double tilePaddingV = screenWidth * 0.025; // ~10
    double tilePaddingH = screenWidth * 0.05; // ~20
    double spacing = screenWidth * 0.05; // ~20
    double headingFontSize = screenWidth * 0.06; // ~24
    double subHeadingFontSize = screenWidth * 0.045; // ~18

    return Padding(
      padding: EdgeInsets.only(
        top: topPadding,
        left: sidePadding,
        right: sidePadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Settings",
                style: heading1(context).copyWith(fontSize: headingFontSize),
              ),
            ],
          ),

          DigitalFlipClock(),
          SizedBox(height: spacing * 1.5),

          // Dark Mode Toggle
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(width: 1, color: Colors.grey),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(
                horizontal: tilePaddingH,
                vertical: tilePaddingV,
              ),
              title: Text(
                "Dark Mode",
                style: secHead(context).copyWith(fontSize: subHeadingFontSize),
              ),
              trailing: Consumer<ThemeProvider>(
                builder: (context, themeProvider, child) {
                  return CupertinoSwitch(
                    value: themeProvider.isDarkMode,
                    onChanged: themeProvider.toggleTheme,
                    activeTrackColor: Colors.greenAccent,
                    inactiveTrackColor: Colors.redAccent,
                  );
                },
              ),
            ),
          ),
          SizedBox(height: spacing),

          // Developer Link
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(width: 1, color: Colors.grey),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(
                horizontal: tilePaddingH,
                vertical: tilePaddingV,
              ),
              title: Text(
                "Developers",
                style: secHead(context).copyWith(fontSize: subHeadingFontSize),
              ),
              trailing: IconButton(
                icon: const Icon(CupertinoIcons.right_chevron),
                onPressed: () async {
                  try {
                    await platform.invokeMethod('openBrowser', {
                      'url': 'https://bit.ly/tahirhassan',
                    });
                  } on PlatformException catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Error: ${e.message}")),
                    );
                  }
                },
              ),
            ),
          ),
          SizedBox(height: spacing),

          // Notification Toggle
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(width: 1, color: Colors.grey),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(
                horizontal: tilePaddingH,
                vertical: tilePaddingV,
              ),
              title: Text(
                "Notifications",
                style: secHead(context).copyWith(fontSize: subHeadingFontSize),
              ),
              trailing: CupertinoSwitch(
                value: _notificationsEnabled,
                onChanged: (bool value) async {
                  setState(() {
                    _notificationsEnabled = value;
                  });

                  final uid = FirebaseAuth.instance.currentUser!.uid;
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(uid)
                      .set({
                        'settings': {'notificationsEnabled': value},
                      }, SetOptions(merge: true));

                  if (value) {
                    await NotiService().showNotification(
                      id: 1,
                      title: "TASK APP",
                      body: "Task notifications enabled.",
                    );
                  } else {
                    await NotiService().cancelAllNotifications();
                  }

                  Fluttertoast.cancel();
                  Fluttertoast.showToast(
                    msg: value
                        ? "Notifications Enabled"
                        : "Notifications Disabled",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Colors.black87,
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
                },

                activeTrackColor: Colors.greenAccent,
                inactiveTrackColor: Colors.redAccent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
