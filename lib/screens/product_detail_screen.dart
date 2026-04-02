import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/fullscreen_image.dart';
import '../models/product_model.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int quantity = 1;
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.product.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [
            /// IMAGE SLIDER
            SizedBox(
              height: 250,
              child: PageView.builder(
                itemCount: widget.product.images.length > 1
                    ? widget.product.images.length
                    : 3,

                onPageChanged: (index) {
                  setState(() {
                    currentIndex = index;
                  });
                },

                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      /// 🔍 OPEN FULL SCREEN IMAGE
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => FullScreenImage(
                            images: widget.product.images,
                            initialIndex: index,
                          ),
                        ),
                      );
                    },

                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        widget.product.images[widget.product.images.length > 1
                            ? index
                            : 0],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 10),

            /// 🔵 DOT INDICATORS
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(widget.product.images.length, (index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: currentIndex == index ? 10 : 8,
                  height: currentIndex == index ? 10 : 8,

                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: currentIndex == index ? Colors.blue : Colors.grey,
                  ),
                );
              }),
            ),

            const SizedBox(height: 20),

            // Title
            Text(
              widget.product.title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(
              widget.product.category.toUpperCase(),
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 8),

            Row(
              children: [
                const Icon(Icons.star, color: Colors.orange),
                const SizedBox(width: 5),
                Text(
                  widget.product.rating.toString(),
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // Price
            Text(
              "₹${widget.product.price}",
              style: const TextStyle(
                fontSize: 20,
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () {
                    if (quantity > 1) {
                      setState(() => quantity--);
                    }
                  },
                ),

                Text(quantity.toString(), style: const TextStyle(fontSize: 18)),

                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    setState(() => quantity++);
                  },
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Description
            Text(
              widget.product.description,
              style: const TextStyle(fontSize: 16),
            ),

            const Spacer(),

            // Add To Cart Button
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  final cart = Provider.of<CartProvider>(
                    context,
                    listen: false,
                  );

                  for (int i = 0; i < quantity; i++) {
                    cart.addToCart(widget.product);
                  }

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("$quantity item(s) added to cart")),
                  );
                },
                child: const Text("Add to Cart"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
