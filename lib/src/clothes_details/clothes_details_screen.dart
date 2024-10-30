import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import './components/colthes_details_top_box.dart';
import './components/colthes_details_fields.dart';
import './components/clothes_details_add_to_cart_button.dart';

class ClothesDetailsScreen extends StatefulWidget {
  final String clothesDocId;
  final Function onBackToDashboard;
  final String userId;
  final double totalPrice;

  const ClothesDetailsScreen({
    super.key,
    required this.clothesDocId,
    required this.onBackToDashboard,
    required this.userId,
    required this.totalPrice,
  });

  @override
  State<ClothesDetailsScreen> createState() => _ClothesDetailsScreenState();
}

class _ClothesDetailsScreenState extends State<ClothesDetailsScreen> {
  Map<String, dynamic>? clothesDetails;
  List<String> documentIds = [];
  bool isLoading = true;

  final _storage = FirebaseStorage.instance;

  @override
  void initState() {
    super.initState();
    fetchDocumentIds();
  }

  Future<void> fetchDocumentIds() async {
    try {
      final querySnapshot =
          await FirebaseFirestore.instance.collection('clothes').get();

      documentIds = querySnapshot.docs.map((doc) => doc.id).toList();

      fetchClothesDetails();
    } catch (e) {
      print('Error fetching document IDs: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchClothesDetails() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('clothes')
          .doc(widget.clothesDocId)
          .get();

      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;

        final imagePath = data['image'] as String;
        if (imagePath.isNotEmpty) {
          try {
            final imageRef = _storage.ref().child(imagePath);
            final imageData = await imageRef.getData();
            data['image'] = imageData;
          } catch (e) {
            print('Error fetching image for ${data['title']}: $e');
            data['image'] = null;
          }
        } else {
          data['image'] = null;
        }

        setState(() {
          clothesDetails = data;
          isLoading = false;
        });
      } else {
        print('Document with ID ${widget.clothesDocId} not found.');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching clothes details: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (clothesDetails?['image'] != null)
                      ClothesDetailsTopBox(
                        title: clothesDetails?['title'] ?? '',
                        onBackToDashboard: widget.onBackToDashboard,
                        image: clothesDetails!['image'],
                      ),
                    const SizedBox(height: 16.0),
                    ClothesDetailsFields(
                      category: clothesDetails?['category'] ?? '',
                      brand: clothesDetails?['brand'] ?? '',
                      size: clothesDetails?['size'] ?? 0,
                      price: clothesDetails?['price'] ?? '',
                    ),
                    const SizedBox(height: 32.0),
                    ClothesDetailsAddToCartButton(
                      clothesDocId: widget.clothesDocId,
                      userId: widget.userId,
                      totalPrice: widget.totalPrice,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
