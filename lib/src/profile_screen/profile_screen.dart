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
          userInfo['email'] = firebaseUser!.email;
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

  Future<void> updateUserPassword(
      String currentPassword, String newPassword) async {
    try {
      AuthCredential credential = EmailAuthProvider.credential(
        email: firebaseUser!.email!,
        password: currentPassword,
      );

      await firebaseUser!
          .reauthenticateWithCredential(credential)
          .then((_) async {
        print('User re-authenticated successfully.');
        await firebaseUser!.updatePassword(newPassword);
        print('Mot de passe mis à jour');
      });
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'Mot de passe incorrect';
      if (e.code == 'wrong-password') {
        errorMessage = 'The current password is incorrect.';
      } else if (e.code == 'weak-password') {
        errorMessage = 'The new password is too weak.';
      } else if (e.code == 'requires-recent-login') {
        errorMessage = 'Please log in again to change your password.';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
      );
      throw e;
    }
  }

  Future<void> updateUserInfo() async {
    try {
      if (userInfo['newPassword'] != null &&
          userInfo['newPassword'].isNotEmpty) {
        final currentPassword = await _promptForCurrentPassword();

        if (currentPassword == null) return;

        await updateUserPassword(currentPassword, userInfo['newPassword']);
      }

      final userInfoToUpdate = Map<String, dynamic>.from(userInfo);
      userInfoToUpdate.remove('newPassword');
      await FirebaseFirestore.instance
          .collection('users_info')
          .doc(widget.userId)
          .update(userInfoToUpdate);

      setState(() {
        hasChanges = false;
      });
      await fetchUserData();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vos informations ont été mises à jour'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      print('Error updating user info: $e');
      if (e is! FirebaseAuthException) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Mot de passe actuel incorrect'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<String?> _promptForCurrentPassword() async {
    final currentPasswordController = TextEditingController();

    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Saisissez le mot de passe actuel pour le changer",
              style: TextStyle(color: Colors.red)),
          content: TextField(
            controller: currentPasswordController,
            decoration: const InputDecoration(
              labelText: 'Mot de passe actuel',
              border: OutlineInputBorder(),
            ),
            obscureText: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, null),
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, currentPasswordController.text);
              },
              child: const Text('Confirmer'),
            ),
          ],
        );
      },
    );
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
