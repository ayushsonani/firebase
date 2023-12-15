import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebaseconnect2/firebase_options.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(MaterialApp(home: GoogleAuthFirebase(),debugShowCheckedModeBanner: false,));
}
class GoogleAuthFirebase extends StatefulWidget {
  const GoogleAuthFirebase({super.key});

  @override
  State<GoogleAuthFirebase> createState() => _GoogleAuthFirebaseState();
}

class _GoogleAuthFirebaseState extends State<GoogleAuthFirebase> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(onPressed: () async {
              GoogleSignInAccount? googleuser = await GoogleSignIn().signIn();
              final GoogleSignInAuthentication? googleauth = await googleuser?.authentication;

              final credential = GoogleAuthProvider.credential(
                accessToken: googleauth?.accessToken,
                idToken: googleauth?.idToken,
              );
              print("token id := ${googleauth?.idToken}");

            await FirebaseAuth.instance.signInWithCredential(credential).then((value) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("google signin successfully")));
            });

            }, child: Text("Google"))
          ],
        ),
      ),
    );
  }
}
