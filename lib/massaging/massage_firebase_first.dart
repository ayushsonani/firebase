import 'package:firebase_core/firebase_core.dart';
import 'package:firebaseconnect2/firebase_options.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:firebase_messaging/firebase_messaging.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(MaterialApp(
    home: MassageApp(),
    debugShowCheckedModeBanner: false,
  ));
}

class MassageApp extends StatefulWidget {
  const MassageApp({super.key});

  @override
  State<MassageApp> createState() => _MassageAppState();
}

class _MassageAppState extends State<MassageApp> {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    notifiction_permission();
  }

  notifiction_permission() async {

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    print("token := ${FirebaseMessaging.instance.getToken()}");

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          ElevatedButton(onPressed: () async {

            // print('User granted permission: ${settings.authorizationStatus}');


            String? token = await messaging.getToken(
              vapidKey: "BGpdLRs......",
            );

            print("totkn := ${token}");

          }, child: Text("Send Massage"))
        ],
      ),
    );
  }
}
