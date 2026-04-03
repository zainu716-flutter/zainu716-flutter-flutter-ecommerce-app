import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/providers/order_provider.dart';
import 'package:flutter_application_1/providers/theme_provider.dart';
import 'package:flutter_application_1/screens/auth_check_screen.dart';
import 'package:provider/provider.dart';
import 'providers/wishlist_provider.dart';
import 'providers/cart_provider.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => WishlistProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],

      /// 🔥 APPLY THEME HERE
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {

          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'ShopEasy',

            /// LIGHT THEME
            theme: ThemeData(
              brightness: Brightness.light,
              primarySwatch: Colors.blue,
            ),

            /// DARK THEME
            darkTheme: ThemeData(
              brightness: Brightness.dark,
            ),

            /// SWITCH LOGIC
            themeMode: themeProvider.isDark
                ? ThemeMode.dark
                : ThemeMode.light,

            /// START SCREEN
            home: const AuthCheckScreen(),

            /// ROUTES
            routes: {
              '/login': (context) => const LoginScreen(),
              '/register': (context) => const RegisterScreen(),
            },
          );
        },
      ),
    );
  }
}