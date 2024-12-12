import 'package:flutter/material.dart';

//Clase para usar los input decoration

class MineInputDecorations {
  static InputDecoration ownInputDecoration({
    required String hintText,
    required String labelText,
    required Icon iconI,
  }) {
    return InputDecoration(
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.deepPurple),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.deepPurple, width: 2),
      ),
      hintText: hintText,
      labelText: labelText,
      prefixIcon: iconI,
    );
  }
}
