import 'product_model.dart';

class Order {
  final List<Product> products;
  final double totalPrice;
  final DateTime date;
  final String status;

  Order({
    required this.products,
    required this.totalPrice,
    required this.date,
    required this.status,
  });

  /// 🔥 SAVE TO JSON
  Map<String, dynamic> toJson() {
    return {
      'products': products.map((p) => {
            'id': p.id,
            'title': p.title,
            'price': p.price,
            'images': p.images,
          }).toList(),
      'totalPrice': totalPrice,
      'date': date.toIso8601String(),
      'status': status, // ✅ IMPORTANT FIX
    };
  }

  /// 🔥 LOAD FROM JSON
  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      products: (json['products'] as List)
          .map((p) => Product(
                id: p['id'],
                title: p['title'],
                price: (p['price'] as num).toDouble(),
                description: "",
                category: "",
                images: List<String>.from(p['images'] ?? []),
                rating: 0,
              ))
          .toList(),

      totalPrice: (json['totalPrice'] as num).toDouble(),

      date: DateTime.parse(json['date']),

      status: json['status'] ?? "Processing", // ✅ IMPORTANT FIX
    );
  }
}