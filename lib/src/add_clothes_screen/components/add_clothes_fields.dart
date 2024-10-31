import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddClothesFields extends StatefulWidget {
  final String userId;

  const AddClothesFields({super.key, required this.userId});

  @override
  State<AddClothesFields> createState() => AddClothesFieldsState();
}

class AddClothesFieldsState extends State<AddClothesFields> {
  final _formKey = GlobalKey<FormState>();

  String? _title;
  XFile? _image;
  String? _category;
  String? _brand;
  int? _size;
  String? _price;
  Uint8List? _imageBytes;

  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = pickedImage;
    });
  }

  Future<String> _getUniqueImageName(String originalName) async {
    String fileName = originalName;
    int count = 1;

    final ref = _storage.ref().child('bytes_format_images/$fileName');

    try {
      await ref.getDownloadURL();
      while (true) {
        fileName =
            '${originalName.split('.').first}_$count.${originalName.split('.').last}';
        final newRef = _storage.ref().child('bytes_format_images/$fileName');
        try {
          await newRef.getDownloadURL();
          count++;
        } catch (e) {
          break;
        }
      }
    } catch (e) {}

    return fileName;
  }

  Future<String?> _uploadImage(XFile? imageFile) async {
    if (imageFile != null) {
      final file = File(imageFile.path);
      try {
        String uniqueFileName = await _getUniqueImageName(imageFile.name);
        final ref = _storage.ref().child('bytes_format_images/$uniqueFileName');
        await ref.putFile(file);
        return uniqueFileName;
      } catch (e) {
        print('Error uploading image: $e');
      }
    }
    return null;
  }

  Future<void> submitData() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final imageName = await _uploadImage(_image);
      try {
        await FirebaseFirestore.instance.collection('clothes').add({
          'title': _title,
          'image': imageName ?? '',
          'category': _category,
          'brand': _brand,
          'size': _size,
          'price': _price,
          'user_id': widget.userId,
        });

        Navigator.pop(context);
      } catch (e) {
        print('Error adding clothes data: $e');
      }
    }
  }

  Future<void> _fetchImageData(String imageName) async {
    if (imageName.isNotEmpty) {
      try {
        final ref = _storage.ref().child('bytes_format_images/$imageName');
        final imageData = await ref.getData();
        setState(() {
          _imageBytes = imageData;
        });
      } catch (e) {
        print('Error fetching image data: $e');
      }
    }
  }

  final Color focusedBorderColor = Colors.red;
  final Color unfocusedBorderColor = Colors.red.withOpacity(0.5);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final fieldHeight = screenHeight * 0.07;

    return Form(
      key: _formKey,
      child: Column(
        children: [
          _buildTextField(
            label: 'Title',
            initialValue: _title,
            onChanged: (value) {
              setState(() {
                _title = value;
              });
            },
            validatorMessage: 'Please enter a title',
            height: fieldHeight,
          ),
          const SizedBox(height: 12.0),
          Row(
            children: [
              Expanded(
                child: _image != null
                    ? Image.file(File(_image!.path))
                    : (_imageBytes != null
                        ? Image.memory(_imageBytes!)
                        : const Text('No image selected')),
              ),
              IconButton(
                onPressed: _pickImage,
                icon: const Icon(Icons.add_a_photo),
              ),
            ],
          ),
          const SizedBox(height: 12.0),
          _buildTextField(
            label: 'Category',
            initialValue: _category,
            onChanged: (value) {
              setState(() {
                _category = value;
              });
            },
            validatorMessage: 'Please enter a category',
            height: fieldHeight,
          ),
          const SizedBox(height: 12.0),
          _buildTextField(
            label: 'Brand',
            initialValue: _brand,
            onChanged: (value) {
              setState(() {
                _brand = value;
              });
            },
            validatorMessage: 'Please enter a brand',
            height: fieldHeight,
          ),
          const SizedBox(height: 12.0),
          _buildTextField(
            label: 'Size',
            initialValue: _size != null ? _size.toString() : null,
            onChanged: (value) {
              setState(() {
                _size = int.tryParse(value);
              });
            },
            validatorMessage: 'Please enter a valid size',
            height: fieldHeight,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 12.0),
          _buildTextField(
            label: 'Price',
            initialValue: _price,
            onChanged: (value) {
              setState(() {
                _price = value;
              });
            },
            validatorMessage: 'Please enter a price',
            height: fieldHeight,
            keyboardType: TextInputType.number,
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String? initialValue,
    required ValueChanged<String> onChanged,
    required String validatorMessage,
    required double height,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return SizedBox(
      height: height,
      child: TextFormField(
        initialValue: initialValue,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.black),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: focusedBorderColor, width: 2.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: unfocusedBorderColor, width: 1.0),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return validatorMessage;
          }
          return null;
        },
        onChanged: onChanged,
        keyboardType: keyboardType,
      ),
    );
  }
}
