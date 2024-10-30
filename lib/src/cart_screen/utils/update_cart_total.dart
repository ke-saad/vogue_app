import 'package:cloud_firestore/cloud_firestore.dart';

class UpdateCartTotal {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> updateTotal(String userId, List<String> cartArticles) async {
    try {
      final cartDoc = await _firestore.collection('carts').doc(userId).get();

      if (cartDoc.exists) {
        final updatedTotal = await calculateTotal(cartArticles);
        await cartDoc.reference.update({
          'total_price': updatedTotal,
        });
        print('Cart total updated!');
      } else {
        print('Cart not found!');
      }
    } catch (e) {
      print('Error updating cart total: $e');
    }
  }

  Future<double> calculateTotal(List<String> cartArticles) async {
    double total = 0;
    for (String clothesDocId in cartArticles) {
      DocumentSnapshot clothesDoc =
          await _firestore.collection('clothes').doc(clothesDocId).get();

      if (clothesDoc.exists) {
        total += double.parse(clothesDoc.get('price').toString());
      }
    }
    return total;
  }
}
