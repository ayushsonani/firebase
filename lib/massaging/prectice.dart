import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebaseconnect2/firebase_options.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import "package:http/http.dart" as http;
import 'package:path/path.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(backgroungnotification);
  runApp(MaterialApp(
    home: TestNotification(),
    debugShowCheckedModeBanner: false,

  ));
}

Future<void> backgroungnotification(RemoteMessage message)async{
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
}


class TestNotification extends StatefulWidget {
  const TestNotification({super.key});

  @override
  State<TestNotification> createState() => _TestNotificationState();
}

class _TestNotificationState extends State<TestNotification> {


  get_notification_permission(){
    FirebaseMessaging.instance.requestPermission();
  }

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  AndroidNotificationChannel channel = AndroidNotificationChannel("Ayush", "Ayush Sonani mukeshbahi",importance: Importance.max);

  get_notification(){

    flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);

    FirebaseMessaging.onMessage.listen((event) {
      InitializationSettings settings =  InitializationSettings(android: AndroidInitializationSettings("@mipmap/ic_launcher"));

      flutterLocalNotificationsPlugin.initialize(settings);

      flutterLocalNotificationsPlugin.show(event.hashCode, event.notification?.title, event.notification?.body, NotificationDetails(
        android: AndroidNotificationDetails(channel.id, channel.name)
      ));

    });
  }

  String? token;
  get_token() async {
     token =await FirebaseMessaging.instance.getToken();
    print(" token :======================== ${token}");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get_notification();
    get_token();
    get_notification();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:TextButton(onPressed: () async {
         var response =  await http.post(Uri.parse("https://fcm.googleapis.com/fcm/send"),
           body: jsonEncode(
             {
               "to":'dViqzKQ2SGi7KCwHj_2DR_:APA91bEjDR5_89787jci3c-kfOL2Ngq-JcBrna4I1Ey7uroeNRLrBhAWyj0m_uvQeuHZjOAfSKqIYkzSSjoy5_6tSaJvM7CBtZFQErnqfg3bl7BaOB436IgsEw1nSbD85KJioEhvX6cg',
               "notification":{
                 'title':'Firebase Notification',
                 'body':'Ayush Sonani Send Notification'
               },

               // "data":{"url": "/dahboard"}
             }
           ),
           headers: {
             "Content-Type" : "application/json",
             "Authorization": "key=AAAAvDoTX60:APA91bHRKYVY3CV3ZkkCBc2QN6CQJLscv7kTyfMVvcsaRg-s3rXgyhMajiXUExnht5z3qIG0Gh6McOEvMrRrzd9nRXoZbYrUjgDVXC2c8v6EdCdTshS-rqWAoZ_9bdHDvFrhhQOa4fTB"
         },);
          },child:  Text("Send Notification")),
      ),
    );
  }
}
