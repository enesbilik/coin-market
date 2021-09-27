import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mini_market/admin/admin_home_page.dart';
import 'package:mini_market/admin/admin_main_page.dart';
import 'package:mini_market/screens/forgot_password_page.dart';
import 'package:mini_market/screens/main_page.dart';
import 'package:mini_market/screens/register_page1.dart';
import 'package:mini_market/service/auth_service.dart';
import 'package:mini_market/ui_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var _editingControllerMail = TextEditingController();
  var _editingControllerPassword = TextEditingController();
  var _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: MyAppBar.appBar,
      body: SingleChildScrollView(
        child: buildBody(),
      ),
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
          buildBanner(),
          MyPadding.hs48,
          buildMailField(),
          MyPadding.hs14,
          buildPasswordField(),
          MyPadding.hs14,
          buildMaterialButton(),
          buildForgotPassword(),
          MyPadding.hs24,
          buildCreateAccount(),
        ],
      ),
    );
  }

  Widget buildBanner() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Image.asset("assets/images/logo.png"),
        SizedBox(
          width: 20,
        ),
        Text(
          "TurCoin",
          textScaleFactor: 3,
          style: TextStyle(color: Colors.white),
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

  Widget buildPasswordField() {
    return TextField(
      controller: _editingControllerPassword,
      obscureText: true,
      decoration: InputDecoration(
        hintText: "••••••••",
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
      child: Center(child: Text("GİRİŞ YAP")),
      onPressed: () async {

        try {
          var userCredential = await _authService.signIn(
              _editingControllerMail.text, _editingControllerPassword.text);

          if (userCredential != null) {
            final DocumentSnapshot snap = await FirebaseFirestore.instance
                .collection('Person')
                .doc(userCredential.uid)
                .get();
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString('email', _editingControllerMail.text);

            if (snap["role"] == "user") {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                  (route) => false);
            } else if (snap["role"] == "admin") {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => AdminMainPage()),
                  (route) => false);
            }
          }
        } on FirebaseAuthException catch (e) {
          //print(e.message);
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(e.message.toString())));
          //TODO Alert dialog
        }
      },
    );
  }

  Widget buildForgotPassword() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ForgotPasswordPage()));
          },
          child: Text(
            "Şifremi unuttum",
            style: MyText.t16,
          ),
        ),
      ],
    );
  }

  Widget buildCreateAccount() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Henüz kayıt olmadın mı?",
          style: MyText.t16,
        ),
        TextButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => RegisterPage1()));
          },
          child: Text(
            "Kayıt Ol",
            style: MyText.tb16,
          ),
        ),
      ],
    );
  }
}
