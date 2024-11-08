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
      width: w * 0.8,
      height: h * 0.07,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        onPressed: () async {
          final userInfo = await loginUser(
            emailController.text,
            passwordController.text,
          );
          if (userInfo != null) {
            logger.i('Login successful: $userInfo');
          } else if (emailController.text.isEmpty || passwordController.text.isEmpty) {
            logger.w('Login failed: Please fill in all fields');
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
