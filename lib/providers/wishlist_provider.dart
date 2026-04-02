import 'package:flutter/material.dart';
import '../models/product_model.dart';

class WishlistProvider with ChangeNotifier {

  final List<Product> _wishlist = [];

  List<Product> get items => _wishlist;

  void toggleWishlist(Product product) {

    if (_wishlist.contains(product)) {
      _wishlist.remove(product);
    } else {
      _wishlist.add(product);
    }

    notifyListeners();
  }

  bool isInWishlist(Product product) {
    return _wishlist.contains(product);
  }
}