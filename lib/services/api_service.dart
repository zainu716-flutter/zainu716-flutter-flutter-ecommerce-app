import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';

class ApiService {

  Future<List<Product>> fetchProducts() async {

    final response = await http.get(
      Uri.parse('https://dummyjson.com/products?limit=200'),
    );

    if (response.statusCode == 200) {

      final data = json.decode(response.body);

      final List products = data['products'];

      return products.map((e) => Product.fromJson(e)).toList();

    } else {
      throw Exception("Failed to load products");
    }
  }
}