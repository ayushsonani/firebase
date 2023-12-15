import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebaseconnect2/phoneauth.dart';
import 'package:firebaseconnect2/social_authentication/google_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'firebase_authetication.dart';
import 'firebase_options.dart';
import 'firestore_database.dart';
import 'massaging/massage_firebase_first.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MassageApp(),
  ));
}

class AuthenticationPage extends StatefulWidget {
  const AuthenticationPage({Key? key}) : super(key: key);

  @override
  _AuthenticationPageState createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  TextEditingController title = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get_firebase_data();
  }

  List titlelist = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(labelText: "Enter a title..."),
              controller: title,
            ),
            ElevatedButton(
              onPressed: () {
                submitData();
                title.clear();
              },
              child: Text("Submit"),
            ),
            Expanded(
              child: Container(
                child: ListView.builder(itemCount: titlelist.length,itemBuilder: (context, index) {
                  return ListTile(title: Text("${titlelist[index]}"),);
                },),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> submitData() async {
    try {
      var response = await http.post(
        Uri.parse("https://fir-f3333-default-rtdb.firebaseio.com/data.json"),
        body: jsonEncode({"title": "${title.text}"}),
      );

      if (response.statusCode == 200) {
        // Data submitted successfully
        print("Data submitted successfully");
      } else {
        // Handle error
        print("Error submitting data: ${response.reasonPhrase}");
      }
    } catch (error) {
      // Handle network or other errors
      print("Error: $error");
    }
    get_firebase_data();
  }

  Map map = {};
  get_firebase_data() async {
    var response = await http.get(Uri.parse("https://fir-f3333-default-rtdb.firebaseio.com/data.json"));
    print("response := ${jsonDecode(response.body)}");
    map = jsonDecode(response.body);

    map.forEach((key, value) {
      if(!titlelist.contains(value['title'])){
        titlelist.add(value['title']);
      }
    });
    setState(() {

    });
  }
}
