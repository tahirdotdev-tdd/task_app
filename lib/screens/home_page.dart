import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:task_app/screens/settings_page.dart';
import 'package:task_app/screens/task_page.dart';
import 'package:task_app/styles/text_styles.dart';
import 'package:task_app/utils/internet_checker.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  bool _dialogShown = false;

  final List<Widget> _pages = const [
    TaskPage(key: ValueKey('Tasks')),
    SettingsPage(key: ValueKey('Settings')),
  ];

  @override
  void initState() {
    super.initState();
    _checkInitialConnectivity();
    Connectivity().onConnectivityChanged.listen((result) {
      final hasConnection = result != ConnectivityResult.none;
      if (!hasConnection && !_dialogShown) {
        _showNoInternetDialog();
      } else if (hasConnection && _dialogShown) {
        Navigator.of(context, rootNavigator: true).pop();
        _dialogShown = false;
      }
    });
  }

  Future<void> _checkInitialConnectivity() async {
    bool connected = await InternetChecker.isConnected();
    if (!connected && !_dialogShown) {
      _showNoInternetDialog();
    }
  }

  void _showNoInternetDialog() {
    _dialogShown = true;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('No Internet Connection'),
        content: const Text('Please connect to the internet and retry.'),
        actions: [
          TextButton(
            onPressed: () async {
              final connected = await InternetChecker.isConnected();
              if (connected) {
                Navigator.of(context).pop();
                _dialogShown = false;
              }
            },
            child: const Text('Retry'),
          )
        ],
      ),
    );
  }

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
