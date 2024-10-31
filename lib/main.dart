import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';
import 'firebase_options.dart';
import './src/login/login_screen.dart';
import './src/dashboard/user_dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const VogueApp());
}

class VogueApp extends StatefulWidget {
  const VogueApp({super.key});

  @override
  VogueAppState createState() => VogueAppState();
}

class VogueAppState extends State<VogueApp> {
  final Logger logger = Logger();
  User? _user;

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      setState(() {
        _user = user;
        logger.i(user != null ? 'User signed in: ${user.uid}' : 'User signed out');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      home: _user == null ? const LoginScreen() : UserDashboard(userId: _user!.uid),
    );
  }
}
