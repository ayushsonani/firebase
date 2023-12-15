import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebaseconnect2/firebase_options.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(MaterialApp(home: PhoneOtpSystem(),));
}

class PhoneOtpSystem extends StatefulWidget {
  const PhoneOtpSystem({super.key});

  @override
  State<PhoneOtpSystem> createState() => _PhoneOtpSystemState();
}

class _PhoneOtpSystemState extends State<PhoneOtpSystem> {
  TextEditingController phonenumber = TextEditingController(text: "+91");
  TextEditingController otp = TextEditingController();

  String verifyId = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                  labelText: "phone"
              ),
              controller: phonenumber,
              keyboardType: TextInputType.number,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                  labelText: "otp"
              ),
              controller: otp,
              keyboardType: TextInputType.number,
            ),
          ),
          ElevatedButton(onPressed: () {
            FirebaseAuth.instance.verifyPhoneNumber(
                verificationCompleted: (phoneAuthCredential) {

                },
                verificationFailed: (error) {
                 print(" Error := ${error.message}");
                },
                codeSent: (verificationId, forceResendingToken) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(duration: Duration(seconds: 5),content: Text("${verificationId}")));
                  verifyId = verificationId;
                },
                codeAutoRetrievalTimeout: (verificationId) {
                  
                },
              phoneNumber: phonenumber.text.toString()
            );
          }, child: Text("send otp")),
          ElevatedButton(onPressed: () async {
          PhoneAuthCredential? caredentail = await PhoneAuthProvider.credential(verificationId: verifyId, smsCode: otp.text);
           FirebaseAuth.instance.signInWithCredential(caredentail).then((value) {
             ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("otp is true")));
           });
          }, child: Text("verify"))
        ],
      ),
    );
  }
}
