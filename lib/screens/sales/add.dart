import 'package:app/components/datepicker.dart';
import 'package:app/components/dropdown.dart';
import 'package:app/constants/color.dart';
import 'package:app/helpers/database.dart';
import 'package:app/types/customer.dart';
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
  DateTime? dateSelected;
  List<SaleDetail> saleDetails = [
    const SaleDetail(
        idProduct: 1,
        productName: 'Manzano Golden',
        price: 20,
        cant: 15,
        subtotal: 20 * 15),
    const SaleDetail(
        idProduct: 1,
        productName: 'Humus de lombriz',
        price: 1,
        cant: 15,
        subtotal: 1 * 15),
  ];

  @override
  void initState() {
    super.initState();
    updateData();
    dateSelected = DateTime.now();
  }

  void updateData() async {
    DatabaseHelper db = DatabaseHelper.instance;
    List<Customer> c = await db.getCustomers();
    setState(() {
      customers = c;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Registrar Venta'),
          backgroundColor: greenColor,
        ),
        body: Container(
          padding: const EdgeInsets.only(left: 8, top: 16, right: 8),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomDropdown<Customer>(
                data: customers,
                hint: 'Cliente',
                onChanged: (Customer? value) {
                  setState(() {
                    customerSelected = value!;
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
              Expanded(child: tableW()),
            ],
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
