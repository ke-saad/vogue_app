import 'package:flutter/material.dart';

class EmailField extends StatefulWidget {
  final TextEditingController controller;

  const EmailField({super.key, required this.controller});

  @override
  State<EmailField> createState() => _EmailFieldState();
}

class _EmailFieldState extends State<EmailField> {
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return SizedBox(
      width: w * 0.8,
      height: h * 0.05,
      child: TextFormField(
        controller: widget.controller,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.red.withOpacity(0.5),
            ),
          ),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(
            color: Colors.red,
          )),
          labelText: 'Login',
        ),
      ),
    );
  }
}
