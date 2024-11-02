import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';

final Logger logger = Logger();

Future<Map<String, dynamic>?> loginUser(String email, String password) async {
  try {
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    String uid = userCredential.user!.uid;
    logger.i('User logged in: $uid');

    DocumentSnapshot userInfoSnapshot = await FirebaseFirestore.instance
        .collection('users_info')
        .doc(uid)
        .get();

    if (!userInfoSnapshot.exists) {
      await FirebaseFirestore.instance.collection('users_info').doc(uid).set({
        'address': '',
        'birthday': '',
        'city': '',
        'postalCode': '',
        'user_uid': uid,
        'first_name': '',
        'last_name': ''
      });
      logger.i('User info created for UID: $uid');
    }

    DocumentSnapshot cartSnapshot =
        await FirebaseFirestore.instance.collection('carts').doc(uid).get();

    if (!cartSnapshot.exists) {
      await FirebaseFirestore.instance.collection('carts').doc(uid).set({
        'cart_title': 'My Cart',
        'total_price': 0.0,
        'user_uid': uid,
        'cart_articles': [],
      });
      logger.i('Cart created for UID: $uid');
    }

    return {
      'uid': uid,
      'email': email,
    };
  } on FirebaseAuthException catch (e) {
    logger.e('Authentication Error: ${e.message}');
    return null;
  } catch (e) {
    logger.e('Error: $e');
    return null;
  }
}
