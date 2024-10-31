import 'package:flutter/material.dart';
import 'package:vogue_app/src/add_clothes_screen/components/add_clothes_fields.dart';
import 'package:vogue_app/src/add_clothes_screen/components/return_to_profile_button.dart';
import 'package:vogue_app/src/add_clothes_screen/components/submit_clothes_button.dart';

class AddClothesScreen extends StatefulWidget {
  final String userId;

  const AddClothesScreen({Key? key, required this.userId}) : super(key: key);

  @override
  State<AddClothesScreen> createState() => _AddClothesScreenState();
}

class _AddClothesScreenState extends State<AddClothesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Clothes'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ReturnToProfileButton(), // Top of the screen
            const SizedBox(height: 20),
            AddClothesFields(userId: widget.userId), // Form for clothes details
            const SizedBox(height: 20),
            SubmitClothesButton(
              onSubmit: () {
                // Access the AddClothesFields state to get the data
                final addClothesFieldsState =
                    context.findAncestorStateOfType<AddClothesFieldsState>();
                if (addClothesFieldsState != null) {
                  addClothesFieldsState.submitData(); // Call the public method
                }
              },
            ), // At the bottom
          ],
        ),
      ),
    );
  }
}
