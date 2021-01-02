import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';

import 'Home.dart';

class SpalashScreen extends StatefulWidget {
  SpalashScreen({Key key}) : super(key: key);

  @override
  _SpalashScreenState createState() => _SpalashScreenState();
}

class _SpalashScreenState extends State<SpalashScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SplashScreen(
        seconds: 5,
        navigateAfterSeconds: new HomePage(),
        title: new Text(
          'Flowers Classifiers',
          style: TextStyle(
              fontSize: 30.0, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        image: new Image.asset('assets/flower.png'),
        gradientBackground: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0041, 1],
            colors: [Color(0xFFa8e063), Color(0xFF56ab2f)]),
        styleTextUnderTheLoader: new TextStyle(),
        photoSize: 150.0,
        loaderColor: Colors.white,
      ),
    );
  }
}
