import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:task_app/screens/settings_page.dart';
import 'package:task_app/screens/task_page.dart';
import 'package:task_app/styles/text_styles.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    TaskPage(key: ValueKey('Tasks')),
    SettingsPage(key: ValueKey('Settings')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: SalomonBottomBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          items: [
            SalomonBottomBarItem(
              icon: const Icon(Icons.task_alt),
              title: Text("Tasks", style: navText(context)),
              selectedColor: Colors.grey,
            ),
            SalomonBottomBarItem(
              icon: const Icon(Icons.settings),
              title: Text("Settings", style: navText(context)),
              selectedColor: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
