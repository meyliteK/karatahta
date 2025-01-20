import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:karatahta/auth/auth.dart';
import 'package:karatahta/auth/login_or_register.dart';
import 'package:karatahta/firebase_options.dart';
import 'package:karatahta/pages/home_page.dart';
import 'package:karatahta/pages/posts_page.dart';
import 'package:karatahta/pages/profile_page.dart';
import 'package:karatahta/pages/users_page.dart';
import 'package:karatahta/theme/light_mode.dart';
import 'package:karatahta/theme/dark_mode.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDarkMode = false;

  void toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightMode,
      darkTheme: darkMode,
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: AuthPage(toggleTheme: toggleTheme, isDarkMode: isDarkMode),
      routes: {
        '/login_register_page': (context) => const LoginOrRegister(),
        '/home_page': (context) =>
            HomePage(toggleTheme: toggleTheme, isDarkMode: isDarkMode),
        '/posts_page': (context) => 
            PostsPage(toggleTheme: toggleTheme, isDarkMode: isDarkMode),
        '/profile_page': (context) =>
            ProfilePage(toggleTheme: toggleTheme, isDarkMode: isDarkMode),
        '/users_page': (context) =>
            UsersPage(toggleTheme: toggleTheme, isDarkMode: isDarkMode),
      },
    );
  }
}
