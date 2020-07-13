import 'package:flutter/material.dart';

class Intro2 extends StatelessWidget {
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
                  Center(
                    child: Text(
                      'Feature',
                      style: TextStyle(
                        fontFamily: 'AvenirPro',
                        fontSize: 24.0,
                        letterSpacing: 2.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    'Samawa have 3 main feature.\nAll this feature can help you in daily',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18.0,
                        fontFamily: 'Avenir',
                        letterSpacing: 0.5,
                        color: Colors.black45),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Image(image: AssetImage('assets/images/rectColor.png'),),
                  SizedBox(
                    height: 30.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 60.0, right: 60.0),
                    child: Row(
                      children: [
                        Column(
                          children: [
                            Container(
                              width: 87.0,
                              height: 87.0,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(50.0),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black26,
                                        offset: Offset(0.0, 4.0))
                                  ]),
                              child: Center(
                                child: Image(
                                  image: AssetImage('assets/images/intro_adzan.png'),
                                  width: 212.0,
                                  height: 212.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 20.0),
                        Flexible(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Prayer Times',
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      fontFamily: 'AvenirPro',
                                      fontWeight: FontWeight.w700),
                                ),
                                Text(
                                  'Reminder notification prayer times based on Kemenag',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontSize: 14.0,
                                      fontFamily: 'Avenir',
                                      color: Colors.black45),
                                )
                              ]),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 60.0, right: 60.0),
                    child: Row(
                      children: [
                        Column(
                          children: [
                            Container(
                              width: 87.0,
                              height: 87.0,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(50.0),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black26,
                                        offset: Offset(0.0, 4.0))
                                  ]),
                              child: Center(
                                child: Image(
                                  image: AssetImage('assets/images/intro_quran.png'),
                                  width: 212.0,
                                  height: 212.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 20.0),
                        Flexible(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Qur\'an',
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      fontFamily: 'AvenirPro',
                                      fontWeight: FontWeight.w700),
                                ),
                                Text(
                                  '30 Juz Al - Quran with murottal',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontSize: 14.0,
                                      fontFamily: 'Avenir',
                                      color: Colors.black45),
                                )
                              ]),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 60.0, right: 60.0),
                    child: Row(
                      children: [
                        Column(
                          children: [
                            Container(
                              width: 87.0,
                              height: 87.0,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(50.0),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black26,
                                        offset: Offset(0.0, 4.0))
                                  ]),
                              child: Center(
                                child: Image(
                                  image: AssetImage('assets/images/intro_doa.png'),
                                  width: 212.0,
                                  height: 212.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 20.0),
                        Flexible(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Doa',
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      fontFamily: 'AvenirPro',
                                      fontWeight: FontWeight.w700),
                                ),
                                Text(
                                  'Daily doa with arabic and translate provided',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontSize: 14.0,
                                      fontFamily: 'Avenir',
                                      color: Colors.black45),
                                )
                              ]),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 45.0,
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
