import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/wishlist_provider.dart';
import 'product_detail_screen.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final wishlist = Provider.of<WishlistProvider>(context);

    return Scaffold(

      appBar: AppBar(
        title: const Text("Wishlist"),
      ),

      body: wishlist.items.isEmpty
          ? const Center(
              child: Text(
                "No wishlist items yet ❤️",
                style: TextStyle(fontSize: 18),
              ),
            )

          : ListView.builder(

              itemCount: wishlist.items.length,

              itemBuilder: (context, index) {

                final product = wishlist.items[index];

                return Card(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),

                  child: ListTile(

                    leading: SizedBox(
                      width: 50,
                      height: 50,
                      child: Image.network(
                        product.images[0],
                        fit: BoxFit.cover,
                      ),
                    ),

                    title: Text(
                      product.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    subtitle: Text(
                      "₹${product.price}",
                    ),

                    trailing: IconButton(
                      icon: const Icon(Icons.delete),

                      onPressed: () {
                        wishlist.toggleWishlist(product);
                      },
                    ),

                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              ProductDetailScreen(product: product),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}