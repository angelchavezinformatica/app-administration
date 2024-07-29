import 'package:app/components/button.dart';
import 'package:app/components/datepicker.dart';
import 'package:app/components/dialog.dart';
import 'package:app/components/dropdown.dart';
import 'package:app/constants/color.dart';
import 'package:app/helpers/database.dart';
import 'package:app/types/customer.dart';
import 'package:app/types/product.dart';
import 'package:app/types/sale.dart';
import 'package:flutter/material.dart';

class SalesAddProduct extends StatefulWidget {
  const SalesAddProduct({super.key});

  @override
  State<SalesAddProduct> createState() => _SalesAddProductState();
}

class _SalesAddProductState extends State<SalesAddProduct> {
  List<Customer> customers = [];
  Customer? customerSelected;
  List<Product> products = [];
  DateTime? dateSelected;
  List<SaleDetail> saleDetails = [];
  double total = 0;

  @override
  void initState() {
    super.initState();
    updateData();
    dateSelected = DateTime.now();
  }

  void updateData() async {
    DatabaseHelper db = DatabaseHelper.instance;
    List<Customer> c = await db.getCustomers();
    List<Product> p = await db.getProducts();
    setState(() {
      customers = c;
      products = p;
    });
  }

  void addProduct() {
    Product? product;
    double subtotal = 0;
    final TextEditingController price = TextEditingController();
    final TextEditingController cant = TextEditingController();

    bool priceError = false;
    bool cantError = false;
    String cantErrorMessage = 'No es un número valido';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter _setState) {
            return AlertDialog(
              title: const Text('Agregar Producto'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomDropdown<Product>(
                    data: products,
                    hint: 'Producto',
                    onChanged: (Product value) {
                      _setState(() {
                        product = value;
                        price.text = value.price.toString();
                        cant.text = '0';
                      });
                    },
                  ),
                  if (product != null)
                    TextField(
                      controller: price,
                      onChanged: (String value) {
                        try {
                          subtotal = double.parse(price.text) *
                              double.parse(cant.text);
                          priceError = false;
                        } catch (e) {
                          priceError = true;
                        }
                        _setState(() {});
                      },
                      decoration: const InputDecoration(labelText: 'Precio'),
                    ),
                  if (priceError)
                    const Text(
                      'No es un número valido',
                      style: TextStyle(color: Colors.red),
                    ),
                  if (product != null)
                    TextField(
                      controller: cant,
                      onChanged: (String value) {
                        try {
                          double c = double.parse(cant.text);
                          subtotal = double.parse(price.text) * c;
                          cantError = false;
                          if (product!.stock < c) {
                            cantErrorMessage = 'No hay productos suficientes';
                            cantError = true;
                          }
                        } catch (e) {
                          cantErrorMessage = 'No es un número valido';
                          cantError = true;
                        }
                        _setState(() {});
                      },
                      decoration: const InputDecoration(labelText: 'Cantidad'),
                    ),
                  if (cantError)
                    Text(
                      cantErrorMessage,
                      style: const TextStyle(color: Colors.red),
                    ),
                  if (product != null)
                    const SizedBox(
                      height: 20,
                    ),
                  if (product != null) Text('SubTotal: $subtotal'),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () {
                    double p = 0;
                    double c = 0;
                    try {
                      p = double.parse(price.text);
                      c = double.parse(cant.text);
                    } catch (e) {
                      showErrorDialog(context, 'Campos invalidos');
                      return;
                    }
                    if (product!.stock < c) {
                      showErrorDialog(context, 'Cantidad insuficiente');
                    }

                    setState(() {
                      saleDetails.add(SaleDetail(
                          idProduct: product!.id,
                          productName: product!.name,
                          price: p,
                          cant: c,
                          subtotal: p * c));
                      total += p * c;
                    });
                    Navigator.of(context).pop();
                  },
                  child: const Text('Agregar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void saveSale() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Registrar Venta'),
          backgroundColor: greenColor,
        ),
        floatingActionButton: customerSelected != null
            ? FloatingActionButton(
                onPressed: addProduct,
                backgroundColor: greenColor,
                shape: const CircleBorder(),
                child: const Icon(
                  Icons.add,
                  size: 50,
                  color: Colors.white,
                ),
              )
            : null,
        body: Container(
          padding: const EdgeInsets.only(left: 8, top: 16, right: 8),
          width: double.infinity,
          child: Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomDropdown<Customer>(
                  data: customers,
                  hint: 'Cliente',
                  onChanged: (Customer value) {
                    setState(() {
                      customerSelected = value;
                    });
                  },
                ),
                DatePicker(
                    selectedDate: dateSelected!,
                    onChanged: (DateTime value) {
                      setState(() {
                        dateSelected = value;
                      });
                    }),
                const SizedBox(
                  height: 20,
                ),
                tableW(),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: double.infinity,
                  child: Center(
                    child: Text(
                      'Total: S/ $total',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                ),
                if (customerSelected != null &&
                    dateSelected != null &&
                    saleDetails.isNotEmpty)
                  SizedBox(
                    width: double.infinity,
                    child: primaryButton(saveSale, 'Guardar Venta'),
                  )
              ],
            ),
          ),
        ));
  }

  Widget tableW() {
    List<TableRow> rows = [headerTable()];

    for (var i = 0; i < saleDetails.length; i++) {
      rows.add(rowTable(saleDetails[i], i + 1));
    }

    return Table(
      border: TableBorder.all(),
      columnWidths: const <int, TableColumnWidth>{
        0: IntrinsicColumnWidth(),
        1: FlexColumnWidth(),
        2: IntrinsicColumnWidth(),
        3: IntrinsicColumnWidth(),
        4: IntrinsicColumnWidth(),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: rows,
    );
  }

  TableRow headerTable() {
    TableCell headerCell(String text, double width, double height) {
      return TableCell(
          child: Container(
        width: width,
        height: height,
        color: gray2Color,
        child: Center(
          child: Text(text),
        ),
      ));
    }

    return TableRow(children: [
      headerCell('ID', 25, 25),
      headerCell('Producto', double.infinity, 25),
      headerCell('Precio', 50, 25),
      headerCell('Cantidad', 65, 25),
      headerCell('SubTotal', 65, 25),
    ]);
  }

  TableRow rowTable(SaleDetail detail, int index) {
    TableCell cell(String text) {
      return TableCell(
        child: Center(
          child: Text(text),
        ),
      );
    }

    return TableRow(children: [
      cell(index.toString()),
      cell(detail.productName),
      cell(detail.price.toString()),
      cell(detail.cant.toString()),
      cell(detail.subtotal.toString()),
    ]);
  }
}
