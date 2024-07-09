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
  List<Product> allProducts = [];
  List<Product> products = [];
  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    updateProducts();
    searchController.addListener(() {
      filterProducts(searchController.text);
    });
  }

  void updateProducts() async {
    DatabaseHelper db = DatabaseHelper.instance;
    List<Product> newProducts = await db.getProducts();
    setState(() {
      allProducts = newProducts;
      products = newProducts;
    });
  }

  void filterProducts(String name) {
    if (name.isEmpty) {
      setState(() {
        products = allProducts;
      });
      return;
    }

    List<Product> results = allProducts
        .where((product) =>
            product.name.toLowerCase().contains(name.toLowerCase()))
        .toList();

    setState(() {
      products = results;
    });
  }

  void addProduct(Product product) async {
    await DatabaseHelper.instance.addProduct(product);
    updateProducts();
  }

  void editProduct(Product product) async {
    await DatabaseHelper.instance.updateProduct(product);
    updateProducts();
  }

  void showAddProductDialog({Product? product}) {
    final TextEditingController nameController =
        TextEditingController(text: product?.name ?? '');
    final TextEditingController priceController =
        TextEditingController(text: product?.price.toString() ?? '');
    final TextEditingController stockController =
        TextEditingController(text: product?.stock.toString() ?? '');
    final TextEditingController descriptionController =
        TextEditingController(text: product?.description ?? '');
    final TextEditingController measurementController =
        TextEditingController(text: product?.measurement ?? '');

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(product == null ? 'Agregar Producto' : 'Editar Producto'),
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
                    id: product?.id,
                    name: name,
                    price: price,
                    stock: stock,
                    description: description,
                    measurement: measurement,
                  );

                  if (product == null) {
                    addProduct(newProduct);
                  } else {
                    editProduct(newProduct);
                  }

                  Navigator.of(context).pop();
                }
              },
              child: Text(product == null ? 'Agregar' : 'Editar'),
            ),
          ],
        );
      },
    );
  }

  void showEditProductDialog(Product product) {
    showAddProductDialog(product: product);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        searchW(),
        primaryButton(() => showAddProductDialog(), 'Agregar Producto'),
        Expanded(
          child: ListView.builder(
            itemCount: products.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () => showEditProductDialog(products[index]),
                child: productW(products[index]),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget searchW() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: searchController,
            focusNode: searchFocusNode,
            decoration: InputDecoration(
              border: customInputBorder(),
              focusedBorder: customInputBorder(),
              hintText: 'Buscar...',
              prefixIcon: searchController.text.isEmpty
                  ? IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        searchFocusNode.requestFocus();
                      },
                    )
                  : IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        searchController.clear();
                      },
                    ),
            ),
          ),
        ),
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
          textWithBold('Precio:', " S/. ${product.price}"),
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
