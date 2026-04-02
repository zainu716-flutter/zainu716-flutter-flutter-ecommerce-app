import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import 'checkout_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Cart")),

      body: cart.items.isEmpty
          ? const Center(
              child: Text("Your cart is empty", style: TextStyle(fontSize: 18)),
            )
          : Column(
              children: [
                /// Cart Items
                Expanded(
                  child: ListView.builder(
                    itemCount: cart.items.length,

                    itemBuilder: (context, index) {
                      final cartItem = cart.items.values.toList()[index];

                      final product = cartItem['product'];
                      final quantity = cartItem['quantity'];

                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),

                        child: ListTile(
                          /// Product Image
                          leading: Image.network(
                            product.images.isNotEmpty
                                ? product.images[0]
                                : "https://via.placeholder.com/150",
                          ),

                          /// Product Title
                          title: Text(
                            product.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),

                          /// Price + quantity text
                          subtitle: Text("₹${product.price}  x$quantity"),

                          /// Quantity Buttons
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,

                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove),

                                onPressed: () {
                                  cart.removeFromCart(product.id);
                                },
                              ),

                              Text(
                                quantity.toString(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              IconButton(
                                icon: const Icon(Icons.add),

                                onPressed: () {
                                  cart.addToCart(product);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                /// Total Price Section
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    border: Border(top: BorderSide(color: Colors.grey)),
                  ),

                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                        children: [
                          const Text(
                            "Total -",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          Text(
                            "₹${cart.totalPrice.toStringAsFixed(2)}",
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      /// Checkout Button
                      SizedBox(
                        width: double.infinity,
                        height: 50,

                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const CheckoutScreen(),
                              ),
                            );
                          },

                          child: const Text("Checkout"),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
