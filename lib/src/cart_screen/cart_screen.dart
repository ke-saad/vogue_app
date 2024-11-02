import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'components/cart_item.dart';
import 'utils/cart_total.dart';
import 'utils/update_cart_total.dart';

class CartScreen extends StatefulWidget {
  final String userId;

  const CartScreen({super.key, required this.userId});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<Map<String, dynamic>> cartItems = [];
  bool isLoading = true;
  double totalPrice = 0.0;
  final UpdateCartTotal _updateCartTotal = UpdateCartTotal();
  final FirebaseStorage _storage = FirebaseStorage.instance;

  @override
  void initState() {
    super.initState();
    fetchCartData();
  }

  Future<void> fetchCartData() async {
    try {
      final cartDoc = await FirebaseFirestore.instance
          .collection('carts')
          .doc(widget.userId)
          .get();

      if (cartDoc.exists) {
        final data = cartDoc.data() as Map<String, dynamic>;
        final cartArticles = data['cart_articles'] as List<dynamic>? ?? [];

        totalPrice = data['total_price']?.toDouble() ?? 0.0;

        for (var articleId in cartArticles) {
          final clothesDoc = await FirebaseFirestore.instance
              .collection('clothes')
              .doc(articleId)
              .get();
          if (clothesDoc.exists) {
            final clothesData = clothesDoc.data() as Map<String, dynamic>;
            clothesData['clothesDocId'] = articleId;

            final imagePath = clothesData['image'] as String?;
            if (imagePath != null && imagePath.isNotEmpty) {
              try {
                final imageRef = _storage.ref().child(imagePath);
                final imageData = await imageRef.getData();
                clothesData['image'] = imageData;
              } catch (e) {
                print('Error fetching image for ${clothesData['title']}: $e');
                clothesData['image'] = null;
              }
            } else {
              clothesData['image'] = null;
            }
            cartItems.add(clothesData);
          }
        }
      }

      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching cart data: $e');
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> removeItemFromCart(String articleId) async {
    try {
      final cartDocRef =
          FirebaseFirestore.instance.collection('carts').doc(widget.userId);
      final DocumentSnapshot cartDoc = await cartDocRef.get();

      if (cartDoc.exists) {
        List<String> cartArticles =
            List<String>.from(cartDoc.get('cart_articles') ?? []);

        if (cartArticles.contains(articleId)) {
          await cartDocRef.update({
            'cart_articles': FieldValue.arrayRemove([articleId])
          });

          setState(() {
            cartItems.removeWhere((item) => item['clothesDocId'] == articleId);
          });

          cartArticles.remove(articleId);

          await _updateCartTotal.updateTotal(widget.userId, cartArticles);

          final updatedTotal =
              await _updateCartTotal.calculateTotal(cartArticles);
          setState(() {
            totalPrice = updatedTotal;
          });

          print('Cart total updated after item removal.');
        } else {
          print('Item $articleId not found in cart_articles!');
        }
      } else {
        print('Cart not found!');
      }
    } catch (e) {
      print('Error removing item: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      return CartItem(
                        clothes: item,
                        userId: widget.userId,
                        onRemoveItem: (clothesId) {
                          removeItemFromCart(clothesId);
                        },
                      );
                    },
                  ),
                ),
                CartTotal(
                  totalPrice: totalPrice,
                  onTotalUpdated: (newTotal) {
                    setState(() {
                      totalPrice = newTotal;
                    });
                  },
                ),
              ],
            ),
    );
  }
}
