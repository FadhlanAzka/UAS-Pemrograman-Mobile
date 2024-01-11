import 'package:flutter/material.dart';
import 'view_00_splash.dart';
import 'view_01_login.dart';
import 'view_02_home.dart';

void main() async {
  runApp(UAS());
}

class UAS extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather',
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
        hintColor: Colors.white,
      ),
      initialRoute: '/splash',
      routes: {
        '/splash' : (context) => Splash(),
        '/login' : (context) => Login(),
        '/home' : (context) => Home()
      },
    );
  }
}