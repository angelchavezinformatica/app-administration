import 'package:app/components/datepicker.dart';
import 'package:app/components/dropdown.dart';
import 'package:app/constants/color.dart';
import 'package:app/helpers/database.dart';
import 'package:app/types/customer.dart';
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
          padding: const EdgeInsets.only(left: 16, top: 16, right: 16),
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
                  })
            ],
          ),
        ));
  }
}
