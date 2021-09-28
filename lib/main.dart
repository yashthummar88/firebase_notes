import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'componets/Screens/splash.dart';

initFireBaseApp() async {
  await Firebase.initializeApp();
}

void main() async {
  await WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
