import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mini_market/screens/login_page.dart';
import 'package:mini_market/screens/wallet_page.dart';
import 'package:mini_market/ui_settings.dart';

class QueryUserDetailBuyPage extends StatefulWidget {
  String _selectedUserId;

  QueryUserDetailBuyPage(this._selectedUserId);

  @override
  _QueryUserDetailBuyPageState createState() => _QueryUserDetailBuyPageState();
}

class _QueryUserDetailBuyPageState extends State<QueryUserDetailBuyPage> {
  var _editingNewCoinValue = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                showChooseDialog();
              },
              icon: Icon(Icons.delete, color: Colors.white))
        ],
        brightness: Brightness.dark,
        backgroundColor: MyColors.bgColor,
        elevation: 0,
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    var userInfo = FirebaseFirestore.instance
        .collection('Person')
        .doc(widget._selectedUserId);

    return SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                  buildCircleAvatar(),
                  MyPadding.hs24,
                  buildCardItem(asyncSnapshot, Icons.person, "userName"),
                  buildDivider(),
                  buildCardItem(asyncSnapshot, Icons.mail, "email"),
                  buildDivider(),
                  buildCardItem(asyncSnapshot, Icons.phone_android, "number"),
                  buildDivider(),
                  buildCardItem(asyncSnapshot, Icons.credit_card, "userBank"),
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
      ),
    );
  }

  void _displayTextInputDialog(int index, int currentValue) async {
    var userInfo = FirebaseFirestore.instance
        .collection('Person')
        .doc(widget._selectedUserId);

    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            actions: <Widget>[
              TextButton(
                child: Text('İptal'),
                onPressed: () {
                  _editingNewCoinValue.text = "";
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: Text('Tamam'),
                onPressed: () {
                  setState(() {
                    userInfo.update({
                      "coin${index + 1}":
                          int.tryParse(_editingNewCoinValue.text) ??
                              currentValue,
                    });
                  });
                  _editingNewCoinValue.text = "";
                  Navigator.pop(context);
                },
              ),
            ],
            title: Text('Turcoin${index + 1} miktarı'),
            content: TextField(
              keyboardType: TextInputType.number,
              controller: _editingNewCoinValue,
              decoration: InputDecoration(hintText: "$currentValue"),
            ),
          );
        });
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

  CircleAvatar buildCircleAvatar() {
    return CircleAvatar(
      radius: 50,
      backgroundImage: AssetImage("assets/images/slider8.jpeg"),
      backgroundColor: Colors.lightBlueAccent,
    );
  }

  Widget buildCardItem(
      Map<String, dynamic> snapshot, IconData icon, String path) {
    return ListTile(
      leading: Icon(
        icon,
        color: Colors.white,
      ),
      title: Text(
        "${snapshot[path]}",
        style: TextStyle(color: Colors.white),
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
              return buildListCardItem(
                  snapshot, CircleAvatar(
                backgroundImage: AssetImage("assets/images/image0.jpeg"),
              ), path, name, index);
            }));
  }

  Widget buildListCardItem(Map<String, dynamic> snapshot, Widget widget,
      String path, String name, int index) {
    int currentValue = snapshot[path];
    return Card(
      child: ListTile(
        onTap: () {
          _displayTextInputDialog(index, currentValue);
        },
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

  void deleteUserFromQueryList() {
    var userInfo = FirebaseFirestore.instance
        .collection('Person')
        .doc(widget._selectedUserId);
    userInfo.update({
      "wantedBuyCoin": -1,
      "isWantToBuy": false,
    });
    Navigator.pop(context);
  }

  void showChooseDialog() async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            actions: <Widget>[
              TextButton(
                child: Text('İptal'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: Text('Tamam'),
                onPressed: () {
                  deleteUserFromQueryList();
                  Navigator.pop(context);
                },
              ),
            ],
            title: Text(
                'Kullanıcıyı istek listesinden silmek istediğinize emin misiniz?'),
          );
        });
  }
}
