class Product {
  final int id;
  final String name;
  final double price;
  final String description;
  final String imagePath;
  int quantity; // Nueva propiedad para almacenar la cantidad en el carrito

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.imagePath,
    this.quantity = 1, // Inicializar la cantidad en 1 por defecto
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'description': description,
      'imagePath': imagePath,
      'quantity': quantity, // Incluir la cantidad en el mapa
    };
  }
}
