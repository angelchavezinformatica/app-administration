import 'package:app/components/button.dart';
import 'package:app/components/nav.dart';
import 'package:app/constants/color.dart';
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
  List<Sale> sales = [
    Sale(
        id: 1,
        date: DateTime.now(),
        total: 25,
        customer: 1,
        customerName: 'Félix Sánchez',
        details: []),
    Sale(
        id: 1,
        date: DateTime.now(),
        total: 25,
        customer: 1,
        customerName: 'Dayanara Costa',
        details: [])
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      primaryButton(() {
        navTo(context, const SalesAddProduct());
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
          Text(sale.customerName,
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
