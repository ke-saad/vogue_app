import 'package:flutter/material.dart';
import '../utils/add_to_cart.dart';

class ClothesDetailsAddToCartButton extends StatelessWidget {
  final String clothesDocId;
  final String userId;
  final double totalPrice;

  const ClothesDetailsAddToCartButton({
    super.key,
    required this.clothesDocId,
    required this.userId,
    required this.totalPrice,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          final cartUtil = CartUtil();
          cartUtil.addToCart(clothesDocId, userId);
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
          'Add to Cart',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}