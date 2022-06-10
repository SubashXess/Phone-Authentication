import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:otp_verification_v1/otp_verification_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController phoneController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<FirebaseApp>? _firebaseApp;

  @override
  void initState() {
    _firebaseApp = Firebase.initializeApp();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: _firebaseApp,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "Phone Number Register",
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20.0),
                      TextFormField(
                        controller: phoneController,
                        decoration: InputDecoration(
                          hintText: "Enter Phone No",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0)),
                        ),
                        onChanged: (phone) {
                          // ignore: avoid_print
                          print(phone);
                        },
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Required number";
                          }
                        },
                      ),
                      const SizedBox(height: 10.0),
                      MaterialButton(
                        color: Colors.blueAccent,
                        textColor: Colors.white,
                        onPressed: () => sendOTP(),
                        child: const Text("Send OTP"),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void sendOTP() async {
    String phone = "+91${phoneController.text.trim()}";
    if (_formKey.currentState!.validate()) {
      await _auth.verifyPhoneNumber(
          phoneNumber: phone,
          timeout: const Duration(seconds: 30),
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: codeSent,
          codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
    }
  }

  void verificationCompleted(PhoneAuthCredential phoneAuthCredential) async {
    await _auth.signInWithCredential(phoneAuthCredential);
  }

  void verificationFailed(FirebaseAuthException error) {
    log(error.code.toString());
  }

  void codeSent(String verificationId, int? forceResendingToken) async {
    // ignore: avoid_print
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VerificationScreen(
          verificationId: verificationId,
          phoneNumber: phoneController.text.trim(),
        ),
      ),
    );
  }

  void codeAutoRetrievalTimeout(String verificationId) {}
}
