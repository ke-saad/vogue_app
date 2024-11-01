import 'package:flutter/material.dart';

class EmailField extends StatefulWidget {
  final TextEditingController controller;

  const EmailField({super.key, required this.controller});

  @override
  State<EmailField> createState() => _EmailFieldState();
}

class _EmailFieldState extends State<EmailField> {
  final Color focusedBorderColor = Colors.red;
  final Color unfocusedBorderColor = Colors.red.withOpacity(0.5);

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return SizedBox(
      width: w * 0.8,
      height: h * 0.07,
      child: TextFormField(
        controller: widget.controller,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          labelText: 'Login',
          labelStyle: const TextStyle(color: Colors.black),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: unfocusedBorderColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: focusedBorderColor, width: 2.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: unfocusedBorderColor, width: 1.0),
          ),
        ),
      ),
    );
  }
}
