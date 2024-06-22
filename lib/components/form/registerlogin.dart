import 'package:app/components/button.dart';
import 'package:flutter/material.dart';

class FormRegisterLogin extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final void Function(String, String) handleClick;
  final String buttonText;

  FormRegisterLogin(
      {super.key, required this.handleClick, required this.buttonText});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          _buildBackground(),
          _buildContent(),
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

  Widget _buildContent() {
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
                    handleClick(
                        _usernameController.text, _passwordController.text);
                  }, buttonText),
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
}
