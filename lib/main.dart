import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_app/components/onboarding_screen.dart';
import 'package:task_app/providers/theme_provider.dart';
import 'package:task_app/screens/home_page.dart';
import 'package:task_app/services/noti_service.dart';
import 'package:task_app/styles/themes.dart';
import 'package:task_app/utils/internet_checker.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NotiService().init();
  await Firebase.initializeApp();
  await FirebaseAuth.instance.signInAnonymously();

  final prefs = await SharedPreferences.getInstance();
  final seenOnboarding = prefs.getBool('seenOnboarding') ?? false;

  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: InternetChecker(
        child: MyApp(seenOnboarding: seenOnboarding),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool seenOnboarding;
  const MyApp({super.key, required this.seenOnboarding});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeProvider.themeMode,
      debugShowCheckedModeBanner: false,
      home: seenOnboarding ? const HomePage() : const OnboardingScreen(),
      routes: {'/home': (context) => const HomePage()},
    );
  }
}
