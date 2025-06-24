import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:task_app/screens/settings_page.dart';
import 'package:task_app/screens/task_page.dart';
import 'package:task_app/screens/trash_page.dart';
import 'package:task_app/styles/text_styles.dart';
import 'package:task_app/utils/internet_checker.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final PageController _pageController;
  int _currentIndex = 0;
  bool _dialogShown = false;

  final List<Widget> _pages = const [
    TaskPage(key: ValueKey('Tasks')),
    SettingsPage(key: ValueKey('Settings')),
    TrashPage(key: ValueKey('Trash')),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
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

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
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
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            children: _pages,
          ),
          SafeArea(
            bottom: true,
            top: false,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Container(
                  height: 116,
                  margin: const EdgeInsets.symmetric(horizontal: 50),
                  decoration: BoxDecoration(
                    border: Border.all(width: 1.5, color: Colors.grey.withOpacity(0.5)),
                    color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.95),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SalomonBottomBar(
                    backgroundColor: Colors.transparent,
                    currentIndex: _currentIndex,
                    onTap: (index) {
                      setState(() => _currentIndex = index);
                      _pageController.animateToPage(
                        index,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    itemShape: const StadiumBorder(),
                    itemPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0), // reduce vertical padding
                    items: [
                      SalomonBottomBarItem(
                        icon: const Center(
                          child: Icon(CupertinoIcons.checkmark_alt, size: 22),
                        ),
                        title: const SizedBox.shrink(),
                        selectedColor: Colors.grey,
                      ),
                      SalomonBottomBarItem(
                        icon: const Center(
                          child: Icon(CupertinoIcons.settings, size: 22),
                        ),
                        title: const SizedBox.shrink(),
                        selectedColor: Colors.grey,
                      ),
                      SalomonBottomBarItem(
                        icon: const Center(
                          child: Icon(CupertinoIcons.trash, size: 22),
                        ),
                        title: const SizedBox.shrink(),
                        selectedColor: Colors.grey,
                      ),
                    ],
                  ),
                ),


              ),
            ),
          )

        ],
      ),
    );
  }
}
