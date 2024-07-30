import 'dart:async';
import 'package:app/helpers/cryptography.dart';
import 'package:app/types/customer.dart';
import 'package:app/types/product.dart';
import 'package:app/types/sale.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

String userTable = 'usuario';
String customerTable = 'cliente';
String productTable = 'producto';
String saleTable = 'venta';
String saleDetailTable = 'detalle_venta';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'db.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE $userTable (
      id	INTEGER NOT NULL UNIQUE,
      nombre_usuario	VARCHAR(30) NOT NULL,
      contrasena	VARCHAR(50) NOT NULL,
      PRIMARY KEY(id AUTOINCREMENT)
    );''');

    await db.execute('''
    CREATE TABLE $customerTable (
      id_cliente	INTEGER NOT NULL,
      nombres	VARCHAR(45) NOT NULL,
      apellidos	VARCHAR(45) NOT NULL,
      numero_telefono	VARCHAR(15),
      email	VARCHAR(45),
      PRIMARY KEY(id_cliente AUTOINCREMENT)
    );''');

    await db.execute('''
    CREATE TABLE $productTable (
      id_producto	INTEGER NOT NULL,
      nombre	VARCHAR(45) NOT NULL,
      precio	FLOAT NOT NULL,
      stock	FLOAT NOT NULL,
      descripcion	TEXT,
      medida	VARCHAR(10) NOT NULL,
      PRIMARY KEY(id_producto AUTOINCREMENT)
    );''');

    await db.execute('''
    CREATE TABLE $saleTable (
      id_venta	INTEGER NOT NULL,
      fecha	DATETIME NOT NULL,
      monto_total	FLOAT NOT NULL,
      id_cliente	INTEGER NOT NULL,
      FOREIGN KEY(id_cliente) REFERENCES cliente(id_cliente),
      PRIMARY KEY(id_venta AUTOINCREMENT)
    );''');

    await db.execute('''
    CREATE TABLE $saleDetailTable (
      id_detalle_venta	INTEGER NOT NULL,
      precio_producto_vendido	FLOAT NOT NULL,
      cantidad	FLOAT NOT NULL,
      subtotal	FLOAT NOT NULL,
      id_venta	INTEGER NOT NULL,
      id_producto	INTEGER NOT NULL,
      FOREIGN KEY(id_venta) REFERENCES venta(id_venta),
      FOREIGN KEY(id_producto) REFERENCES producto(id_producto),
      PRIMARY KEY(id_detalle_venta AUTOINCREMENT)
    );''');
  }

  Future<bool> existsUser() async {
    Database db = await instance.database;
    List<Map> users = await db.rawQuery('SELECT * FROM $userTable;');
    return users.isNotEmpty;
  }

  Future<bool> insertUser(String username, String password) async {
    if (await existsUser()) {
      return false;
    }
    Database db = await instance.database;
    String hashPassword = hashPlainText(password);
    await db.execute(
        '''INSERT INTO usuario (nombre_usuario, contrasena) VALUES ('$username', '$hashPassword');''');
    return true;
  }

  Future<bool> checkUser(String username, String password) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> users =
        await db.rawQuery('SELECT * FROM $userTable;');
    if (users.isEmpty) {
      return false;
    }

    Map<String, dynamic> user = users.first;

    return user['nombre_usuario'] == username &&
        compareHash(password, user['contrasena']);
  }

  Future<void> addProduct(Product product) async {
    Database db = await instance.database;
    await db.execute(
        '''INSERT INTO $productTable (nombre, precio, stock, descripcion, medida)
        VALUES ('${product.name}', ${product.price}, ${product.stock}, '${product.description}', '${product.measurement}');''');
  }

  Future<List<Product>> getProducts() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> products =
        await db.rawQuery('SELECT * FROM $productTable;');
    List<Product> parsedProducts = [];
    for (Map<String, dynamic> product in products) {
      parsedProducts.add(Product(
          id: product['id_producto'],
          name: product['nombre'],
          price: product['precio'],
          stock: product['stock'],
          description: product['descripcion'],
          measurement: product['medida']));
    }
    return parsedProducts;
  }

  Future<void> updateProduct(Product product) async {
    Database db = await instance.database;
    await db.rawQuery('''
      UPDATE $productTable
      SET nombre = '${product.name}', precio = ${product.price},
          stock = ${product.stock}, descripcion = '${product.description}',
          medida = '${product.measurement}'
      WHERE id_producto = ${product.id};
    ''');
  }

  Future<List<Customer>> getCustomers() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> customers =
        await db.rawQuery('SELECT * FROM $customerTable');
    List<Customer> parsedCustomers = [];

    for (Map<String, dynamic> customer in customers) {
      parsedCustomers.add(Customer(
        id: customer['id_cliente'],
        name: customer['nombres'],
        lastname: customer['apellidos'],
        phonenumber: customer['numero_telefono'],
        email: customer['email'],
      ));
    }
    return parsedCustomers;
  }

  Future<void> addCustomer(Customer customer) async {
    Database db = await instance.database;
    await db.execute(
        '''INSERT INTO $customerTable (nombres, apellidos, numero_telefono, email)
        VALUES ('${customer.name}', '${customer.lastname}', '${customer.phonenumber}', '${customer.email}');''');
  }

  Future<List<Sale>> getSales() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> sales = await db.rawQuery('''
      SELECT s.id_venta, s.fecha, s.monto_total, s.id_cliente, c.nombres, c.apellidos
      FROM $saleTable s
      JOIN $customerTable c ON s.id_cliente = c.id_cliente;
    ''');
    List<Sale> parsedSales = [];

    for (Map<String, dynamic> sale in sales) {
      int idVenta = sale['id_venta'];

      List<Map<String, dynamic>> details = await db.rawQuery('''
        SELECT sd.id_detalle_venta, sd.precio_producto_vendido, sd.cantidad, sd.subtotal, sd.id_venta, sd.id_producto, p.nombre
        FROM $saleDetailTable sd
        JOIN $productTable p ON sd.id_producto = p.id_producto
        WHERE sd.id_venta = $idVenta;
      ''');
      List<SaleDetail> saleDetails = [];

      for (Map<String, dynamic> detail in details) {
        saleDetails.add(SaleDetail(
            id: detail['id_detalle_venta'],
            idSale: detail['id_venta'],
            idProduct: detail['id_producto'],
            productName: detail['nombre'],
            price: detail['precio_producto_vendido'],
            cant: detail['cantidad'],
            subtotal: detail['subtotal']));
      }

      parsedSales.add(Sale(
          id: sale['id_venta'],
          date: DateTime.parse(sale['fecha']),
          total: sale['monto_total'],
          customer: sale['id_cliente'],
          customerName: '${sale['nombres']} ${sale['apellidos']}',
          details: saleDetails));
    }

    return parsedSales;
  }

  Future<void> updateCustomer(Customer customer) async {
    Database db = await instance.database;
    await db.rawQuery('''
      UPDATE $customerTable
      SET nombres = '${customer.name}', apellidos = '${customer.lastname}',
          numero_telefono = '${customer.phonenumber}', email = '${customer.email}'
      WHERE id_cliente = ${customer.id};
    ''');
  }

  Future<void> addSale(Sale sale) async {
    Database db = await instance.database;
    int lastId = await db
        .rawInsert('''INSERT INTO $saleTable (fecha, monto_total, id_cliente)
      VALUES ('${sale.date}', ${sale.total}, ${sale.customer});''');

    String sqlInsert =
        '''INSERT INTO $saleDetailTable (precio_producto_vendido, cantidad, subtotal, id_venta, id_producto) VALUES ''';

    for (var i = 0; i < sale.details.length; i++) {
      if (i != 0) sqlInsert += ', ';

      SaleDetail detail = sale.details[i];
      sqlInsert +=
          '''(${detail.price}, ${detail.cant}, ${detail.subtotal}, $lastId, ${detail.idProduct})''';
      await db.rawUpdate(
          '''UPDATE $productTable SET stock=stock - ${detail.cant} WHERE id_producto=${detail.idProduct};''');
    }
    sqlInsert += ';';

    await db.rawInsert(sqlInsert);
  }
}
