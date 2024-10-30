import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class ClothesList extends StatefulWidget {
  final String userId;
  final Function(String) onClothesSelected;

  const ClothesList({
    super.key,
    required this.userId,
    required this.onClothesSelected,
  });

  @override
  State<ClothesList> createState() => _ClothesListState();
}

class _ClothesListState extends State<ClothesList> {
  List<Map<String, dynamic>> clothesData = [];
  bool isLoading = true;

  final _storage = FirebaseStorage.instance;

  @override
  void initState() {
    super.initState();
    fetchClothesData();
  }

  Future<void> fetchClothesData() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('clothes').get();
    final data = snapshot.docs.map((doc) {
      return {
        'clothes_id': doc.id,
        'title': doc['title'] as String,
        'image': doc['image'] as String?,
        'size': doc['size'] as int,
        'price': doc['price'] as String,
        'category': doc['category'] as String,
        'brand': doc['brand'] as String
      };
    }).toList();

    for (var item in data) {
      final imagePath = item['image'] as String?;
      if (imagePath != null && imagePath.isNotEmpty) {
        try {
          final imageRef = _storage.ref().child(imagePath);
          final imageData = await imageRef.getData();
          item['image'] = imageData;
        } catch (e) {
          print('Error fetching image for ${item['title']}: $e');
          item['image'] = null;
        }
      } else {
        item['image'] = null;
      }
    }

    if (mounted) {
      setState(() {
        clothesData = data;
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: clothesData.length,
              itemBuilder: (context, index) {
                final clothes = clothesData[index];
                return GestureDetector(
                  onTap: () {
                    widget.onClothesSelected(clothes['clothes_id']);
                  },
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
                          if (clothes['image'] != null)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: SizedBox(
                                width: 100,
                                height: 100,
                                child: Image.memory(
                                  clothes['image'],
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
                                  clothes['title'],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                const SizedBox(height: 4.0),
                                Text(
                                  'Size: ${clothes['size']}',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.9),
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 4.0),
                                Text(
                                  'Price: €${clothes['price']}',
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
            ),
    );
  }
}
