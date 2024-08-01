QUERYS = [
    """CREATE TABLE usuario (
  id INTEGER NOT NULL UNIQUE,
  nombre_usuario VARCHAR(30) NOT NULL,
  contrasena VARCHAR(50) NOT NULL,
  PRIMARY KEY(id AUTOINCREMENT)
);""",
    """CREATE TABLE cliente (
  id_cliente INTEGER NOT NULL,
  nombres VARCHAR(45) NOT NULL,
  apellidos VARCHAR(45) NOT NULL,
  numero_telefono VARCHAR(15),
  email VARCHAR(45),
  PRIMARY KEY(id_cliente AUTOINCREMENT)
);""",
    """CREATE TABLE producto (
  id_producto INTEGER NOT NULL,
  nombre VARCHAR(45) NOT NULL,
  precio FLOAT NOT NULL,
  stock FLOAT NOT NULL,
  descripcion TEXT,
  medida VARCHAR(10) NOT NULL,
  PRIMARY KEY(id_producto AUTOINCREMENT)
);""",
    """CREATE TABLE venta (
  id_venta INTEGER NOT NULL,
  fecha DATETIME NOT NULL,
  monto_total FLOAT NOT NULL,
  id_cliente INTEGER NOT NULL,
  FOREIGN KEY(id_cliente) REFERENCES cliente(id_cliente),
  PRIMARY KEY(id_venta AUTOINCREMENT)
);""",
    """CREATE TABLE detalle_venta (
  id_detalle_venta INTEGER NOT NULL,
  precio_producto_vendido FLOAT NOT NULL,
  cantidad FLOAT NOT NULL,
  subtotal FLOAT NOT NULL,
  id_venta INTEGER NOT NULL,
  id_producto INTEGER NOT NULL,
  FOREIGN KEY(id_venta) REFERENCES venta(id_venta),
  FOREIGN KEY(id_producto) REFERENCES producto(id_producto),
  PRIMARY KEY(id_detalle_venta AUTOINCREMENT)
);""",
    """INSERT INTO usuario (nombre_usuario, contrasena) VALUES ('admin', 'hashPassword');""",
    """SELECT * FROM usuario;""",
    """INSERT INTO producto (nombre, precio, stock, descripcion, medida)
VALUES ('Producto A', 19.99, 100, 'Descripción del producto', 'unidad');""",
    """SELECT * FROM producto;""",
    """UPDATE producto
SET nombre = 'Producto A', precio = 29.99, stock = 50, descripcion = 'Nueva descripción', medida = 'unidad'
WHERE id_producto = 1;""",
    """SELECT * FROM cliente;""",
    """INSERT INTO cliente (nombres, apellidos, numero_telefono, email)
VALUES ('Juan', 'Pérez', '1234567890', 'juan.perez@example.com');""",
    """UPDATE cliente
SET nombres = 'Juan', apellidos = 'Pérez', numero_telefono = '0987654321', email = 'juan.perez@newdomain.com'
WHERE id_cliente = 1;""",
    """SELECT s.id_venta, s.fecha, s.monto_total, s.id_cliente, c.nombres, c.apellidos
FROM venta s
JOIN cliente c ON s.id_cliente = c.id_cliente;""",
    """SELECT sd.id_detalle_venta, sd.precio_producto_vendido, sd.cantidad, sd.subtotal, sd.id_venta, sd.id_producto, p.nombre
FROM detalle_venta sd
JOIN producto p ON sd.id_producto = p.id_producto
WHERE sd.id_venta = 1;""",
    """INSERT INTO venta (fecha, monto_total, id_cliente)
VALUES ('2024-07-31 10:00:00', 100.00, 1);""",
    """INSERT INTO detalle_venta (precio_producto_vendido, cantidad, subtotal, id_venta, id_producto)
VALUES (20.00, 2, 40.00, 1, 1),
       (30.00, 1, 30.00, 1, 2);""",
    """UPDATE producto SET stock = stock - 2 WHERE id_producto = 1;""",
]
