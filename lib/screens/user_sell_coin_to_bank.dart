import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mini_market/ui_settings.dart';

class UserSellToBankPage extends StatefulWidget {
  int index;

  UserSellToBankPage(this.index);

  @override
  _UserSellToBankPageState createState() => _UserSellToBankPageState();
}

class _UserSellToBankPageState extends State<UserSellToBankPage> {
  var userInfo = FirebaseFirestore.instance
      .collection('Person')
      .doc(FirebaseAuth.instance.currentUser!.uid);
  var _textEditingIbanController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: MyAppBar.appBar,
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          buildTopText("Satılacak coin : TurCoin${widget.index}"),
          MyPadding.hs24,
          buildIbanField(),
          MyPadding.hs14,
          buildMaterialButton(),
        ],
      ),
    );
  }

  Widget buildIbanField() {
    return TextField(
      controller: _textEditingIbanController,
      decoration: InputDecoration(
        hintText: "IBAN adresi",
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black, width: 3.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black, width: 3.0),
        ),
      ),
    );
  }

  MaterialButton buildMaterialButton() {
    return MaterialButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      height: 52,
      minWidth: double.infinity,
      color: Colors.black,
      textColor: Colors.white,
      child: Center(child: Text("Gönder")),
      onPressed: () async {
        var snap = await userInfo.get();
        var _coinValue = snap["coin${widget.index}"];
        var _userIban = _textEditingIbanController.text;
        if (_userIban.length != 26 || _userIban.substring(0, 2) != "TR") {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Lütfen geçerli bir iban adresi giriniz.")));
        }
        else if (_coinValue <= 0) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Elinizde satacak coin bulunmuyor!")));
        } else {
          userInfo.update({
            "isHaveBank": true,
            "userBank": _userIban,
            "wantedSellCoin": widget.index,
          });
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("IBAN adresiniz gönderildi.")));
          Navigator.pop(context);
        }
      },
    );
  }

  Widget buildTopText(String text) {
    return Text(text, style: TextStyle(color: Colors.white, fontSize: 18));
  }
}
