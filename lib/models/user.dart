class Product {
  final int id;
  final String name;
  final String description;
  final double price; // Add the price field
  final String imagePath;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price, // Add the price field
    required this.imagePath,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price, // Add the price field
      'imagePath': imagePath,
    };
  }

  // ... (other methods if any)
}
