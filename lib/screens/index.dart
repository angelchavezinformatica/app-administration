import 'package:app/components/button.dart';
import 'package:app/screens/auth/login.dart';
import 'package:app/screens/auth/register.dart';
import 'package:flutter/material.dart';
import '../helpers/database.dart';

class Index extends StatefulWidget {
  const Index({super.key});

  @override
  State<Index> createState() => _IndexState();
}

class _IndexState extends State<Index> {
  bool registered = false;

  void updateRegistered(bool value) {
    setState(() {
      registered = value;
    });
  }

  Future<bool> _checkSuperuser() async {
    DatabaseHelper dbHelper = DatabaseHelper.instance;
    bool exists = await dbHelper.existsUser();
    registered = exists;
    return exists;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<bool>(
        future: _checkSuperuser(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            if (snapshot.data == true) {
              return _template(() {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              }, 'Iniciar sesión');
            } else {
              return _template(() {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => RegisterScreen(
                          updateRegistered: updateRegistered,
                        )));
              }, 'Registrarse');
            }
          }
        },
      ),
    );
  }

  Widget _template(VoidCallback handleClick, String text) {
    return Container(
      alignment: Alignment.center,
      decoration: const BoxDecoration(color: Colors.white),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          const Image(image: AssetImage('assets/logo.png')),
          const Text(
            'Bienvenido',
            style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          primaryButton(handleClick, text),
        ],
      ),
    );
  }
}
