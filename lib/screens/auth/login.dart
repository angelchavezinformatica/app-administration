import 'package:app/components/button.dart';
import 'package:app/components/dialog.dart';
import 'package:app/helpers/database.dart';
import 'package:app/screens/menu.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          _buildBackground(),
          _buildContent(context),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Column(
      children: [
        const Image(
          image: AssetImage('assets/background.jpeg'),
          width: double.infinity,
          fit: BoxFit.cover,
        ),
        Expanded(
          child: Container(),
        ),
      ],
    );
  }

  Widget _buildContent(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 3,
          child: Container(),
        ),
        Expanded(
          flex: 7,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            padding: const EdgeInsetsDirectional.only(top: 10),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Icon(
                      Icons.account_circle_rounded,
                      size: 150,
                    ),
                  ),
                  _buildTextField(
                      controller: _usernameController, hintText: 'Usuario'),
                  _buildTextField(
                      controller: _passwordController, hintText: 'Contraseña'),
                  primaryButton(() {
                    _handleLogin(context);
                  }, 'Iniciar Sesión'),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(
      {required TextEditingController controller, required String hintText}) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          hintText: hintText,
        ),
      ),
    );
  }

  Future<void> _handleLogin(BuildContext context) async {
    String username = _usernameController.text;
    String password = _passwordController.text;
    DatabaseHelper db = DatabaseHelper.instance;
    bool checked = await db.checkUser(username, password);

    if (context.mounted && checked) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const MenuScreen()));
    } else if (context.mounted) {
      showErrorDialog(context, 'Las credenciales son invalidas');
    }
  }
}
