import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgetPasswordFirebase extends StatefulWidget {
  const ForgetPasswordFirebase({super.key});

  @override
  State<ForgetPasswordFirebase> createState() => _ForgetPasswordFirebaseState();
}

class _ForgetPasswordFirebaseState extends State<ForgetPasswordFirebase> {
  TextEditingController email = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
           Padding(
             padding: const EdgeInsets.all(8.0),
             child: TextField(
               controller: email,
             ),
           ),
          ElevatedButton(onPressed: () {
            // FirebaseAuth.instance.signOut();
            FirebaseAuth.instance.sendPasswordResetEmail( email: '${email.text}');
          }, child: Text("ForgetPassword"))
        ],
      ),
    );
  }
}
