import 'package:flutter/material.dart';
import 'package:uas_application/view_01_login.dart';

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(context as BuildContext, MaterialPageRoute(builder: (context) => Login()));
    });    
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: AssetImage('assets/images/logo.jpg'),
              width: 250,)
          ],
        ),
      ),
    );
  }
}