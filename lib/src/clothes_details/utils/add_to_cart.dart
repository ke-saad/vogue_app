import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CartUtil {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addToCart(BuildContext context, String clothesDocId, String userId) async {
    try {
      DocumentSnapshot cartDoc = await _firestore.collection('carts').doc(userId).get();

      if (cartDoc.exists) {
        List<dynamic> cartArticles = cartDoc.get('cart_articles') ?? [];
        if (!cartArticles.contains(clothesDocId)) {
          cartArticles.add(clothesDocId);
          double updatedTotal = await calculateTotal(cartArticles.cast<String>());

          await cartDoc.reference.update({
            'cart_articles': cartArticles,
            'total_price': updatedTotal,
          });
          
          // Show success SnackBar
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Article ajouté au panier'),
              backgroundColor: Colors.green,
            ),
          );
          print('Item added to cart!');
        } else {
          // Show item already exists SnackBar
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Cet article est déjà dans le panier'),
              backgroundColor: Colors.red,
            ),
          );
          print('Item is already in the cart.');
        }
      } else {
        double initialTotal = await calculateTotal([clothesDocId]);
        await _firestore.collection('carts').doc(userId).set({
          'cart_articles': [clothesDocId],
          'total_price': initialTotal,
          'user_uid': userId,
        });

        // Show success SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Panier créé et article ajouté !'),
            backgroundColor: Colors.green,
          ),
        );
        print('Cart created and item added!');
      }
    } catch (e) {
      print('Error adding to cart: $e');
      // Show error SnackBar in case of exception
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erreur lors de l\'ajout au panier'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<double> calculateTotal(List<String> cartArticles) async {
    double total = 0;
    for (String clothesDocId in cartArticles) {
      DocumentSnapshot clothesDoc = await _firestore.collection('clothes').doc(clothesDocId).get();

      if (clothesDoc.exists) {
        total += double.parse(clothesDoc.get('price').toString());
      }
    }
    return total;
  }
}
