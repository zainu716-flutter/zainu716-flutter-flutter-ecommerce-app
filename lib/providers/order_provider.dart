import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/order_model.dart';
import '../models/product_model.dart';

class OrderProvider with ChangeNotifier {
  List<Order> _orders = [];

  List<Order> get orders => _orders;

  OrderProvider() {
    loadOrders(); // ✅ auto load
  }

  void placeOrder(List<Product> products, double total) {
    final newOrder = Order(
      products: products,
      totalPrice: total,
      date: DateTime.now(),
      status: "Processing",
    );

    _orders.insert(0, newOrder);

    saveOrders();
    notifyListeners();

    // 🔥 Start status update automatically
    updateOrderStatus(0);
  }

  /// 🔄 UPDATE ORDER STATUS (Processing → Shipped → Delivered)
  Future<void> updateOrderStatus(int index) async {
    if (index >= _orders.length) return;

    // Step 1: Shipped
    await Future.delayed(const Duration(seconds: 3));
    _orders[index] = Order(
      products: _orders[index].products,
      totalPrice: _orders[index].totalPrice,
      date: _orders[index].date,
      status: "Shipped",
    );

    notifyListeners();
    await saveOrders();

    // Step 2: Delivered
    await Future.delayed(const Duration(seconds: 3));
    _orders[index] = Order(
      products: _orders[index].products,
      totalPrice: _orders[index].totalPrice,
      date: _orders[index].date,
      status: "Delivered",
    );

    notifyListeners();
    await saveOrders();
  }

  /// 💾 SAVE TO LOCAL
  Future<void> saveOrders() async {
    final prefs = await SharedPreferences.getInstance();

    final data = _orders.map((o) => o.toJson()).toList();

    await prefs.setString('orders', jsonEncode(data));
  }

  /// 📂 LOAD FROM LOCAL
  Future<void> loadOrders() async {
    final prefs = await SharedPreferences.getInstance();

    final data = prefs.getString('orders');

    if (data != null) {
      final decoded = jsonDecode(data) as List;

      _orders = decoded.map((o) => Order.fromJson(o)).toList();
      notifyListeners();
    }
  }
}