// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vogue_app/main.dart';
// import '../../login/login_screen.dart';

class LogoutButton extends StatelessWidget {
  final String userId;

  const LogoutButton({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Access the VogueAppState to call the logout function
        final vogueAppState = context.findAncestorStateOfType<VogueAppState>();
        vogueAppState?.logout(); // Logs the user out without navigation
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
        'Se déconnecter',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
