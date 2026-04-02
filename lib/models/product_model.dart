class Product {

  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final List images;
  final double rating;
  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
     required this.category,
    required this.images,
    required this.rating,
  });

  factory Product.fromJson(Map<String, dynamic> json) {

    return Product(
      id: json['id'],
      title: json['title'],
      price: (json['price'] as num).toDouble(),
      description: json['description'] ?? "",
      category: json['category'] ?? "",
      images: json['images'] ?? [],
      rating: (json['rating'] as num).toDouble(),
    );
  }
}