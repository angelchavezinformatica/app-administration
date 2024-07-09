import 'package:app/components/border.dart';
import 'package:app/components/button.dart';
import 'package:app/constants/color.dart';
import 'package:app/helpers/database.dart';
import 'package:app/types/product.dart';
import 'package:flutter/material.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  List<Product> products = [];

  @override
  void initState() {
    super.initState();
    updateProducts();
  }

  void updateProducts() async {
    DatabaseHelper db = DatabaseHelper.instance;
    List<Product> newProducts = await db.getProducts();
    setState(() {
      products = newProducts;
    });
  }

  void addProduct(Product product) {
    setState(() {
      products.add(product);
    });
  }

  void showAddProductDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController nameController = TextEditingController();
        final TextEditingController priceController = TextEditingController();
        final TextEditingController stockController = TextEditingController();
        final TextEditingController descriptionController =
            TextEditingController();
        final TextEditingController measurementController =
            TextEditingController();

        return AlertDialog(
          title: const Text('Agregar Producto'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nombre',
                  ),
                ),
                TextField(
                  controller: priceController,
                  decoration: const InputDecoration(
                    labelText: 'Precio',
                  ),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: stockController,
                  decoration: const InputDecoration(
                    labelText: 'Stock',
                  ),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Descripción',
                  ),
                ),
                TextField(
                  controller: measurementController,
                  decoration: const InputDecoration(
                    labelText: 'Medida',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                final String name = nameController.text;
                final double price =
                    double.tryParse(priceController.text) ?? 0.0;
                final double stock = double.tryParse(stockController.text) ?? 0;
                final String description = descriptionController.text;
                final String measurement = measurementController.text;

                if (name.isNotEmpty && measurement.isNotEmpty) {
                  final Product newProduct = Product(
                    name: name,
                    price: price,
                    stock: stock,
                    description: description,
                    measurement: measurement,
                  );

                  // Guardar el producto en la base de datos
                  await DatabaseHelper.instance.addProduct(newProduct);
                  // Actualizar la lista de productos
                  updateProducts();

                  Navigator.of(context).pop();
                }
              },
              child: const Text('Agregar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        searchW(),
        primaryButton(showAddProductDialog, 'Agregar Producto'),
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
