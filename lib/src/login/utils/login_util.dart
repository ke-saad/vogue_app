import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';

final Logger logger = Logger();

Future<Map<String, dynamic>?> loginUser(String email, String password) async {
  try {
    print("------------------");
    print(email + " " + password);
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    logger.i('User logged in: ${userCredential.user?.uid}');

    /*QuerySnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .get();

    if (userSnapshot.docs.isEmpty) {
      logger.w('User not found in Firestore');
      return null;
    }*/

    return {
      'uid': userCredential.user?.uid,
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
