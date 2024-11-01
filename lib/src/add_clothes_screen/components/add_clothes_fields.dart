import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;
import 'package:logger/logger.dart'; // Import the logger package

class AddClothesFields extends StatefulWidget {
  final String userId;

  const AddClothesFields({super.key, required this.userId});

  @override
  State<AddClothesFields> createState() => AddClothesFieldsState();
}

class AddClothesFieldsState extends State<AddClothesFields> {
  final _formKey = GlobalKey<FormState>();
  final Logger _logger = Logger(); // Initialize the logger

  String? _title;
  XFile? _image;
  String? _category;
  String? _brand;
  int? _size;
  String? _price;
  Uint8List? _imageBytes;

  final FirebaseStorage _storage = FirebaseStorage.instance;
  Interpreter? _interpreter;
  List<String>? _labels;
  bool _isModelLoaded = false; // Flag to track model loading
  bool _isLoadingModel = true; // Flag for loading model process

  @override
  void initState() {
    super.initState();
    _loadModel();
  }

  Future<void> _loadModel() async {
    try {
      // Check if the model file exists in assets
      if (await _checkAssetFileExists('assets/my_model.tflite')) {
        _interpreter = await Interpreter.fromAsset('assets/my_model.tflite');
        _isModelLoaded = true;
        _logger.i("Model loaded successfully.");
      } else {
        _logger.e("Model file not found in assets.");
      }

      // Check if the labels file exists in assets
      if (await _checkAssetFileExists('assets/labels.txt')) {
        final labelsData =
            await DefaultAssetBundle.of(context).loadString('assets/labels.txt');
        _labels = labelsData.split('\n');
        _logger.i("Labels loaded successfully.");
      } else {
        _logger.e("Labels file not found in assets.");
      }
    } catch (e) {
      _logger.e("Error loading model: $e");
    } finally {
      setState(() {
        _isLoadingModel = false;
      });
    }
  }

  Future<bool> _checkAssetFileExists(String assetPath) async {
    try {
      final data = await DefaultAssetBundle.of(context).load(assetPath);
      return data != null;
    } catch (e) {
      return false; // If loading fails, the asset doesn't exist
    }
  }

  Future<void> _pickImage() async {
    // Check if the model is loaded before picking the image
    if (_isLoadingModel) {
      _logger.e("Model is still loading. Please wait.");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Model is still loading. Please wait."),
        ),
      );
      return; // Exit the method if the model is still loading
    }

    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _image = pickedImage;
      });
      await _classifyImage(File(_image!.path));
    }
  }

  Future<void> _classifyImage(File image) async {
    if (_interpreter == null || _labels == null) {
      _logger.e(
          "Image classification failed: model is not loaded or labels are null.");
      return;
    }

    final img.Image? imageInput = img.decodeImage(image.readAsBytesSync());
    if (imageInput != null) {
      final imageAsTensor = _preprocessImage(imageInput);
      final output = List.filled(1 * 3, 0).reshape([1, 3]); // Allocate for 3 classes

      _interpreter!.run(imageAsTensor, output);

      final confidenceScores = output[0];

      // Find the index of the highest confidence score
      int maxScoreIndex = 0;
      double maxScore = confidenceScores[0];
      for (int i = 1; i < confidenceScores.length; i++) {
        if (confidenceScores[i] > maxScore) {
          maxScore = confidenceScores[i];
          maxScoreIndex = i;
        }
      }

      setState(() {
        _category = _labels![maxScoreIndex];
        _logger.i("Image classified successfully: $_category");
      });
    } else {
      _logger.e("Image classification failed: image input is null.");
    }
  }

  List<List<List<List<double>>>> _preprocessImage(img.Image image) {
    final resizedImage = img.copyResize(image, width: 224, height: 224);
    return [ // Add a batch dimension
    List.generate(
      224, // Height
      (y) => List.generate(
        224, // Width
        (x) {
          final pixel = resizedImage.getPixel(x, y);
          return [
            pixel.r / 255.0,
            pixel.g / 255.0,
            pixel.b / 255.0,
          ];
        },
      ),
    ),
  ];
}

  Future<String> _getUniqueImageName(String originalName) async {
    String fileName = originalName;
    int count = 1;

    final ref = _storage.ref().child('byte_format_images/$fileName');

    try {
      await ref.getDownloadURL();
      while (true) {
        fileName =
            '${originalName.split('.').first}_$count.${originalName.split('.').last}';
        final newRef = _storage.ref().child('byte_format_images/$fileName');
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
        final ref = _storage.ref().child('byte_format_images/$uniqueFileName');
        await ref.putFile(file);
        _logger.i("Image uploaded successfully: $uniqueFileName");
        return uniqueFileName;
      } catch (e) {
        _logger.e('Error uploading image: $e');
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

        _logger.i("Clothes data added successfully.");
        Navigator.pop(context);
      } catch (e) {
        _logger.e('Error adding clothes data: $e');
      }
    }
  }

  Future<void> _fetchImageData(String imageName) async {
    if (imageName.isNotEmpty) {
      try {
        final ref = _storage.ref().child('byte_format_images/$imageName');
        final imageData = await ref.getData();
        setState(() {
          _imageBytes = imageData;
        });
      } catch (e) {
        _logger.e('Error fetching image data: $e');
      }
    }
  }

  @override
  void dispose() {
    _interpreter?.close();
    super.dispose();
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
            initialValue: _size?.toString(),
            onChanged: (value) {
              setState(() {
                _size = int.tryParse(value);
              });
            },
            validatorMessage: 'Please enter a size',
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
          const SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: submitData,
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    String? initialValue,
    required ValueChanged<String> onChanged,
    required String validatorMessage,
    required double height,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return SizedBox(
      height: height,
      child: TextFormField(
        initialValue: initialValue,
        onChanged: onChanged,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return validatorMessage;
          }
          return null;
        },
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: focusedBorderColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: unfocusedBorderColor),
          ),
          hintText: 'Enter $label',
        ),
      ),
    );
  }
}