
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebaseconnect2/firebase_options.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options:  DefaultFirebaseOptions.currentPlatform
  );
  runApp(MaterialApp(home: CloudFirebase(),debugShowCheckedModeBanner: false,));
}

class CloudFirebase extends StatefulWidget {
  const CloudFirebase({super.key});

  @override
  State<CloudFirebase> createState() => _CloudFirebaseState();
}

class _CloudFirebaseState extends State<CloudFirebase> {
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  File? userimage;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(mainAxisAlignment: MainAxisAlignment.center,

         children: [
           userimage==null?CircleAvatar(
             minRadius: 100,
             backgroundColor: Colors.black,
           ):CircleAvatar(
             minRadius: 100,
             backgroundImage: FileImage(userimage!),
           ),
           TextField(
             controller: emailcontroller,
           ),
           TextField(
             controller: passwordcontroller,
           ),
           SizedBox(
             height: 20,
           ),
           ElevatedButton(onPressed: () {
             showDialog(context: context, builder: (context) {
               return AlertDialog(
                 content: Column(
                   mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextButton(onPressed: () {
                        get_image(imageSource: ImageSource.camera);
                      }, child: Text("Camera")),
                      SizedBox(
                        height: 20,
                      ),
                      TextButton(onPressed: () {
                        get_image(imageSource: ImageSource.gallery);
                      }, child: Text("storage"))
                    ],
                 ),
               );
             },);
           }, child: Text("Select Images")),
           ElevatedButton(onPressed: () async {
             await  FirebaseAuth.instance.createUserWithEmailAndPassword(email: emailcontroller.text, password: passwordcontroller.text).then((value) {
                 ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Account is created")));
               });


             UploadTask uploadtask = FirebaseStorage.instance.ref('user_profiles').child("${emailcontroller.text}").putFile(userimage!);
             TaskSnapshot tasksnashot = await uploadtask;

             String url =await tasksnashot.ref.getDownloadURL();

             print("uid := ${FirebaseAuth.instance.currentUser!.uid}");
             await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).set({
               "email":"${emailcontroller.text}",
               "image":"${url}"
             });

           }, child: Text("Submit"))
         ],
      ),
    );
  }

  get_image( {required ImageSource imageSource} ) async {
    ImagePicker picker = ImagePicker();
    XFile? image = await picker.pickImage(source: imageSource);
    if(image!=null){
      userimage = File(image.path);
    }

    setState(() {

    });
    Navigator.pop(context);
  }

}
