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
  final double price;
  final double cant;
  final double subtotal;
  final int? idSale;
  final int idProduct;

  const SaleDetail({
    this.id,
    required this.price,
    required this.cant,
    required this.subtotal,
    required this.idSale,
    required this.idProduct,
  });
}
