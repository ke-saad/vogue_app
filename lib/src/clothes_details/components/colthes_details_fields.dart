import 'package:flutter/material.dart';

class ClothesDetailsFields extends StatelessWidget {
  final String category;
  final String brand;
  final int size;
  final String price;

  const ClothesDetailsFields({
    super.key,
    required this.category,
    required this.brand,
    required this.size,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Catégorie: $category',
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 8.0),
        Text(
          'Marque: $brand',
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 8.0),
        Text(
          'Taille: $size',
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 8.0),
        Text(
          'Prix: €$price',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
