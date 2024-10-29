import 'package:flutter/material.dart';
import '../utils/login_util.dart';

class FormButton extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const FormButton({
    super.key,
    required this.emailController,
    required this.passwordController,
  });

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return SizedBox(
      width: w * 0.4,
      height: h * 0.05,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          textStyle: const TextStyle(
            color: Colors.white,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: () async {
          final userInfo = await loginUser(
            emailController.text,
            passwordController.text,
          );
          if (userInfo != null) {
            logger.i('Login successful: $userInfo');
          } else {
            logger.w('Login failed: Invalid email or password');
          }
        },
        child: Text(
          'Se connecter',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: w * 0.04,
          ),
        ),
      ),
    );
  }
}
