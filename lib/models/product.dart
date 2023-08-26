class Product {
  final int id;
  final String name;
  final String description;
  final double price; // Ensure that the price field is defined
  final String imagePath;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imagePath,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'imagePath': imagePath,
    };
  }

  // ... (other methods if any)
}
