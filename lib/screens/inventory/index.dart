import 'package:app/components/border.dart';
import 'package:app/components/button.dart';
import 'package:app/constants/color.dart';
// import 'package:app/helpers/database.dart';
import 'package:app/types/product.dart';
import 'package:flutter/material.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  List<Product> products = [];

  void updateProducts() {
    // DatabaseHelper db = DatabaseHelper.instance;
    // products = await db.getProducts();
    // setState(() {
    // products =
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        searchW(),
        primaryButton(() {}, 'Agregar Producto'),
        Expanded(
          child: ListView.builder(
            itemCount: products.length,
            itemBuilder: (BuildContext context, int index) {
              return productW(products[index]);
            },
          ),
        )
      ],
    );
  }

  Widget searchW() {
    final TextEditingController search = TextEditingController();
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: search,
            decoration: InputDecoration(
              border: customInputBorder(),
              focusedBorder: customInputBorder(),
              hintText: 'Buscar...',
            ),
          ),
        ),
        const SizedBox(
          width: 15,
        ),
        Container(
          decoration: BoxDecoration(
              border: Border.all(width: 2),
              borderRadius: BorderRadius.circular(100)),
          child: IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.search,
                color: Colors.black,
              )),
        )
      ],
    );
  }

  Widget productW(Product product) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(width: 2),
        borderRadius: const BorderRadius.all(Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            alignment: Alignment.center,
            child: Text(
              product.name,
              style: const TextStyle(
                  fontSize: 28, fontWeight: FontWeight.bold, color: greenColor),
            ),
          ),
          const SizedBox(height: 8),
          textWithBold('Stock:', " ${product.stock} ${product.measurement}"),
          textWithBold('Precio:', " S/.${product.price}"),
          textWithBold('Descripción:', " ${product.description}")
        ],
      ),
    );
  }

  Widget textWithBold(String bold, String normal) {
    return RichText(
      text: TextSpan(
        text: '',
        children: <TextSpan>[
          TextSpan(
            text: bold,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.black, fontSize: 18),
          ),
          TextSpan(
            text: normal,
            style: const TextStyle(color: Colors.black, fontSize: 18),
          )
        ],
      ),
    );
  }
}
