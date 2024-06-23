import 'package:flutter/material.dart';

void navTo(BuildContext context, Widget to) {
  Navigator.of(context).push(MaterialPageRoute(builder: (context) => to));
}
