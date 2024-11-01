import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './components/profile_fields.dart';
import './components/process_button.dart';
import './components/add_clothes_button.dart';
import './components/logout_button.dart';

class ProfileScreen extends StatefulWidget {
  final String userId;

  const ProfileScreen({super.key, required this.userId});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic> userInfo = {};
  bool isLoading = true;
  bool hasChanges = false;

  // Firebase Authentication user instance
  User? firebaseUser;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      firebaseUser = FirebaseAuth.instance.currentUser;
      if (firebaseUser == null) {
        print("No authenticated user.");
        return;
      }
      final snapshot = await FirebaseFirestore.instance
          .collection('users_info')
          .doc(widget.userId)
          .get();

      if (snapshot.exists) {
        setState(() {
          userInfo = snapshot.data() as Map<String, dynamic>;
          userInfo['email'] = firebaseUser!.email; // Set email from Firebase Auth
          isLoading = false;
        });
      } else {
        print('User info not found in Firestore.');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching user info: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void updateHasChanges(bool value) {
    setState(() {
      hasChanges = value;
    });
  }

  Future<void> updateUserInfo() async {
    try {
      await FirebaseFirestore.instance
          .collection('users_info')
          .doc(widget.userId)
          .update(userInfo);
      setState(() {
        hasChanges = false;
      });
      await fetchUserData();
    } catch (e) {
      print('Error updating user info: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final buttonWidth = MediaQuery.of(context).size.width * 0.8;

    return Scaffold(
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.red,
              ),
            )
          : Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ProfileFields(
                        userInfo: userInfo,
                        updateHasChanges: updateHasChanges,
                      ),
                      const SizedBox(height: 20.0),
                      SizedBox(
                        width: buttonWidth,
                        child: ProcessButton(
                          hasChanges: hasChanges,
                          updateUserInfo: updateUserInfo,
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      SizedBox(
                        width: buttonWidth,
                        child: AddClothes(userId: widget.userId),
                      ),
                      const SizedBox(height: 20.0),
                      SizedBox(
                        width: buttonWidth,
                        child: LogoutButton(userId: widget.userId),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
