import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebaseconnect2/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


Future<void> background_notification(RemoteMessage massage) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform
  );
  FirebaseMessaging.onBackgroundMessage(background_notification);
  runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: NotificationSendFirebase(),
      )
  );
}


class NotificationSendFirebase extends StatefulWidget {
  const NotificationSendFirebase({super.key});

  @override
  State<NotificationSendFirebase> createState() =>
      _NotificationSendFirebaseState();
}

class _NotificationSendFirebaseState extends State<NotificationSendFirebase> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    notification_permission();
    getnotification();
  }

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();


  notification_permission() {
    FirebaseMessaging.instance.requestPermission();
    get_token();
  }

  getnotification() async {
    AndroidNotificationChannel channel = AndroidNotificationChannel(
        "Ayush", "SonaniAyushMukeshbhai", description: "hello",
        importance: Importance.max);

    await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(
        channel);

    FirebaseMessaging.onMessage.listen((event) {
      InitializationSettings settings = InitializationSettings(
          android: AndroidInitializationSettings("@mipmap/ic_launcher")
      );

      flutterLocalNotificationsPlugin.initialize(settings,
        onDidReceiveNotificationResponse: (details) {
          // click notification to that line run
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return NotificationClickPage();
          },));
        },
        onDidReceiveBackgroundNotificationResponse: (details) {
          // click notification in background that line run
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return NotificationClickPage();
          },));
        },);
      flutterLocalNotificationsPlugin.show(
          event.hashCode, event.notification?.title, event.notification?.body,
          NotificationDetails(
              android: AndroidNotificationDetails(channel.id, channel.name)
          ));
    });
  }

  get_token() async {
    String? token = await FirebaseMessaging.instance.getToken();

    print("Token is :============== ${token}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(),
    );
  }
}


class NotificationClickPage extends StatelessWidget {
  const NotificationClickPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Text("Notification Click Page"),
      ),
    );
  }
}

