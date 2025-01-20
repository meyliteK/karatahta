import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      surface: Colors.grey.shade300,     
      secondary: Colors.grey.shade400,
      primary: Colors.grey.shade200,
      inversePrimary: Colors.grey.shade600,
      tertiary: const Color.fromARGB(255, 243, 101, 149),
      inverseSurface: const Color.fromARGB(255, 131, 129, 133),
    ),
    textTheme: ThemeData.light().textTheme.apply(
          bodyColor: Colors.grey[800],
          displayColor: Colors.black,
        ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: Colors.black),
    ));