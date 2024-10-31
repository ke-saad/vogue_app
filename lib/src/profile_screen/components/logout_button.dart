import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../login/login_screen.dart';

class LogoutButton extends StatelessWidget {
  final String userId;

  const LogoutButton({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        await FirebaseAuth.instance.signOut();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        textStyle: const TextStyle(
          color: Colors.white,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: const Text(
        'Logout',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}