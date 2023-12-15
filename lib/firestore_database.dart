import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(MaterialApp(home: FireStoreAdd(),debugShowCheckedModeBanner: false,));
}

class FireStoreAdd extends StatefulWidget {
  const FireStoreAdd({super.key});

  @override
  State<FireStoreAdd> createState() => _FireStoreAddState();
}

class _FireStoreAddState extends State<FireStoreAdd> {
  CollectionReference collectionReference= FirebaseFirestore.instance.collection('users');
  UserCredential? user;
  get_userid() async {
    // UserCredential user = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: "ayush@gmail.com", password: "123456789");
    user = await FirebaseAuth.instance.signInWithEmailAndPassword(email: "ayush@gmail.com", password: "123456789");
    print("user id := ${user?.user?.uid}");

    onlinadata_insert();
  }

   uploadingData() async {
    await FirebaseFirestore.instance.collection("products").add({
      'productName': "boat",
      'productPrice': '2500',
    });
  }

  onlinadata_insert() async {
   await collectionReference.doc("${user?.user?.uid}").set({
      "name":'heppin',
      "address":'nana varachha'
    });
  }
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    get_userid();
    // uploadingData();
  // onlinadata_insert();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
        if(snapshot.connectionState==ConnectionState.active){

          // if(snapshot.hasData){
            return ListView.builder(itemCount: snapshot.data!.docs.length,itemBuilder: (context, index) {
              return ListTile(
                leading: IconButton(onPressed: () {
                  collectionReference.doc('${user?.user?.uid}').update({
                    'name':'g'
                  });
                }, icon: Icon(Icons.edit)),
                title: Text("${snapshot.data!.docs[index]['name']}"),
                subtitle: Text("${snapshot.data!.docs[index]['address']}"),
              );
            },);
          // }
        }
        else{
          return CircularProgressIndicator();
        }
      },),
    );
  }
}
