import 'package:flutter/material.dart';
import 'package:vogue_app/src/add_clothes_screen/components/add_clothes_fields.dart';

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
        title: Center(
          child: Text(
            'Ajouter un vêtement',
            style: const TextStyle(
              color: Colors.red,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_circle_left,
            color: Colors.red,
            size: 25,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        toolbarHeight: 80.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              AddClothesFields(
                  userId: widget.userId),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
