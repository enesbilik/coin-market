import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mini_market/ui_settings.dart';

class IbanInfoPage extends StatefulWidget {
  int index;

  IbanInfoPage(this.index);

  @override
  _IbanInfoPageState createState() => _IbanInfoPageState();
}

class _IbanInfoPageState extends State<IbanInfoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.bgColor,
      appBar: MyAppBar.appBar,
      extendBodyBehindAppBar: true,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.all(10),
        child: buildIbanContainer(),
      ),
    );
  }

  Column buildIbanContainer() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Alım isteği göndermek için tıklayın.",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        MyPadding.hs24,
        MyPadding.hs14,
        buildMaterialButton(),
      ],
    );
  }

  MaterialButton buildMaterialButton() {
    var userInfo = FirebaseFirestore.instance
        .collection('Person')
        .doc(FirebaseAuth.instance.currentUser!.uid);
    return MaterialButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      height: 52,
      minWidth: double.infinity,
      color: Colors.black,
      textColor: Colors.white,
      child: Center(child: Text("Bilgilerimi Gönder")),
      onPressed: () {
        userInfo.update({
          "isWantToBuy": true,
          "wantedBuyCoin": widget.index,
        });
        showChooseDialog();
      },
    );
  }
  void showChooseDialog() async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            actions: <Widget>[
              TextButton(
                child: Text('Tamam'),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              ),
            ],
            title: Text('TurCoin almak için sıraya eklendiniz.'),
            content: Text('En kısa zamanda size dönüş yapılacaktır.'),

          );
        });
  }

}
