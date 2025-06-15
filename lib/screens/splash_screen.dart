import 'dart:async';

import 'package:flutter/material.dart';
import 'package:task_app/screens/home_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _textController;
  late Animation<double> _textAnimation;

  @override
  void initState() {
    super.initState();
    _textController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    );

    _textAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_textController);

    _textController.forward();

    Timer(Duration(seconds: 6), () {
      Navigator.of(
        context,
      ).pushReplacement(FadePageRoute(builder: (context) => HomePage()));
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Center(
        child: FadeTransition(
          opacity: _textAnimation,
          child: Text(
            "Task App",
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class FadePageRoute extends PageRouteBuilder {
  final WidgetBuilder builder;

  FadePageRoute({required this.builder})
    : super(
        pageBuilder: (context, animation, secondaryAnimation) =>
            builder(context),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;

          var tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(position: offsetAnimation, child: child);
        },
      );
}
