import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:otp_verification_v1/home_screen.dart';
import 'package:sms_autofill/sms_autofill.dart';

class VerificationScreen extends StatefulWidget {
  final String verificationId;
  final String phoneNumber;
  const VerificationScreen(
      {super.key, required this.verificationId, required this.phoneNumber});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  // final TextEditingController otpController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // otp load
  String? loadOTP;

  @override
  void initState() {
    _listenOtp();
    super.initState();
  }

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
                TextFieldPinAutoFill(
                  codeLength: 6,
                  style: const TextStyle(color: Colors.black, fontSize: 16.0),
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 1.0, color: Colors.blue),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(width: 1.0, color: Colors.red),
                        borderRadius: BorderRadius.circular(12.0)),
                    counterText: '',
                    hintText: "OTP",
                  ),
                  onCodeChanged: (value) {
                    // ignore: avoid_print
                    print(value);
                    loadOTP = value;
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
      String otp = loadOTP.toString().trim();

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
        } else {
          // ignore: avoid_print
          print("error");
        }
      } on FirebaseAuthException catch (e, stackTrace) {
        log(e.code.toString());
        log(stackTrace.toString());
        // ScaffoldMessenger.of(context)
        //   ..removeCurrentSnackBar()
        //   ..showSnackBar(SnackBar(content: Text(e.code.toString())));
      }
    }
  }

  void _listenOtp() async {
    await SmsAutoFill().listenForCode();
  }
}
