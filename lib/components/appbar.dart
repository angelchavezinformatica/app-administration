import 'package:app/constants/color.dart';
import 'package:flutter/material.dart';

PreferredSizeWidget customAppBar(String title) {
  return AppBar(
    title: Text(
      title,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
    ),
    backgroundColor: greenColor,
  );
}
