import 'package:flutter/material.dart';

class Intro3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/bg.png'), fit: BoxFit.cover)),
        child: SafeArea(
          child: Align(
            alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 100.0,
                ),
                Center(
                  child: Text(
                    'Friend',
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
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: Center(
                      child: Text(
                          'A person who reminds you to “Fear Allah” is your true companion worth more than anything and everything this world can possibly offer. – Abu Maryam',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 18.0,
                              fontFamily: 'Avenir',
                              letterSpacing: 1.5,
                              color: Colors.black45))),
                ),
                SizedBox(height: 50.0),
                Image(image: AssetImage('assets/images/rectColor.png'),),
                SizedBox(height: 100.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
