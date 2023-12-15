import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebaseconnect2/firebase_options.dart';
import 'package:flutter/material.dart';

import 'forget_password.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(MaterialApp(
    home: Test(),
    debugShowCheckedModeBanner: false,
  ));
}



class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {


  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: email,
              decoration: InputDecoration(
                hintText: "Enter an email id",
                labelText: "Email id",
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: password,
              obscureText: true, // Use this to hide the password
              decoration: InputDecoration(
                hintText: "Enter a password",
                labelText: "Password",
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                UserCredential? userCredential;
                userCredential = await FirebaseAuth.instance
                    .createUserWithEmailAndPassword(
                    email: email.text, password: password.text).then((value){
                      email.clear();
                      password.clear();
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Account is created ")));
                });
              } on FirebaseAuthException catch (ex) {
                print("error := ${ex}");
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("${ex.message}")));
              }
              setState(() {});
            },
            child: Text("Submit"),
          ),
          TextButton(onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return ForgetPasswordFirebase();
            },));
          }, child: Text("Forget Password"))
        ],
      ),
    );
  }
}

