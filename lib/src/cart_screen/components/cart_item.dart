import 'package:flutter/material.dart';

class CartItem extends StatelessWidget {
  final Map<String, dynamic> clothes;
  final String userId;
  final Function(String) onRemoveItem; // Function takes a String (the document ID)

  const CartItem({
    super.key,
    required this.clothes,
    required this.userId,
    required this.onRemoveItem,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: clothes['image'] != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.memory(
                clothes['image'],
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.error, color: Colors.grey);
                },
              ),
            )
          : const Icon(Icons.image, color: Colors.grey),
      title: Text(clothes['title']),
      subtitle: Text('Size: ${clothes['size']}'),
      trailing: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () {
          // Pass the document ID to onRemoveItem
          onRemoveItem(clothes['clothesDocId']); // Assuming 'clothesDocId' is the correct key
        },
      ),
    );
  }
}