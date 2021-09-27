import 'package:flutter/material.dart';

class MyColors {
  static final bgColor = Color(0xff0E4560);
  static final bgColor2 = Color(0xff023047);
  static final buttonColor = Colors.black;
  static final cardColor = Color(0xff0A172C);
}

class MyPadding {
  static final hs6 = SizedBox(
    height: 6,
  );

  static final hs14 = SizedBox(
    height: 14,
  );
  static final hs48 = SizedBox(
    height: 48,
  );
  static final hs24 = SizedBox(
    height: 24,
  );

  static final ws4 = SizedBox(
    width: 4,
  );

}

class MyText {
  static final t16 = TextStyle(
    fontSize: 16,
    color: Colors.white,
  );
  static final tb16 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.2,
    color: Colors.white,
  );
}

class MyAppBar {
  static final appBar = AppBar(
    brightness: Brightness.dark,
    backgroundColor: MyColors.bgColor,
    elevation: 0,
  );
}
