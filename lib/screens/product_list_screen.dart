import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/profile_screen.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;

import '../models/product_model.dart';
import '../services/product_service.dart';
import '../providers/cart_provider.dart';
import '../providers/wishlist_provider.dart';

import 'product_detail_screen.dart';
import 'cart_screen.dart';
import 'wishlist_screen.dart';
import 'orders_screen.dart';
import 'login_screen.dart';
import '../services/auth_service.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final TextEditingController searchController = TextEditingController();

  List<Product> allProducts = [];
  List<Product> filteredProducts = [];

  final ProductService productService = ProductService();

  String selectedCategory = "all";

  @override
  void initState() {
    super.initState();

    productService.loadProducts().then((value) {
      print("Loaded products: ${value.length}");

      for (var p in value) {
        print("Category: ${p.category}");
      }

      setState(() {
        allProducts = value;
        filteredProducts = value;
      });
    });
  }

  /// 🔍 FILTER FUNCTION (FIXED)
  void filterProducts() {
    List<Product> results = allProducts;

    /// 🔎 SEARCH
    if (searchController.text.isNotEmpty) {
      results = results.where((product) {
        return product.title.toLowerCase().contains(
          searchController.text.toLowerCase(),
        );
      }).toList();
    }

    /// 🏷 CATEGORY (FIXED HERE 🔥)
    if (selectedCategory.toLowerCase() != "all") {
      results = results.where((product) {
        return product.category.toLowerCase().contains(
          selectedCategory.toLowerCase(),
        );
      }).toList();
    }

    setState(() {
      filteredProducts = results;
    });
  }

  /// 🏷 CATEGORY CHIP
  Widget categoryChip(String title, String value) {
    final isSelected = selectedCategory == value;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = value;
        });
        filterProducts();
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: TextStyle(color: isSelected ? Colors.white : Colors.black),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ShopEasy"),

        actions: [
          /// ❤️ Wishlist
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const WishlistScreen()),
              );
            },
          ),

          /// 🛒 Cart
          Consumer<CartProvider>(
            builder: (context, cart, child) {
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: badges.Badge(
                  position: badges.BadgePosition.topEnd(top: -8, end: -6),
                  badgeContent: Text(
                    cart.itemCount > 99 ? "99+" : cart.itemCount.toString(),
                    style: const TextStyle(color: Colors.white, fontSize: 10),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.shopping_cart),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const CartScreen()),
                      );
                    },
                  ),
                ),
              );
            },
          ),

          /// 👤 MENU
          PopupMenuButton<String>(
            onSelected: (value) async {
              if (value == "profile") {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProfileScreen()),
                );
              } else if (value == "orders") {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const OrdersScreen()),
                );
              } else if (value == "logout") {
                await AuthService().logout();

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(value: "profile", child: Text("Profile")),
              PopupMenuItem(value: "orders", child: Text("My Orders")),
              PopupMenuItem(value: "logout", child: Text("Logout")),
            ],
          ),
        ],
      ),

      body: Column(
        children: [
          /// 🔍 SEARCH
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: searchController,
              onChanged: (value) => filterProducts(),
              decoration: InputDecoration(
                hintText: "Search products...",
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    searchController.clear();
                    filterProducts();
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          /// 🏷 CATEGORY
          SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                categoryChip("All", "all"),
                categoryChip("Mobiles", "mobile-accessories"),
                categoryChip("Laptops", "laptops"),
                categoryChip("Fragrances", "fragrances"),
                categoryChip("Groceries", "groceries"),
              ],
            ),
          ),

          const SizedBox(height: 10),

          /// 📦 PRODUCT GRID
          Expanded(
            child: filteredProducts.isEmpty
                ? const Center(child: Text("No products found"))
                : GridView.builder(
                    padding: const EdgeInsets.all(12),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.7,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = filteredProducts[index];

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  ProductDetailScreen(product: product),
                            ),
                          );
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// IMAGE
                              Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(12),
                                    ),
                                    child: Image.network(
                                      product.images.isNotEmpty
                                          ? product.images[0]
                                          : "https://via.placeholder.com/150",
                                      height: 120,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),

                                  /// ❤️ WISHLIST ICON
                                  Positioned(
                                    right: 8,
                                    top: 8,
                                    child: Consumer<WishlistProvider>(
                                      builder: (context, wishlist, child) {
                                        final isFav = wishlist.isInWishlist(
                                          product,
                                        );

                                        return GestureDetector(
                                          onTap: () {
                                            wishlist.toggleWishlist(product);
                                          },
                                          child: Icon(
                                            isFav
                                                ? Icons.favorite
                                                : Icons.favorite_border,
                                            color: Colors.red,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),

                              /// TITLE
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Text(
                                  product.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),

                              /// PRICE
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "₹${product.price}",
                                      style: const TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.star,
                                          color: Colors.orange,
                                          size: 16,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          (product.rating).toString(),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
