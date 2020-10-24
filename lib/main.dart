import 'package:flutter/material.dart';
import 'package:restaurant/pages/homepage.dart';
import 'package:restaurant/pages/signin.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Kornkung restaurant",
      home: SignIn(),
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
