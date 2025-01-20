import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:karatahta/auth/login_or_register.dart';
import 'package:karatahta/pages/home_page.dart';

class AuthPage extends StatelessWidget {
  final VoidCallback toggleTheme;
  final bool isDarkMode;

  const AuthPage({super.key, required this.toggleTheme, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(      
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return HomePage(toggleTheme: toggleTheme, isDarkMode: isDarkMode);
          } else {
            return const LoginOrRegister();
          }
        },
      ),
    );
  }
}
