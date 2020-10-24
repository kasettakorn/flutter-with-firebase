import 'package:flutter/material.dart';

class MyStyle {

  Color darkColor = Colors.blue.shade900;
  Color primaryColor = Colors.green;

  Widget progressIndicator() {
    return Center(
      child: CircularProgressIndicator(

      ),
    );
  }

  SizedBox sizedBox() => SizedBox(width: 8.0, height: 16.0,);

  MyStyle();

}