import 'package:app/components/button.dart';
import 'package:app/components/nav.dart';
import 'package:app/constants/color.dart';
import 'package:app/helpers/database.dart';
import 'package:app/helpers/date.dart';
import 'package:app/screens/sales/add.dart';
import 'package:app/types/sale.dart';
import 'package:flutter/material.dart';

class SalesScreen extends StatefulWidget {
  const SalesScreen({super.key});

  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  List<Sale> sales = [];

  @override
  void initState() {
    super.initState();
    updateData();
  }

  void updateData() async {
    DatabaseHelper db = DatabaseHelper.instance;
    List<Sale> s = await db.getSales();
    setState(() {
      sales = s;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      primaryButton(() {
        navTo(context, SalesAddProduct(updateData: updateData));
      }, 'Registrar Venta'),
      Expanded(
          child: ListView.builder(
              itemCount: sales.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  child: saleW(sales[index]),
                );
              })),
    ]);
  }

  Widget saleW(Sale sale) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
          border: Border.all(width: 2),
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Text(sale.customerName!,
              style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: greenColor)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Fecha: ${formatDateTime(sale.date)}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(width: 20),
              Text(
                'Total: S/ ${sale.total.toString()}',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          )
        ],
      ),
    );
  }
}
