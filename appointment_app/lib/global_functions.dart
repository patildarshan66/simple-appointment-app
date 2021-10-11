import 'package:flutter/material.dart';

void showCustomSnackBar(
  BuildContext context,
  String msg, {
  Color color = Colors.green,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: color,
      content: Text(msg),
    ),
  );
}
