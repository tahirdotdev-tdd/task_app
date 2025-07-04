import 'package:flutter/material.dart';

const MaterialColor blackSwatch = MaterialColor(0xFF000000, <int, Color>{
  50: Color(0xFF000000),
  100: Color(0xFF000000),
  200: Color(0xFF000000),
  300: Color(0xFF000000),
  400: Color(0xFF000000),
  500: Color(0xFF000000),
  600: Color(0xFF000000),
  700: Color(0xFF000000),
  800: Color(0xFF000000),
  900: Color(0xFF000000),
});

const MaterialColor whiteSwatch = MaterialColor(0xFFFFFFFF, <int, Color>{
  50: Color(0xFFFFFFFF),
  100: Color(0xFFFFFFFF),
  200: Color(0xFFFFFFFF),
  300: Color(0xFFFFFFFF),
  400: Color(0xFFFFFFFF),
  500: Color(0xFFFFFFFF),
  600: Color(0xFFFFFFFF),
  700: Color(0xFFFFFFFF),
  800: Color(0xFFFFFFFF),
  900: Color(0xFFFFFFFF),
});

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primarySwatch: blackSwatch,
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: AppBarTheme(backgroundColor: Colors.black),
  textTheme: TextTheme(bodyMedium: TextStyle(color: Colors.black)),
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primarySwatch: whiteSwatch,
  scaffoldBackgroundColor: Color.fromARGB(255, 27, 27, 27),
  appBarTheme: AppBarTheme(backgroundColor: Colors.white),
  textTheme: TextTheme(bodyMedium: TextStyle(color: Colors.white)),
);
