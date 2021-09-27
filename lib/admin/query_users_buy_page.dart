import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mini_market/admin/query_user_detail_buy_page.dart';
import 'package:mini_market/admin/query_user_detail_page.dart';
import 'package:mini_market/admin/user_detail_page.dart';

class QueryUserBuyPage extends StatefulWidget {
  @override
  _QueryUserBuyPageState createState() => _QueryUserBuyPageState();
}

class _QueryUserBuyPageState extends State<QueryUserBuyPage> {
  var usersRef = FirebaseFirestore.instance
      .collection('Person')
      .where("isWantToBuy", isEqualTo: true);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(6),
      child: StreamBuilder<QuerySnapshot>(
        stream: usersRef.snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) return CircularProgressIndicator();

          var listOfUsers = snapshot.data.docs;
          return ListView.builder(
              itemCount: listOfUsers.length,
              itemBuilder: (context, index) {
                return Card(
                  color: Colors.black38,
                  child: ListTile(
                    onTap: () {
                      String _selectedUserId =
                          listOfUsers[index].data()["userID"];
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  QueryUserDetailBuyPage(_selectedUserId)));
                    },
                    leading: CircleAvatar(
                      backgroundImage: AssetImage("assets/images/slider8.jpeg"),
                    ),
                    trailing: Text(
                      "TurCoin ${listOfUsers[index].data()["wantedBuyCoin"]}",
                      style: TextStyle(color: Colors.white),
                    ),
                    title: Text(
                      "${listOfUsers[index].data()["userName"]}",
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      "${listOfUsers[index].data()["email"]}",
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                );
              });
        },
      ),
    );
  }
}
