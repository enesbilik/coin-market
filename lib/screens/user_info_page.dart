import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mini_market/screens/login_page.dart';
import 'package:mini_market/ui_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserInfoBody extends StatefulWidget {
  @override
  _UserInfoBodyState createState() => _UserInfoBodyState();
}

class _UserInfoBodyState extends State<UserInfoBody> {
  final String _userId = FirebaseAuth.instance.currentUser!.uid;


  @override
  Widget build(BuildContext context) {
    var userInfo = FirebaseFirestore.instance.collection('Person').doc(_userId);

    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        width: MediaQuery.of(context).size.width,
        child: FutureBuilder<DocumentSnapshot>(
          future: userInfo.get(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError) {
              Center(
                child: Text("Something went wrong"),
              );
            }

            if (snapshot.hasData && !snapshot.data!.exists) {
              Center(
                child: Text("Document does not exist"),
              );
            }

            if (snapshot.connectionState == ConnectionState.done) {
              Map<String, dynamic> asyncSnapshot =
                  snapshot.data!.data() as Map<String, dynamic>;
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage("assets/images/slider8.jpeg"),
                    radius: 50,
                  ),

                  MyPadding.hs24,

                  buildCardItem(asyncSnapshot, Icons.person, "userName"),
                  buildDivider(),

                  buildCardItem(asyncSnapshot, Icons.mail, "email"),
                  buildDivider(),

                  buildCardItem(asyncSnapshot, Icons.phone_android, "number"),
                  buildDivider(),

                  buildCardItem(asyncSnapshot, Icons.location_on, "address"),
                  buildDivider(),

                  buildCardItem(asyncSnapshot, Icons.credit_card, "identityNo"),
                  buildDivider(),

                  buildCardItem(asyncSnapshot, Icons.cake, "birthDay"),
                  buildDivider(),

                  MyPadding.hs48,
                  buildMaterialButton(),

                  // buildTopText(),
                  // buildListOfCoins(asyncSnapshot),
                ],
              );
            }

            return Center(
              child: Container(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildMaterialButton() {
    return MaterialButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      height: 48,
      minWidth: double.infinity,
      color: Colors.black,
      textColor: Colors.white,
      child: Center(child: Text("ÇIKIŞ YAP")),
      onPressed: ()async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.remove('email');

        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
            (route) => false);
      },
    );
  }

  Widget buildDivider() {
    return SizedBox(
      height: 0,
      width: MediaQuery.of(context).size.width * 0.9,
      child: Divider(
        color: Colors.black26,
        thickness: 0.6,
      ),
    );
  }



  Widget buildCardItem(
      Map<String, dynamic> snapshot, IconData icon, String path) {
    return ListTile(
      leading: Icon(
        icon,
        color: Colors.white,
      ),
      title: Padding(
        padding: path == "address"
            ? EdgeInsets.symmetric(vertical: 8)
            : EdgeInsets.all(0),
        child: Text(
          "${snapshot[path]}",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
