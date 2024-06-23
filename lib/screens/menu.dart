import 'package:app/components/appbar.dart';
import 'package:app/components/nav.dart';
import 'package:app/constants/color.dart';
import 'package:app/screens/clients.dart';
import 'package:app/screens/inventory.dart';
import 'package:app/screens/sales.dart';
import 'package:app/screens/settings.dart';
import 'package:flutter/material.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar('Menú'),
      body: Expanded(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Spacer(),
              button(() {
                navTo(context, const InventoryScreen());
              }, 'Inventory'),
              button(() {
                navTo(context, const ClientsScreen());
              }, 'Clientes'),
              button(() {
                navTo(context, const SalesScreen());
              }, 'Ventas'),
              button(() {
                navTo(context, const SettingsScreen());
              }, 'Ajustes'),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget button(VoidCallback handleClick, String text) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: SizedBox(
        width: double.infinity,
        child: TextButton(
          style: TextButton.styleFrom(
            backgroundColor: grayColor,
            padding: const EdgeInsets.symmetric(vertical: 5),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
          ),
          onPressed: handleClick,
          child: Text(
            text,
            style: const TextStyle(fontSize: 25, color: Colors.black),
          ),
        ),
      ),
    );
  }
}
