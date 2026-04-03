import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/screens/product_list_screen.dart';
import 'login_screen.dart';
import 'home_screen.dart'; // your main screen

class AuthCheckScreen extends StatelessWidget {
  const AuthCheckScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),

      builder: (context, snapshot) {

        /// 🔄 Loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        /// ✅ User logged in
        if (snapshot.hasData) {
          return const ProductListScreen(); // 👉 GO HOME
        }

        /// ❌ Not logged in
        return const LoginScreen();
      },
    );
  }
}