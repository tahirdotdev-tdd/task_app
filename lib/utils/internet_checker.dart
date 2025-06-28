import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class InternetChecker extends StatefulWidget {
  final Widget child;
  const InternetChecker({super.key, required this.child});

  static Future<bool> isConnected() async {
    final result = await Connectivity().checkConnectivity();
    return result != ConnectivityResult.none;
  }

  @override
  State<InternetChecker> createState() => _InternetCheckerState();
}

class _InternetCheckerState extends State<InternetChecker> {
 bool _isConnected = true;
  bool _dialogShown = false;

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
      builder: (_) => AlertDialog(
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
    return widget.child;
  }
}
