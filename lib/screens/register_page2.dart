import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mini_market/models/user.dart';
import 'package:mini_market/service/auth_service.dart';
import 'package:mini_market/ui_settings.dart';

enum Genders { erkek, kadin }

class RegisterPage2 extends StatefulWidget {
  MyUser _myUser = MyUser.withOutInfo();

  RegisterPage2(this._myUser);

  @override
  _RegisterPage2State createState() => _RegisterPage2State();
}

class _RegisterPage2State extends State<RegisterPage2> {
  String _countAddressData = "";
  String date = "";
  DateTime selectedDate = DateTime.now();
  var _authService = AuthService();
  var _editingControllerIdentity = TextEditingController();
  var _editingControllerAddress = TextEditingController();
  Genders? _selectedGender = Genders.erkek;

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
          buildRegisterHeader(),
          MyPadding.hs48,
          buildTCField(),
          MyPadding.hs14,
          buildAddressField(),
          MyPadding.hs14,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              buildBirthDayPicker(),
              buildGenderPicker(),
            ],
          ),
          MyPadding.hs24,
          buildMaterialButton(),
          MyPadding.hs14,
          buildPrivacyPolicy(),
        ],
      ),
    );
  }

  String getSelectedGender() {
    if (_selectedGender == Genders.erkek)
      return "Erkek";
    else
      return "Kadın";
  }

  Widget buildGenderPicker() {
    return Row(
      children: [
        Row(
          children: [
            Radio(
              value: Genders.erkek,
              groupValue: _selectedGender,
              onChanged: (Genders? value) {
                setState(() {
                  _selectedGender = value;
                });
              },
            ),
            Text(
              "Erkek",
              style: TextStyle(
                  color: _selectedGender == Genders.erkek
                      ? Colors.white
                      : Colors.white70),
            ),
          ],
        ),
        Row(
          children: [
            Radio(
              value: Genders.kadin,
              groupValue: _selectedGender,
              onChanged: (Genders? value) {
                setState(() {
                  _selectedGender = value;
                });
              },
            ),
            Text(
              "Kadın",
              style: TextStyle(
                  color: _selectedGender == Genders.kadin
                      ? Colors.white
                      : Colors.white70),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildPrivacyPolicy() {
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: Text(
        "By signing up, you agree to Photo’s Terms of Service and Privacy Policy.",
        style: TextStyle(
          color: Colors.white,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget buildBirthDayPicker() {
    return MaterialButton(
      padding: EdgeInsets.all(12),
      height: 40,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      color: Colors.black,
      textColor: Colors.white,
      onPressed: () {
        _selectDate(context);
      },
      child: Text(
          // "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}"
          "Doğum tarihi"),
    );
  }

  Widget buildRegisterHeader() {
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

  Widget buildTCField() {
    return TextField(
      controller: _editingControllerIdentity,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: "TC NO",
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

  Widget buildAddressField() {
    return TextField(
      controller: _editingControllerAddress,
      maxLength: 140,
      onChanged: (value) {
        setState(() {
          _countAddressData = value;
        });
      },
      keyboardType: TextInputType.multiline,
      minLines: 5,
      maxLines: 5,
      decoration: InputDecoration(
        counterStyle: TextStyle(color: Colors.white),
        counterText: "${_countAddressData.length}/140",
        hintText: "Lütfen adres giriniz",
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

  void _selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    if (selected != null && selected != selectedDate)
      setState(() {
        selectedDate = selected;
      });
  }

  Widget buildMaterialButton() {
    return MaterialButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      height: 52,
      minWidth: double.infinity,
      color: Colors.black,
      textColor: Colors.white,
      child: Center(child: Text("KAYIT OL")),
      onPressed: () async {
        if (validateInput() != 1) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("${validateInput()}")));
        } else {
          try {
            var userCredential = (await _authService.createPerson(
              email: widget._myUser.mail!,
              password: widget._myUser.password!,
            ))
                .user;

            if (userCredential != null) {
              _authService.setUserID(
                  userName: widget._myUser.name!,
                  number: widget._myUser.number!,
                  email: widget._myUser.mail!,
                  password: widget._myUser.password!,
                  identityNo: _editingControllerIdentity.text,
                  address: _editingControllerAddress.text,
                  birthDay:
                      "${selectedDate.day} / ${selectedDate.month} / ${selectedDate.year}",
                  gender: getSelectedGender(),
                  userID: userCredential.uid);
              userCredential.updateDisplayName(widget._myUser.name!);
              Navigator.pop(context);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("Kullanıcı başarılı bir şekilde oluşturuldu")));
            }
          } on FirebaseAuthException catch (e) {
            print(e.message);
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(e.message.toString())));
            //TODO Alert Dialog
          }
        }
      },
    );
  }

  validateInput() {
    if (_editingControllerIdentity.text.length != 11) {
      return "Lütfen 11 haneli TC numaranızı giriniz";
    }
    if (_editingControllerAddress.text.length < 10) {
      return "Lütfen adresinizi daha detaylı giriniz";
    }
    return 1;
  }
}
