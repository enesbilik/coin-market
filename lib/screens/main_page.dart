import 'package:flutter/material.dart';
import 'package:mini_market/screens/home_page.dart';
import 'package:mini_market/screens/wallet_page.dart';
import 'package:mini_market/screens/user_info_page.dart';
import 'package:mini_market/ui_settings.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: MyAppBar.appBar,
      body: SafeArea(child: getCurrentBody(_selectedIndex)),
      bottomNavigationBar: getBottomBar(),
    );
  }

  Widget getCurrentBody(int index) {
    if (index == 1) return HomeBody();
    if (index == 0)
      return WalletBody();
    else
      return UserInfoBody();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget getBottomBar() {
    return BottomNavigationBar(
      unselectedItemColor: Colors.white,
      backgroundColor: Colors.black,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(
            Icons.account_balance_wallet,
          ),
          label: 'Cüzdan',
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
