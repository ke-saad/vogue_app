import 'package:flutter/material.dart';
import './components/header_bar.dart';
import './components/email_field.dart';
import './components/password_field.dart';
import './components/form_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const HeaderBar(),
          SizedBox(height: h * 0.15),
          EmailField(controller: emailController),
          SizedBox(height: h * 0.025),
          PasswordField(controller: passwordController),
          SizedBox(height: h * 0.025),
          FormButton(
            emailController: emailController,
            passwordController: passwordController,
          ),
        ],
      ),
    );
  }
}
