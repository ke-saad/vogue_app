import 'package:flutter/material.dart';

class PasswordField extends StatefulWidget {
  final TextEditingController controller;

  const PasswordField({super.key, required this.controller});

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _passwordVisible = false;

  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
  }

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
        obscureText: !_passwordVisible,
        decoration: InputDecoration(
          labelText: 'Password',
          hintText: 'Enter your password',
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.red.withOpacity(0.5),
            ),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.red,
            ),
          ),
          suffixIcon: IconButton(
            icon: Icon(
              _passwordVisible ? Icons.visibility : Icons.visibility_off,
              color: Colors.black,
            ),
            onPressed: () {
              setState(
                () {
                  _passwordVisible = !_passwordVisible;
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
