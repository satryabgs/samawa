import 'package:flutter/material.dart';

class Intro1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/bg1.png'), fit: BoxFit.cover)),
        child: SafeArea(
          child: Center(
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                Center(
                  child: Image(
                    image: AssetImage('assets/images/logo212.png'),
                    height: 130,
                    width: 130,
                  ),
                ),
                Center(
                  child: Text(
                    'Welcome to Samawa',
                    style: TextStyle(
                      fontSize: 24.0,
                      letterSpacing: 2.5,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'AvenirPro',
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 40.0, right: 40.0, bottom: 50.0),
                  child: Center(
                      child: Text(
                          'Muslim Companion Application for your daily need',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 18.0,
                              fontFamily: 'Avenir',
                              letterSpacing: 0.5,
                              color: Colors.black45))),
                ),
                Image(image: AssetImage('assets/images/rectColor.png'),)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
