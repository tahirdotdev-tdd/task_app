import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

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
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 80, left: 15, right: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text("Settings", style: heading1(context))],
          ),
          const SizedBox(height: 30),

          // Dark Mode Toggle
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(width: 1, color: Colors.grey),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              title: Text("Dark Mode", style: secHead(context)),
              trailing: Consumer<ThemeProvider>(
                builder: (context, themeProvider, child) {
                  return CupertinoSwitch(
                    value: themeProvider.isDarkMode,
                    onChanged: themeProvider.toggleTheme,
                    activeTrackColor: Colors.grey,
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Developer Link
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(width: 1, color: Colors.grey),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              title: Text("Developers", style: secHead(context)),
              trailing: IconButton(
                icon: const Icon(Icons.web_rounded),
                onPressed: () async {
                  try {
                    await platform.invokeMethod('openBrowser', {
                      'url': 'https://hmtahir.webflow.io/',
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
          const SizedBox(height: 20),

          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(width: 1, color: Colors.grey),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              title: Text("Notifications", style: secHead(context)),
              trailing: CupertinoSwitch(
                value: _notificationsEnabled,
                onChanged: (bool value) {
                  setState(() {
                    _notificationsEnabled = value;
                  });

                  Future.delayed(const Duration(milliseconds: 250), () async {
                    try {
                      await Fluttertoast.cancel(); // Clear any previous toast

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
                    } catch (_) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          duration: Duration(microseconds: 950),
                          content: Text(
                            value
                                ? "Notifications Enabled"
                                : "Notifications Disabled",
                          ),
                        ),
                      );
                    }
                  });
                },
                activeTrackColor: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
