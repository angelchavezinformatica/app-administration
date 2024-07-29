class Product {
  final int? id;
  final String name;
  final double price;
  final double stock;
  final String description;
  final String measurement;

  const Product(
      {this.id,
      required this.name,
      required this.price,
      required this.stock,
      required this.description,
      required this.measurement});

  @override
  String toString() {
    return name;
  }
}
