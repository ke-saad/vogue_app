import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../cart_screen/cart_screen.dart';
import './components/clothes_list.dart';
import '../clothes_details/clothes_details_screen.dart';
import '../profile_screen/profile_screen.dart';
import 'components/bottom_navbar.dart';

class UserDashboard extends StatefulWidget {
  final String userId;

  const UserDashboard({super.key, required this.userId});

  @override
  State<UserDashboard> createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  int _selectedIndex = 0;
  String? firstName;
  String? selectedClothesId;

  @override
  void initState() {
    super.initState();
    fetchUserInfo();
  }

  Future<void> fetchUserInfo() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users_info')
          .where('user_uid', isEqualTo: widget.userId)
          .get();

      if (snapshot.docs.isNotEmpty) {
        DocumentSnapshot userInfo = snapshot.docs.first;

        if (userInfo.data() != null &&
            userInfo.data() is Map<String, dynamic>) {
          final data = userInfo.data() as Map<String, dynamic>;
          if (data.containsKey('first_name')) {
            setState(() {
              firstName = data['first_name'];
            });
          }
        }
      }
    } catch (e) {
      print('Error fetching user info: $e');
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      selectedClothesId = null;
    });
  }

  Widget _buildSelectedContent() {
    if (selectedClothesId != null) {
      return Scaffold(
        body: ClothesDetailsScreen(
          clothesDocId: selectedClothesId!,
          onBackToDashboard: () {
            setState(() {
              selectedClothesId = null;
            });
          },
          userId: widget.userId,
          totalPrice: 0.0,
        ),
      );
    } else {
      return Scaffold(
        body: Column(
          children: [
            Expanded(
              child: _buildListContent(),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavBar(
          selectedIndex: _selectedIndex,
          onItemTapped: _onItemTapped,
        ),
      );
    }
  }

  Widget _buildListContent() {
    switch (_selectedIndex) {
      case 0:
        return ClothesList(
          userId: widget.userId,
          onClothesSelected: (clothesId) {
            setState(() {
              selectedClothesId = clothesId;
            });
          },
        );
      case 1:
        return CartScreen(userId: widget.userId);
      case 2:
        return ProfileScreen(userId: widget.userId);
      default:
        return const Center(child: Text('Unknown Page'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildSelectedContent();
  }
}
