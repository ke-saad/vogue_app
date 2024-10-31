import 'package:flutter/material.dart';

class AddClothes extends StatelessWidget {
  final String userId;

  const AddClothes({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Implement logic to add clothes, for example:
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => AddClothesScreen(userId: userId), // Create a new screen for adding clothes
        //   ),
        // );
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
        'Add Clothes',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}