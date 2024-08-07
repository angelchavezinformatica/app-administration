import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 20),
      children: <Widget>[termsOfService(), about()],
    );
  }

  Widget termsOfService() {
    return const ExpansionTile(
      title: Text('Ayuda y Soporte'),
      children: <Widget>[
        ListTile(
          title: Text('Términos de servicio'),
          subtitle: Text(
              'Al utilizar nuestra aplicación, aceptas cumplir con estos términos, diseñados para garantizar una experiencia segura y satisfactoria para todos los usuarios.'),
        ),
        ListTile(
          title: Text('Política de Privacidad'),
          subtitle: Text(
              'Al utilizar nuestra aplicación, aceptas cumplir con estos términos, diseñados para garantizar una experiencia segura y satisfactoria para todos los usuarios.'),
        ),
        ListTile(
          title: Text('Contactar soporte'),
          subtitle: Text(
              'Conoce cómo recopilamos, usamos y protegemos tu información personal. Nos comprometemos a mantener tu privacidad y seguridad.'),
        ),
      ],
    );
  }

  Widget about() {
    return const ExpansionTile(
      title: Text('Acerca de'),
      children: <Widget>[
        ListTile(
          title: Text('Descripción'),
          subtitle: Text(
              'Esta aplicación esta diseñada para gestionar tu vivero de manera eficiente.'),
        ),
        ListTile(
          title: Text('Objetivo'),
          subtitle: Text('Facilitar la administración.'),
        ),
        ListTile(
          title: Text('Contacto'),
          subtitle: Text('Para mayor información achavezg@unitru.edu.pe'),
        ),
        ListTile(
          title: Text('Desarrolladores'),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('- Chávez García Angel Emanuel'),
              Text('- Costa Mallqui Dayanara Darlene'),
              Text('- Gamarra Saucedo Maeli Sabina'),
              Text('- Rojas Delgado Norma Katerine'),
              Text('- Sánchez Abanto Félix Aladino'),
            ],
          ),
        ),
      ],
    );
  }
}
