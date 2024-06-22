import 'package:flutter/material.dart';

Widget primaryButton(VoidCallback handleClick, String text) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: SizedBox(
      width: double.infinity,
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: Colors.black87,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
        onPressed: handleClick,
        child: Text(
          text,
          style: const TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
    ),
  );
}

Widget secondaryButton(VoidCallback handleClick, String text) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: TextButton(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
      ),
      onPressed: handleClick,
      child: Text(
        text,
        style: const TextStyle(color: Colors.black54, fontSize: 20),
      ),
    ),
  );
}
