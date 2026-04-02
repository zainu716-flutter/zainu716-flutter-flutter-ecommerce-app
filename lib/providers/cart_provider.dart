import 'package:flutter/material.dart';
import '../models/product_model.dart';

class CartProvider with ChangeNotifier {

  final Map<int, Map<String, dynamic>> _items = {};

  Map<int, Map<String, dynamic>> get items => _items;

  /// Add to Cart
  void addToCart(Product product) {

    if (_items.containsKey(product.id)) {

      _items[product.id]!['quantity'] += 1;

    } else {

      _items[product.id] = {
        'product': product,
        'quantity': 1,
      };
    }

    notifyListeners();
  }

  /// Remove from Cart
  void removeFromCart(int productId) {

    if (!_items.containsKey(productId)) return;

    if (_items[productId]!['quantity'] > 1) {

      _items[productId]!['quantity'] -= 1;

    } else {

      _items.remove(productId);
    }

    notifyListeners();
  }

  /// Total Price
  double get totalPrice {

    double total = 0;

    _items.forEach((key, value) {

      final product = value['product'] as Product;
      final quantity = value['quantity'] as int;

      total += product.price * quantity;
    });

    return total;
  }

  /// Total Items Count
  int get itemCount {

    int count = 0;

    _items.forEach((key, value) {
      count += value['quantity'] as int;
    });

    return count;
  }

  /// Clear Cart
  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}