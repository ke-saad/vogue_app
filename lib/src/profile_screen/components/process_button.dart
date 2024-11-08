import 'package:flutter/material.dart';

class ProcessButton extends StatelessWidget {
  final bool hasChanges;
  final VoidCallback updateUserInfo;

  const ProcessButton({Key? key, required this.hasChanges, required this.updateUserInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: hasChanges ? updateUserInfo : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        textStyle: const TextStyle(
          color: Colors.white,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: const Text(
        'Valider',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
