import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:mini_market/screens/iban_info_page.dart';
import 'package:mini_market/screens/user_sell_coin_to_bank.dart';
import 'package:mini_market/screens/user_sell_page.dart';
import 'package:mini_market/ui_settings.dart';

class HomeBody extends StatefulWidget {
  const HomeBody({Key? key}) : super(key: key);

  @override
  _HomeBodyState createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          buildImageSlider(),
          MyPadding.hs24,
          buildTopText(),
          buildListBuilder(),
        ],
      ),
    );
  }

  Widget buildImageSlider() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: ImageSlideshow(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.25,
        initialPage: 0,
        indicatorColor: Colors.blue,
        indicatorBackgroundColor: Colors.grey,
        children: [
          buildISliderImage('assets/images/slider1.jpeg'),
          buildISliderImage('assets/images/slider2.jpeg'),
          buildISliderImage('assets/images/slider3.jpeg'),
          buildISliderImage('assets/images/slider4.jpeg'),
          buildISliderImage('assets/images/slider5.jpeg'),
          buildISliderImage('assets/images/slider6.jpeg'),
          buildISliderImage('assets/images/slider7.jpeg'),
        ],
        autoPlayInterval: 5000,
        isLoop: true,
      ),
    );
  }

  Widget buildISliderImage(String path) {
    return Image.asset(
      path,
      fit: BoxFit.cover,
    );
  }

  Widget buildTopText() {
    return Column(
      children: [
        Text(
          "Türkiye Kripto Para",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
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

  Widget buildListBuilder() {
    var coinInfo =
        FirebaseFirestore.instance.collection('CoinPrice').doc("coin-price");

    return FutureBuilder<DocumentSnapshot>(
      future: coinInfo.get(),
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
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Expanded(
            child: ListView(
              padding: EdgeInsets.only(bottom: 0, right: 0, left: 0, top: 12),
              children: [
                buildCoinCard("TurCoin 1", data["coin1"], 1),
                buildCoinCard("TurCoin 2", data["coin2"], 2),
                buildCoinCard("TurCoin 3", data["coin3"], 3),
                buildCoinCard("TurCoin 4", data["coin4"], 4),
                TextButton(
                  child: Text(
                    "Bize Ulaşın",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  onPressed: () {
                    showEmailDialog();
                  },
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Divider(
                    color: Colors.white70,
                    thickness: 0.6,
                  ),
                ),
              ],
            ),
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
    );
  }

  Widget buildCoinCard(String coinName, int coinPrice, int index) {
    return Card(
      color: Colors.black38,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            buildLead(coinName),
            buildCoinPrice(coinPrice),
            buildBuySellButtons(index),
          ],
        ),
      ),
    );
  }

  Widget buildCoinPrice(int coinPrice) {
    return Text(
      "$coinPrice ₺",
      style: TextStyle(color: Colors.white, fontSize: 18),
    );
  }

  Widget buildLead(String coinName) {
    return Row(
      children: [
        CircleAvatar(
          backgroundImage: AssetImage("assets/images/image0.jpeg"),
        ),
        MyPadding.ws4,
        Text(
          "$coinName",
          style: TextStyle(color: Colors.white, fontSize: 15),
        ),
      ],
    );
  }

  Widget buildBuySellButtons(int index) {
    return Container(
      child: Row(
        children: [
          Container(
            child: MaterialButton(
                color: Colors.green[700],
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              IbanInfoPage(index)));
                },
                child: Text(
                  "Al",
                  style: TextStyle(color: Colors.white),
                )),
            width: 56,
          ),
          MyPadding.ws4,
          Container(
            child: MaterialButton(
                color: Colors.red[700],
                onPressed: () {
                  showChooseDialog(index);
                },
                child: Text(
                  "Sat",
                  style: TextStyle(color: Colors.white),
                )),
            width: 56,
          ),
        ],
      ),
    );
  }

  void showChooseDialog(int index) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            actions: <Widget>[
              TextButton(
                child: Text('Banka'),
                onPressed: () {
                  Navigator.pop(context);

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              UserSellToBankPage(index)));
                },
              ),
              TextButton(
                child: Text('Şahıs'),
                onPressed: () {
                  Navigator.pop(context);

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              UserCoinSellPage(index)));
                },
              ),
            ],
            title: Text('TurCoin satışını nereye yapmak istiyorsunuz?'),
          );
        });
  }

  void showEmailDialog() async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            actions: <Widget>[
              TextButton(
                child: Text('Tamam'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
            title: Text('e-mail adresimiz'),
            content: Text("turkcoin2021@gmail.com"),
          );
        });
  }
}
