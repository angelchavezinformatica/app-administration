class Sale {
  final int? id;
  final DateTime date;
  final double total;
  final int customer;
  final String customerName;
  final List<SaleDetail> details;

  const Sale(
      {this.id,
      required this.date,
      required this.total,
      required this.customer,
      required this.customerName,
      required this.details});
}

class SaleDetail {
  final int? id;
  final int? idSale;
  final int idProduct;
  final String productName;
  final double price;
  final double cant;
  final double subtotal;

  const SaleDetail({
    this.id,
    this.idSale,
    required this.idProduct,
    required this.productName,
    required this.price,
    required this.cant,
    required this.subtotal,
  });
}
