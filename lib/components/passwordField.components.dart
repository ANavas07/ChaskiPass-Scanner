import 'package:flutter/material.dart';

class PasswordTextField extends StatefulWidget {
  final TextEditingController controller; // Añade un controlador como parámetro

  // Añade el constructor que toma el controlador
  PasswordTextField({Key? key, required this.controller}) : super(key: key);

  @override
  _PasswordTextFieldState createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller, // Usa el controlador proporcionado
      obscureText: _obscureText,
      decoration: InputDecoration(
        labelText: 'Contraseña',
        prefixIcon: Icon(Icons.lock, color: Color.fromARGB(255, 0, 0, 0)),
        suffixIcon: IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility : Icons.visibility_off,
            color: Colors.grey,
          ),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        ),
      ),
      // Otros propiedades como validator, onChanged, etc.
    );
  }
}
