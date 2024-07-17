import 'package:app/components/border.dart';
import 'package:app/components/button.dart';
import 'package:app/constants/color.dart';
import 'package:app/helpers/database.dart';
import 'package:flutter/material.dart';
import 'package:app/types/customer.dart';

class CustomerScreen extends StatefulWidget {
  const CustomerScreen({super.key});

  @override
  State<CustomerScreen> createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  List<Customer> allCustomers = [];
  List<Customer> customers = [];
  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    updateCustomers();
    searchController.addListener(() {
      filterCustomers(searchController.text);
    });
  }

  void updateCustomers() async {
    DatabaseHelper db = DatabaseHelper.instance;
    List<Customer> newCustomers = await db.getCustomers();
    setState(() {
      allCustomers = newCustomers;
      customers = newCustomers;
    });
  }

  void filterCustomers(String name) {
    if (name.isEmpty) {
      setState(() {
        customers = allCustomers;
      });
      return;
    }

    List<Customer> results = allCustomers
        .where((customer) =>
            customer.name.toLowerCase().contains(name.toLowerCase()) ||
            customer.lastname.toLowerCase().contains(name.toLowerCase()))
        .toList();

    setState(() {
      customers = results;
    });
  }

  void addCustomer(Customer customer) async {
    await DatabaseHelper.instance.addCustomer(customer);
    updateCustomers();
  }

  void editCustomer(Customer customer) async {
    await DatabaseHelper.instance.updateCustomer(customer);
    updateCustomers();
  }

  void showAddCustomerDialog({Customer? customer}) {
    final TextEditingController nameController =
        TextEditingController(text: customer?.name ?? '');
    final TextEditingController lastnameController =
        TextEditingController(text: customer?.lastname ?? '');
    final TextEditingController emailController =
        TextEditingController(text: customer?.email ?? '');
    final TextEditingController phonenumberController =
        TextEditingController(text: customer?.phonenumber ?? '');

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(customer == null ? 'Agregar Cliente' : 'Editar Cliente'),
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
                  controller: lastnameController,
                  decoration: const InputDecoration(
                    labelText: 'Apellido',
                  ),
                ),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Correo Electrónico',
                  ),
                ),
                TextField(
                  controller: phonenumberController,
                  decoration: const InputDecoration(
                    labelText: 'Teléfono',
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
                final String lastname = lastnameController.text;
                final String email = emailController.text;
                final String phonenumber = phonenumberController.text;

                if (name.isNotEmpty && lastname.isNotEmpty) {
                  final Customer newCustomer = Customer(
                    id: customer?.id,
                    name: name,
                    lastname: lastname,
                    email: email,
                    phonenumber: phonenumber,
                  );

                  if (customer == null) {
                    addCustomer(newCustomer);
                  } else {
                    editCustomer(newCustomer);
                  }

                  Navigator.of(context).pop();
                }
              },
              child: Text(customer == null ? 'Agregar' : 'Editar'),
            ),
          ],
        );
      },
    );
  }

  void showEditCustomerDialog(Customer customer) {
    showAddCustomerDialog(customer: customer);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        searchW(),
        primaryButton(() => showAddCustomerDialog(), 'Agregar Cliente'),
        Expanded(
          child: ListView.builder(
            itemCount: customers.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () => showEditCustomerDialog(customers[index]),
                child: customerW(customers[index]),
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

  Widget customerW(Customer customer) {
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
              '${customer.name} ${customer.lastname}',
              style: const TextStyle(
                  fontSize: 28, fontWeight: FontWeight.bold, color: greenColor),
            ),
          ),
          const SizedBox(height: 8),
          textWithBold('Correo Electrónico:', " ${customer.email}"),
          textWithBold('Teléfono:', " ${customer.phonenumber}"),
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
