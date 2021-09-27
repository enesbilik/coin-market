import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mini_market/screens/login_page.dart';
import 'package:mini_market/ui_settings.dart';

class WalletBody extends StatefulWidget {
  const WalletBody({Key? key}) : super(key: key);

  @override
  _WalletBodyState createState() => _WalletBodyState();
}

class _WalletBodyState extends State<WalletBody> {
  final String _userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    var userInfo = FirebaseFirestore.instance.collection('Person').doc(_userId);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
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
                buildTopText(),
                buildListOfCoins(asyncSnapshot),
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
    );
  }

  Expanded buildListOfCoins(Map<String, dynamic> snapshot) {
    return Expanded(
        child: ListView.builder(
            padding: EdgeInsets.only(top: 16),
            itemCount: 4,
            itemBuilder: (context, index) {
              String path = "coin${index + 1}";
              String name = "TurCoin${index + 1}";
              return buildListCardItem(snapshot, CircleAvatar(
                backgroundImage: AssetImage("assets/images/image0.jpeg"),
              ), path, name);
            }));
  }

  Widget buildListCardItem(
      Map<String, dynamic> snapshot, Widget widget, String path, String name) {
    return Card(
      child: ListTile(
        leading: widget,
        title: Text(
          name,
          style: TextStyle(color: Colors.white),
        ),
        trailing:
            Text("${snapshot[path]}", style: TextStyle(color: Colors.white)),
      ),
      color: Colors.black38,
    );
  }

  Widget buildTopText() {
    return Column(
      children: [
        Text(
          "TurCoinlerim",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        MyPadding.hs6,
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          child: Divider(
            color: Colors.white,
            thickness: 0.6,
          ),
        ),
      ],
    );
  }
}
