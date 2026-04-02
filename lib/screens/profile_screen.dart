import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/login_screen.dart';
import 'package:flutter_application_1/screens/orders_screen.dart';
import 'package:flutter_application_1/screens/wishlist_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  /// 🔥 FETCH USER DATA FROM FIRESTORE
  Future<Map<String, dynamic>?> getUserData() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return null;

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    return doc.data();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        centerTitle: true,
      ),

      body: FutureBuilder<Map<String, dynamic>?>(
        future: getUserData(),
        builder: (context, snapshot) {
          final user = FirebaseAuth.instance.currentUser;

          String name = "User";
          String email = user?.email ?? "";

          if (snapshot.hasData && snapshot.data != null) {
            name = snapshot.data!['name'] ?? "User";
            email = snapshot.data!['email'] ?? "";
          }

          return SingleChildScrollView(
            child: Column(
              children: [

                /// 🔹 HEADER
                Container(
                  padding: const EdgeInsets.all(20),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.blue,
                        Colors.blueAccent,
                      ],
                    ),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),

                  child: Column(
                    children: [

                      CircleAvatar(
                        radius: 45,
                        backgroundColor: Colors.white,
                        child: const Icon(Icons.person,
                            size: 45, color: Colors.blue),
                      ),

                      const SizedBox(height: 10),

                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),

                      Text(
                        email,
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                /// 🔹 MENU CARD
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Theme.of(context).cardColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 5,
                      )
                    ],
                  ),
                  child: Column(
                    children: [

                      _buildTile(
                        icon: Icons.shopping_bag,
                        title: "My Orders",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const OrdersScreen()),
                          );
                        },
                      ),

                      _buildTile(
                        icon: Icons.favorite,
                        title: "Wishlist",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const WishlistScreen()),
                          );
                        },
                      ),

                      _buildTile(
                        icon: Icons.location_on,
                        title: "Address",
                        onTap: () {},
                      ),

                      _buildTile(
                        icon: Icons.payment,
                        title: "Payment Methods",
                        onTap: () {},
                      ),

                      /// 🌙 DARK MODE
                      SwitchListTile(
                        title: const Text("Dark Mode"),
                        secondary: const Icon(Icons.dark_mode),
                        value: themeProvider.isDark,
                        onChanged: (_) {
                          themeProvider.toggleTheme();
                        },
                      ),

                      const Divider(),

                      /// 🔴 LOGOUT
                      _buildTile(
                        icon: Icons.logout,
                        title: "Logout",
                        color: Colors.red,
                        onTap: () {
                          _showLogoutDialog(context);
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  /// 🔹 MENU TILE
  Widget _buildTile({
    required IconData icon,
    required String title,
    Color? color,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: color ?? Colors.blue),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  /// 🔥 LOGOUT (WITH FIREBASE)
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Logout"),
        content: const Text("Are you sure you want to logout?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);

              await FirebaseAuth.instance.signOut(); // ✅ Firebase logout

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
            child: const Text("Logout"),
          ),
        ],
      ),
    );
  }
}