import 'package:flutter/material.dart';

class CartTotal extends StatelessWidget {
  final double totalPrice;
  final Function(double) onTotalUpdated;

  const CartTotal({
    super.key,
    required this.totalPrice,
    required this.onTotalUpdated,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: Colors.grey[200],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Total:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            '€${totalPrice.toStringAsFixed(2)}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  // In cart_total.dart
static double calculateTotal(List<Map<String, dynamic>?> cartItems) {
  double total = 0;
  for (final item in cartItems) {
    if (item != null) {
      total += double.parse(item['price'].toString());
    }
  }
  return total;
}
}
