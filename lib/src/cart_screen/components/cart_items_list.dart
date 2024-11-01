import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; 
import 'dart:typed_data';

class CartItemsList extends StatelessWidget {
  final List<Map<String, dynamic>> cartItems;
  final String userId;
  final Function onCartItemRemoved;

  const CartItemsList({
    super.key,
    required this.cartItems,
    required this.userId,
    required this.onCartItemRemoved,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: cartItems.length,
      itemBuilder: (context, index) {
        final item = cartItems[index];
        return Dismissible(
          key: Key(item['clothesDocId']),  // Assuming clothesDocId exists in 'item'
          onDismissed: (direction) {
            removeFromCart(item['clothesDocId'], userId); 
            onCartItemRemoved(); 
          },
          background: Container(
            color: Colors.red,
            alignment: AlignmentDirectional.centerEnd,
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          child: Container(
            margin: const EdgeInsets.symmetric(
                vertical: 8.0, horizontal: 16.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              gradient: const LinearGradient(
                colors: [Color(0xFFE53935), Color(0xFFD32F2F)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (item['image'] != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: SizedBox(
                        width: 100,
                        height: 100,
                        child: item['image'] is Uint8List
                            ? Image.memory(
                                item['image'],
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(Icons.error,
                                      color: Colors.white);
                                },
                              )
                            : Image.network(
                                item['image'],
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(Icons.error,
                                      color: Colors.white);
                                },
                              ),
                      ),
                    ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['title'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          'Size: ${item['size']}',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          'Prix: €${item['price']}',
                          style: const TextStyle(
                            color: Color(0xFFFFCDD2),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> removeFromCart(String clothesDocId, String userId) async {
    try {
      DocumentReference cartDoc =
          FirebaseFirestore.instance.collection('carts').doc(userId);

      await cartDoc.update({
        'cart_articles': FieldValue.arrayRemove([
          {
            'clothesDocId': clothesDocId,
          }
        ]),
      });
      print('Item removed from cart!');
    } catch (e) {
      print('Error removing item from cart: $e');
    }
  }
}