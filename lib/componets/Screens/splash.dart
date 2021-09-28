import 'dart:async';

import 'package:flutter/material.dart';
import 'package:notes_firebase/componets/Screens/Homepage/homePage.dart';
import 'package:notes_firebase/main.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initFireBaseApp();
    Timer(Duration(seconds: 2), () {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) {
        return HomePage();
      }));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.green,
      ),
    );
  }
}
