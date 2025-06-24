import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_app/providers/theme_provider.dart';
import 'package:task_app/screens/splash_screen.dart';
import 'package:task_app/services/noti_service.dart';
import 'package:task_app/styles/themes.dart';
import 'package:task_app/utils/internet_checker.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NotiService().init();
  await Firebase.initializeApp();
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const InternetChecker(child: MyApp()),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeProvider.themeMode,
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}