import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  ThemeMode get themeMode => _themeMode;

  bool get isDarkMode => _themeMode == ThemeMode.dark;

  ThemeProvider() {
    _loadThemeFromFirestore();
  }

  void toggleTheme(bool val) {
    _themeMode = val ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
    _saveThemeToFirestore(val);
  }

  Future<void> _saveThemeToFirestore(bool isDark) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
      'settings': {
        'darkMode': isDark,
      }
    }, SetOptions(merge: true));
  }

  Future<void> _loadThemeFromFirestore() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final doc =
        await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

    if (doc.exists) {
      final settings = doc.data()?['settings'];
      if (settings != null && settings['darkMode'] != null) {
        final isDark = settings['darkMode'] as bool;
        _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
        notifyListeners();
      }
    }
  }
}
