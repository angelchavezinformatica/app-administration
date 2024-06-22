import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

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
      CREATE TABLE usuario (
        id	INTEGER NOT NULL UNIQUE,
        nombre_usuario	VARCHAR(30) NOT NULL,
        contrasena	VARCHAR(50) NOT NULL,
        PRIMARY KEY(id AUTOINCREMENT)
      );
      CREATE TABLE cliente(
        id_cliente	INTEGER NOT NULL,
        nombres	VARCHAR(45) NOT NULL,
        apellidos	VARCHAR(45) NOT NULL,
        numero_telefono	VARCHAR(15),
        email	VARCHAR(45),
        PRIMARY KEY(id_cliente AUTOINCREMENT)
      );
      CREATE TABLE producto (
        id_producto	INTEGER NOT NULL,
        nombre	VARCHAR(45) NOT NULL,
        precio	FLOAT NOT NULL,
        stock	NUMERIC NOT NULL,
        descripcion	TEXT,
        medida	VARCHAR(10) NOT NULL,
        PRIMARY KEY(id_producto AUTOINCREMENT)
      );
      CREATE TABLE venta (
        id_venta	INTEGER NOT NULL,
        fecha	DATE NOT NULL,
        monto_total	FLOAT NOT NULL,
        id_cliente	INTEGER NOT NULL,
        FOREIGN KEY(id_cliente) REFERENCES cliente(id_cliente),
        PRIMARY KEY(id_venta AUTOINCREMENT)
      );
      CREATE TABLE detalle_venta (
        id_detalle_venta	INTEGER NOT NULL,
        precio_producto_vendido	FLOAT NOT NULL,
        cantidad	NUMERIC NOT NULL,
        subtotal	FLOAT NOT NULL,
        id_venta	INTEGER NOT NULL,
        id_producto	INTEGER NOT NULL,
        FOREIGN KEY(id_venta) REFERENCES venta(id_venta),
        FOREIGN KEY(id_producto) REFERENCES producto(id_producto),
        PRIMARY KEY(id_detalle_venta AUTOINCREMENT)
      );
    ''');
  }

  Future<bool> existsUser() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> users = await db.query('usuario');
    return users.isNotEmpty;
  }
}
