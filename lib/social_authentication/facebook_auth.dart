import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebaseconnect2/firebase_options.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MaterialApp(
    home: FaceBookSignup(),
    debugShowCheckedModeBanner: false,
  ));
}

class FaceBookSignup extends StatefulWidget {
  const FaceBookSignup({super.key});

  @override
  State<FaceBookSignup> createState() => _FaceBookSignupState();
}

class _FaceBookSignupState extends State<FaceBookSignup> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: ElevatedButton(
            onPressed: () async {
              final LoginResult loginResult =
                  await FacebookAuth.instance.login();

              final OAuthCredential facebookAuthCredential =
                  FacebookAuthProvider.credential(
                      loginResult.accessToken!.token);

              FirebaseAuth.instance
                  .signInWithCredential(facebookAuthCredential)
                  .then((value) {
                print("you are login");
              });
            },
            child: Text("FaceBook")),
      ),
    );
  }
}
