import 'package:flutter/material.dart';
import 'IntroSlider/Intro0.dart';
import 'home.dart';
import 'opening/welcome.dart';
import 'menu/adzan.dart';
import 'menu/changeName.dart';
import 'menu/changeGender.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool first= true;

  @override
  void initState(){
    startTime();
    super.initState();
  }

  startTime() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool firstTime = prefs.getBool('first');
      if (firstTime != null && !firstTime) {// Not first time
        setState(() {
          first = false;
        });
      } else {// First time
        setState(() {
          first = true;
        });
      }
      print(firstTime);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Samawa',
      home: first?Intro0():Welcome(),
      routes: <String, WidgetBuilder> {
        '/home': (BuildContext context) => new Home(),
        '/welcome': (BuildContext context) => new Welcome(),
        '/adzan': (BuildContext context) => new Adzan(),
        '/changeName': (BuildContext context) => new ChangeName(),
        '/changeGender': (BuildContext context) => new ChangeGender(),
  },
    );
  }
}
