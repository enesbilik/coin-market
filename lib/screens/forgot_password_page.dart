import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mini_market/service/auth_service.dart';
import 'package:mini_market/ui_settings.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  AuthService _authService = AuthService();
  var _editingControllerMail = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: MyAppBar.appBar,
      body: SingleChildScrollView(child: buildBody()),
    );
  }

  Widget buildBody() {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: 16, vertical: MediaQuery.of(context).size.height * 0.2),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            buildForgotHeader(),
            MyPadding.hs48,
            buildMailField(),
            MyPadding.hs14,
            buildMaterialButton(),
          ],
        ),
      ),
    );
  }

  Row buildForgotHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          "Şifremi unuttum",
          style: TextStyle(color: Colors.white, fontSize: 36),
        )
      ],
    );
  }

  Widget buildMailField() {
    return TextField(
      controller: _editingControllerMail,
      decoration: InputDecoration(
        hintText: "jane@example.com",
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
        try {
          await _authService.passwordReset(_editingControllerMail.text);
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                  "Şifre sıfırlama bağlantısı başarılı bir şekilde gönderildi")));
        } on FirebaseAuthException catch (e) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(e.message.toString())));
          //TODO Alert dialog
        }
      },
    );
  }
}
