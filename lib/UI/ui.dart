import 'package:flutter/material.dart';

class InputDecorationsUI {
  // final color = status ? Colors.green : Colors.red;
  static InputDecoration uIInputDecoration({
    required String hintText,
    required String labelText,
    IconData? prefixIcon,
    required bool status,
  }) {
    MaterialColor color = status ? Colors.green : Colors.red;
    return InputDecoration(
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: color,
        ),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: color,
          width: 2,
        ),
      ),
      hintText: hintText,
      labelText: labelText,
      labelStyle: const TextStyle(
        color: Colors.grey,
      ),
      prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: color) : null,
    );
  }
}
