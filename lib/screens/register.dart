import 'package:app/components/dialog.dart';
import 'package:app/components/form/registerlogin.dart';
import 'package:app/helpers/database.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  final Function(bool) updateRegistered;
  const RegisterScreen({super.key, required this.updateRegistered});

  @override
  Widget build(BuildContext context) {
    return FormRegisterLogin(
        handleClick: (username, password) async =>
            {await _handleClick(context, username, password)},
        buttonText: 'Registrarse');
  }

  Future<void> _handleClick(
      BuildContext context, String username, String password) async {
    if (_validateInput(context, username, password)) {
      DatabaseHelper db = DatabaseHelper.instance;
      await db.insertUser(username, password);
      updateRegistered(await db.existsUser());

      if (context.mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  bool _validateInput(BuildContext context, String username, String password) {
    String? errorMessage;

    if (username.length <= 1) {
      errorMessage = 'El nombre de usuario debe tener más de un carácter.';
    } else if (password.length < 6) {
      errorMessage = 'La contraseña debe tener al menos 6 caracteres.';
    } else {
      bool hasLetter = password.contains(RegExp(r'[A-Za-z]'));
      bool hasDigit = password.contains(RegExp(r'\d'));

      if (!hasLetter || !hasDigit) {
        errorMessage =
            'La contraseña debe contener al menos una letra y un número.';
      }
    }

    if (errorMessage != null) {
      showErrorDialog(context, errorMessage);
      return false;
    }

    return true;
  }
}
