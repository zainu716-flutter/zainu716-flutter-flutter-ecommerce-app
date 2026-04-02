import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/product_model.dart';
import 'api_service.dart';

class ProductService {

  final ApiService apiService = ApiService();

  Future<List<Product>> loadProducts() async {

    try {
      /// Try API first
      return await apiService.fetchProducts();

    } catch (e) {

      /// Fallback to local JSON
      final String response =
          await rootBundle.loadString('assets/products.json');

      final data = json.decode(response) as List;

      return data.map((e) => Product.fromJson(e)).toList();
    }
  }
}