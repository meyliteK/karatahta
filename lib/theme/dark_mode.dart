/*import 'package:flutter/material.dart';

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    surface: Colors.grey.shade900,
    primary: Colors.grey.shade800,
    secondary: Colors.grey.shade700,
    inversePrimary: Colors.grey.shade500,
  ),
  textTheme: ThemeData.dark().textTheme.apply(
        bodyColor: Colors.grey[300],
        displayColor: Colors.white,
      ),
);*/
import 'package:flutter/material.dart';

ThemeData darkMode = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      surface: Colors.grey.shade900,
      primary: Colors.grey.shade800,
      secondary: Colors.grey.shade700,
      inversePrimary: Colors.grey.shade500,
      tertiary: const Color.fromARGB(255, 243, 101, 149),
      inverseSurface: const Color.fromARGB(255, 50, 50, 50),
    ),
    textTheme: ThemeData.dark().textTheme.apply(
          bodyColor: Colors.grey[300],
          displayColor: Colors.white,
        ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: Colors.white),
    ));
