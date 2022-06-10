import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:otp_verification_v1/signup_screen.dart';

class HomeScreen extends StatelessWidget {
  final String? phone;
  const HomeScreen({super.key, this.phone});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "You are Logged in successfully",
              style: TextStyle(
                  color: Colors.blueAccent,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20.0),
            Text("Phone Number : $phone"),
            MaterialButton(
              onPressed: () => logOut(context),
              color: Colors.redAccent,
              textColor: Colors.white,
              child: const Text("Logout"),
            ),
          ],
        ),
      )),
    );
  }

  Future<void> logOut(BuildContext context) async {
    try {
      final User? firebaseUser = FirebaseAuth.instance.currentUser;
      if (firebaseUser != null) {
        await FirebaseAuth.instance.signOut().then((value) => {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const SignUpScreen()),
                  (route) => false),
            });
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }
}
