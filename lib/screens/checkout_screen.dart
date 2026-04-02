import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/product_model.dart';
import 'package:flutter_application_1/providers/order_provider.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();

  String name = '';
  String phone = '';
  String address = '';
  String paymentMethod = 'COD';

  @override
  Widget build(BuildContext context) {
    void _placeOrder() {
      if (!_formKey.currentState!.validate()) return;

      _formKey.currentState!.save();

      final cartProvider = Provider.of<CartProvider>(context, listen: false);

      final orderProvider = Provider.of<OrderProvider>(context, listen: false);

      final products = cartProvider.items.values
          .map((item) => item['product'] as Product)
          .toList();

      orderProvider.placeOrder(products, cartProvider.totalPrice);

      cartProvider.clearCart();

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Processing Order"),
          content: Text("Thanks $name!\nPayment: $paymentMethod\nCheck My Orders for details."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text("OK"),
            ),
          ],
        ),
      );
    }

    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Checkout")),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),

            child: Form(
              key: _formKey,

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  /// 🔹 DELIVERY DETAILS
                  const Text(
                    "Delivery Details",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 10),

                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Full Name",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => value!.isEmpty ? "Enter name" : null,
                    onSaved: (value) => name = value!,
                  ),

                  const SizedBox(height: 10),

                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Phone",
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (value) =>
                        value!.length < 10 ? "Enter valid phone" : null,
                    onSaved: (value) => phone = value!,
                  ),

                  const SizedBox(height: 10),

                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Address",
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 2,
                    validator: (value) =>
                        value!.isEmpty ? "Enter address" : null,
                    onSaved: (value) => address = value!,
                  ),

                  const SizedBox(height: 20),

                  /// 🔹 PAYMENT METHOD
                  const Text(
                    "Payment Method",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  RadioListTile(
                    title: const Text("Cash on Delivery"),
                    value: 'COD',
                    groupValue: paymentMethod,
                    onChanged: (value) {
                      setState(() {
                        paymentMethod = value.toString();
                      });
                    },
                  ),

                  RadioListTile(
                    title: const Text("UPI"),
                    value: 'UPI',
                    groupValue: paymentMethod,
                    onChanged: (value) {
                      setState(() {
                        paymentMethod = value.toString();
                      });
                    },
                  ),

                  RadioListTile(
                    title: const Text("Card"),
                    value: 'CARD',
                    groupValue: paymentMethod,
                    onChanged: (value) {
                      setState(() {
                        paymentMethod = value.toString();
                      });
                    },
                  ),

                  const Divider(),

                  /// 🔹 ORDER SUMMARY
                  const Text(
                    "Order Summary",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 10),

                  /// IMPORTANT: No Expanded inside ScrollView
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: cart.items.length,

                    itemBuilder: (context, index) {
                      final cartItem = cart.items.values.toList()[index];

                      final product = cartItem['product'] as Product;
                      final quantity = cartItem['quantity'];

                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(product.title),
                        subtitle: Text("₹${product.price} x $quantity"),
                        trailing: Text(
                          "₹${(product.price * quantity).toStringAsFixed(2)}",
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 10),

                  /// 🔹 TOTAL
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Total",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Text(
                        "₹${cart.totalPrice.toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  /// 🔹 BUTTON
                  SizedBox(
                    width: double.infinity,
                    height: 50,

                    child: ElevatedButton(
                      onPressed: _placeOrder,
                      child: const Text("Place Order"),
                    ),
                  ),

                  const SizedBox(height: 20), // extra bottom spacing
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
