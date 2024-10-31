import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

  @override
  void initState() {
    super.initState();
    fetchUserInfo();
  }

  Future<void> fetchUserInfo() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users_info')
          .doc(widget.userId)
          .get();

      if (snapshot.exists) {
        setState(() {
          userInfo = snapshot.data() as Map<String, dynamic>;
          isLoading = false;
        });
      } else {
        print('User info not found.');
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
      // Refetch user info after update
      await fetchUserInfo();
      // Update the changes in UI if needed
    } catch (e) {
      print('Error updating user info: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final buttonWidth = MediaQuery.of(context).size.width * 0.8; // Set width to 80% of screen width

    return Scaffold(
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.red, // Use the specified red color for the loader
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SingleChildScrollView(
                      child: Column(
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
              ],
            ),
    );
  }
}
