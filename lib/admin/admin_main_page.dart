import 'package:flutter/material.dart';
import 'package:mini_market/admin/admin_home_page.dart';
import 'package:mini_market/admin/query_users_buy_page.dart';
import 'package:mini_market/admin/query_users_sell_page.dart';
import 'package:mini_market/screens/user_info_page.dart';

class AdminMainPage extends StatefulWidget {
  @override
  _AdminMainPageState createState() => _AdminMainPageState();
}

class _AdminMainPageState extends State<AdminMainPage> {
  int _selectedIndex = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        centerTitle: true,
        backgroundColor: Colors.black87,
        title: Text("Admin Paneli"),
      ),
      body: SafeArea(child: getCurrentBody(_selectedIndex)),
      bottomNavigationBar: getBottomBar(),
    );
  }

  Widget getCurrentBody(int index) {
    if (index == 0) return QueryAdminPage();
    if (index == 1) return QueryUserBuyPage();
    if (index == 2)
      return AdminHomePage();
    else
      return Padding(
        padding: const EdgeInsets.only(top: 24),
        child: UserInfoBody(),
      );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget getBottomBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      unselectedItemColor: Colors.white,
      backgroundColor: Colors.black,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(
            Icons.search,
          ),
          label: 'Satış İstekleri',
        ),

        BottomNavigationBarItem(
          icon: Icon(
            Icons.search,
          ),
          label: 'Alım İstekleri',
        ),


        BottomNavigationBarItem(
          icon: Icon(
            Icons.home,
          ),
          label: 'Ana sayfa',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.person,
          ),
          label: 'Hesabım',
        ),
      ],
      selectedItemColor: Colors.yellowAccent,
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
    );
  }
}
