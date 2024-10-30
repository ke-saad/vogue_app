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

  final _storage = FirebaseStorage.instance;

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
        final cartArticles = data['cart_articles'] as List<dynamic>;

        totalPrice = data['total_price'] as double;

        // Log cart articles when the list is displayed
        logCartArticles(cartArticles);

        for (var articleId in cartArticles) {
          final clothesDoc = await FirebaseFirestore.instance
              .collection('clothes')
              .doc(articleId)
              .get();
          if (clothesDoc.exists) {
            final clothesData = clothesDoc.data() as Map<String, dynamic>;
            clothesData['clothesDocId'] = articleId; // Add clothesDocId

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
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching cart data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void updateTotalPrice(double newTotal) {
    setState(() {
      totalPrice = newTotal;
    });
  }

  void removeItemFromCart(String articleId) async {
    try {
      final cartDocRef = FirebaseFirestore.instance
          .collection('carts')
          .doc(widget.userId);

      final DocumentSnapshot cartDoc = await cartDocRef.get();

      if (cartDoc.exists) {
        List<dynamic> cartArticles = cartDoc.get('cart_articles') ?? [];

        // Check if the item is in the cart before removing
        if (cartArticles.contains(articleId)) {
          // Update the 'cart_articles' field in Firestore
          await cartDocRef.update({
            'cart_articles': FieldValue.arrayRemove([articleId]) // Use arrayRemove
          });

          // Debugging: Log the updated cartArticles before the update
          print('Updated cart articles before Firestore update: $cartArticles');

          // Verify the update
          final updatedCartDoc = await cartDocRef.get();
          final updatedCartArticles = updatedCartDoc.get('cart_articles') as List<dynamic>;

          // Check if the item was removed
          if (!updatedCartArticles.contains(articleId)) {
            print('Item $articleId successfully removed from database!');
          } else {
            print('Error: Item $articleId still exists in the database!');
          }

          // Remove item from local cartItems and recalculate total price
          setState(() {
            cartItems.removeWhere((item) => item['clothesDocId'] == articleId); // Adjust this if you have a different key for document ID in cartItems
            totalPrice = CartTotal.calculateTotal(cartItems);
          });
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



  void logCartArticles(List<dynamic> cartArticles) {
    print('Cart Articles:');
    cartArticles.forEach((element) {
      print('- $element');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
      ),
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