import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:task_app/screens/settings_page.dart';
import 'package:task_app/screens/task_page.dart';
import 'package:task_app/screens/trash_page.dart';
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
    final screenWidth = MediaQuery.of(context).size.width;

    // Responsive metrics
    double bottomBarHeight = screenWidth * 0.26; // ~104 on 400 width
    double iconSize = screenWidth * 0.055; // ~22 on 400 width
    double marginH = screenWidth * 0.125; // ~50 on 400 width
    double paddingH = screenWidth * 0.04; // ~16 on 400 width

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
                padding: EdgeInsets.only(bottom: screenWidth * 0.05), // ~20
                child: Container(
                  height: bottomBarHeight,
                  margin: EdgeInsets.symmetric(horizontal: marginH),
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1.5,
                      color: Colors.grey.withOpacity(0.5),
                    ),
                    color: Theme.of(context)
                        .scaffoldBackgroundColor
                        .withOpacity(0.95),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.symmetric(horizontal: paddingH),
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
                    itemPadding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.03,
                      vertical: screenWidth * 0.015,
                    ),
                    items: [
                      SalomonBottomBarItem(
                        icon: Icon(CupertinoIcons.checkmark_alt,
                            size: iconSize),
                        title: const SizedBox.shrink(),
                        selectedColor: Colors.grey,
                      ),
                      SalomonBottomBarItem(
                        icon:
                            Icon(CupertinoIcons.settings, size: iconSize),
                        title: const SizedBox.shrink(),
                        selectedColor: Colors.grey,
                      ),
                      SalomonBottomBarItem(
                        icon: Icon(CupertinoIcons.trash, size: iconSize),
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
