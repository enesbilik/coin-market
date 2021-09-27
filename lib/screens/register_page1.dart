import 'package:flutter/material.dart';
import 'package:mini_market/models/user.dart';
import 'package:mini_market/screens/register_page2.dart';
import 'package:mini_market/ui_settings.dart';

class RegisterPage1 extends StatefulWidget {
  const RegisterPage1({Key? key}) : super(key: key);

  @override
  _RegisterPage1State createState() => _RegisterPage1State();
}

class _RegisterPage1State extends State<RegisterPage1> {
  var _editingControllerName = TextEditingController();
  var _editingControllerNumber = TextEditingController();
  var _editingControllerMail = TextEditingController();
  var _editingControllerPassword = TextEditingController();
  MyUser _myUser = MyUser.withOutInfo();

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
    return SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            MyPadding.hs24,
            buildRegisterHeader(),
            MyPadding.hs48,
            buildNameField(),
            MyPadding.hs14,
            buildNumberField(),
            MyPadding.hs14,
            buildMailField(),
            MyPadding.hs14,
            buildPasswordField(),
            MyPadding.hs24,
            buildMaterialButton(),
          ],
        ),
      ),
    );
  }

  Row buildRegisterHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          "Kayıt ol",
          style: TextStyle(color: Colors.white, fontSize: 36),
        )
      ],
    );
  }

  Widget buildNameField() {
    return TextField(
      controller: _editingControllerName,
      decoration: InputDecoration(
        hintText: "Jane Ron",
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

  Widget buildNumberField() {
    return TextField(
      controller: _editingControllerNumber,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        hintText: "530 000 xx xx",
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
        hintText: "••••••••••••",
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
      child: Center(child: Text("SONRAKİ")),
      onPressed: () {
        _assignUserInfo();

      },
    );
  }

  void _assignUserInfo() {
    if (validateInput() != 1){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("${validateInput()}")));
    }
    else {
      setState(() {
        _myUser.name = _editingControllerName.text;
        _myUser.number = _editingControllerNumber.text;
        _myUser.mail = _editingControllerMail.text;
        _myUser.password = _editingControllerPassword.text;
      });

      Navigator.push(context,
          MaterialPageRoute(builder: (context) => RegisterPage2(_myUser)));
    }

  }

  validateInput() {
    if (_editingControllerName.text.length <= 2) {
      return "Lütfen ad soyad giriniz";
    }
    else if (_editingControllerNumber.text.length != 10) {
      return "Lütfen 10 haneli cep telefonu numaranızı giriniz";
    }
    else if (_editingControllerMail.text.isEmpty) {
      return "Lütfen email adresinizi giriniz";
    }

    else if(_editingControllerPassword.text.length < 6){
      return "Parola en az 6 karakter olmalı";
    }
    return 1;
  }
}
