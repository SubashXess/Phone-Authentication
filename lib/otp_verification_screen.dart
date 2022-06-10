import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:otp_verification_v1/home_screen.dart';

class VerificationScreen extends StatefulWidget {
  final String verificationId;
  final String phoneNumber;
  const VerificationScreen(
      {super.key, required this.verificationId, required this.phoneNumber});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final TextEditingController otpController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "OTP Verification",
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  controller: otpController,
                  maxLength: 6,
                  decoration: InputDecoration(
                    hintText: "OTP",
                    counterText: '',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0)),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (otp) {
                    // ignore: avoid_print
                    print(otp);
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Required OTP";
                    }
                  },
                ),
                const SizedBox(height: 10.0),
                MaterialButton(
                  color: Colors.blueAccent,
                  textColor: Colors.white,
                  onPressed: () => verifyOTP(context),
                  child: const Text("Verify"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void verifyOTP(context) async {
    if (_formKey.currentState!.validate()) {
      String otp = otpController.text.trim();
      PhoneAuthCredential? credential = PhoneAuthProvider.credential(
          verificationId: widget.verificationId, smsCode: otp);
      // ignore: avoid_print

      try {
        UserCredential userCredential =
            await _auth.signInWithCredential(credential);
        if (userCredential.user != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => HomeScreen(phone: widget.phoneNumber)),
          );
        }
      } on FirebaseAuthException catch (e) {
        log(e.code.toString());
        // ScaffoldMessenger.of(context)
        //   ..removeCurrentSnackBar()
        //   ..showSnackBar(SnackBar(content: Text(e.code.toString())));
      }
    }
  }
}
