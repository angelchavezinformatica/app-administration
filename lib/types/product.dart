class Product {
  final int? id;
  final String name;
  final double price;
  double stock;
  final String description;
  final String measurement;

  Product(
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

  double updateStock(double value) {
    stock += value;
    return stock;
  }
}
