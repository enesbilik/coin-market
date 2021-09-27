import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mini_market/ui_settings.dart';

class UserCoinSellPage extends StatefulWidget {
  int index;

  UserCoinSellPage(this.index);

  @override
  _UserCoinSellPageState createState() => _UserCoinSellPageState();
}

class _UserCoinSellPageState extends State<UserCoinSellPage> {
  var userInfo = FirebaseFirestore.instance
      .collection('Person')
      .doc(FirebaseAuth.instance.currentUser!.uid);

  var _textEditingControllerMail = TextEditingController();
  var _textEditingControllerCoinValue = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar.appBar,
      extendBodyBehindAppBar: true,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.all(14),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MyPadding.hs48,
            buildTopText(" Coin göndermek istediğiniz kişinin mail adresi"),
            MyPadding.hs6,
            buildMailField(),
            MyPadding.hs24,
            buildTopText(" Göndermek istediğiniz coin miktarı"),
            MyPadding.hs6,
            buildCoinValueField(),
            MyPadding.hs24,
            buildMaterialButton(),
          ],
        ),
      ),
    );
  }

  Widget buildTopText(String text) {
    return Text(text, style: TextStyle(color: Colors.white, fontSize: 14));
  }

  Widget buildMailField() {
    return TextField(
      controller: _textEditingControllerMail,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        hintText: "jane@hotmail.com",
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

  Widget buildCoinValueField() {
    return TextField(
      controller: _textEditingControllerCoinValue,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: "coin miktarı",
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

  Widget buildMaterialButton() {
    return MaterialButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      height: 52,
      minWidth: double.infinity,
      color: Colors.black,
      textColor: Colors.white,
      child: Center(child: Text("Gönder")),
      onPressed: () {
        isPossible(_textEditingControllerCoinValue.text,
            _textEditingControllerMail.text);
      },
    );
  }

  isPossible(String valueOfSendCoin, String _email) async {
    int? parsedValueOfSendCoin = int.tryParse(valueOfSendCoin);
    if (parsedValueOfSendCoin == null) {
      // debugPrint("Lütfen sayısal bir değer giriniz");
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Lütfen sayısal bir değer giriniz")));
      return 0;
    }

    var snapshot = await userInfo.get();
    Map<String, dynamic> userData = snapshot.data() as Map<String, dynamic>;

    if (parsedValueOfSendCoin > userData["coin${widget.index}"] ||
        parsedValueOfSendCoin <= 0) {
      // debugPrint("Lütfen geçerli bir coin miktarı giriniz!");
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Lütfen geçerli bir coin miktarı giriniz!")));
      return 0;
    }

    var collection = FirebaseFirestore.instance
        .collection('Person')
        .where("email", isEqualTo: _email);
    var docSnapshot = await collection.get();
    if (docSnapshot.docs.isEmpty) {
      // debugPrint("Lütfen mail adresinin doğruluğundan emin olunuz!");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Lütfen mail adresninin doğruluğundan emin olunuz!")));
      return 0;
    }
    Map<String, dynamic>? data = docSnapshot.docs[0].data();

    if (data["email"] == userData["email"]) {
      // debugPrint("Kendinize coin gönderemezsiniz!");
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Kendinize coin gönderemezsiniz!")));

      return 0;
    }

    var dataRef =
        FirebaseFirestore.instance.collection('Person').doc(data["userID"]);

    ///update users data
    userInfo.update({
      "coin${widget.index}":
          userData["coin${widget.index}"] - parsedValueOfSendCoin
    });

    dataRef.update({
      "coin${widget.index}": data["coin${widget.index}"] + parsedValueOfSendCoin
    });

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("İşlem Başarılı")));
    _textEditingControllerMail.text = "";
    _textEditingControllerCoinValue.text = "";

    return 1;
  }
}
