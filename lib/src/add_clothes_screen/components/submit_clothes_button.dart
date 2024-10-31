import 'package:flutter/material.dart';
// import './add_clothes_fields.dart';

class SubmitClothesButton extends StatelessWidget {
  final VoidCallback onSubmit; // Add this line

  const SubmitClothesButton({super.key, required this.onSubmit}); // Update the constructor

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onSubmit, // Call the passed callback
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
          'Submit',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
