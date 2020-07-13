import 'package:flutter/material.dart';
import 'package:samawa/database/dbHelperUser.dart';
import 'package:samawa/database/dbHelperAdzan.dart';
import 'package:samawa/database/dbHelperIndicator.dart';
import 'package:samawa/models/adzanIndicator.dart';
import '../models/user.dart';
import '../models/adzanNotification.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import '../home.dart';
import '../models/timeAdzan.dart';
import '../services/services.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';

class Welcome extends StatefulWidget {
  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  Timer timer, timer2, timer3, timer4;
  double height1 = 0.0, height2 = 0.0, height3 = 0.0;
  TimeAdzan timeAdzan, timeAdzanTomorrow;
  List<String> data1, data2;
  double latitude = 0.0, longitude = 0.0;
  String city, cityCode;
  DbHelperUser dbHelperUser = DbHelperUser();
  String name = "";
  int gender = 0;

  DbHelperAdzan dbHelperAdzan = DbHelperAdzan();
  DbHelperIndicator dbHelperIndicator = DbHelperIndicator();
  bool isEmpty =true;
  String adzanLocation, adzanDate;
  AdzanNotification adzanNotification;
  AdzanIndicator adzanIndicator;
  List<AdzanNotification> adzanNotificationList;


  @override
  void initState() {
    super.initState();
    final Future<Database> dbFuture1 = dbHelperUser.initDbUser();
    final Future<Database> dbFuture2 = dbHelperAdzan.initDbAdzan();
    final Future<Database> dbFuture3 = dbHelperIndicator.initDbIndicator();
    dbFuture1.then((database) {
      Future<List<User>> userListFuture = dbHelperUser.getUserList();
      userListFuture.then((userList) {
        setState(() {
          this.name = userList[0].name;
          this.gender = userList[0].gender;
        });
      });
    });

    dbFuture2.then((value) {
      Future<List<AdzanNotification>> adzanListFuture =
          dbHelperAdzan.getAdzanList();
      adzanListFuture.then((value) {
        if (value.length == 0) {
          isEmpty = true;
        } else {
          isEmpty = false;
          this.adzanDate = value[0].date;
          this.adzanLocation = value[0].location;
        }
      });
    });

    dbFuture3.then((value) {
      Future<List<AdzanIndicator>> indicatorListFuture =
          dbHelperIndicator.getIndicatorList();
      indicatorListFuture.then((value) {
        if (value.length == 0) {
          adzanIndicator = AdzanIndicator(0, 1);
          addIndicator(adzanIndicator);
          adzanIndicator = AdzanIndicator(1, 0);
          addIndicator(adzanIndicator);
          adzanIndicator = AdzanIndicator(2, 1);
          addIndicator(adzanIndicator);
          adzanIndicator = AdzanIndicator(3, 0);
          addIndicator(adzanIndicator);
          adzanIndicator = AdzanIndicator(4, 1);
          addIndicator(adzanIndicator);
          adzanIndicator = AdzanIndicator(5, 1);
          addIndicator(adzanIndicator);
        } else {
          //
        }
      });
    });
  }

  static Future<Position> getLocation() async {
    Position position = await Geolocator()
        .getLastKnownPosition(desiredAccuracy: LocationAccuracy.high);
    return position;
  }

  Future<String> getCity() async {
    final coordinates = new Coordinates(latitude, longitude);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    city = first.subAdminArea;
    if (city.contains("Kabupaten")) {
      city = city.substring(city.indexOf("Kabupaten") + 10);
    }
    return city;
  }

  _WelcomeState() {
    timer = new Timer(const Duration(milliseconds: 500), () {
      setState(() {
        height1 = 1000;
      });
    });
    timer2 = new Timer(const Duration(milliseconds: 1000), () {
      setState(() {
        height2 = 1000;
      });
    });
    timer3 = new Timer(const Duration(milliseconds: 1250), () {
      setState(() {
        height3 = 1000;
      });
    });

    Timer(const Duration(milliseconds: 500), () {
    if (isEmpty) {
      print('0');
      getLocation().then((value) {
        latitude = value.latitude;
        longitude = value.longitude;
        getCity().then((value) {
          Services.getCode(city).then((value) {
            Timer(const Duration(milliseconds: 1000), () {
              cityCode = value.kota[0].id;
              String dateNow = DateFormat('yyyy-MM-dd').format(DateTime.now());
              String dateTomorrow = DateFormat('yyyy-MM-dd')
                  .format(DateTime.now().add(Duration(days: 1)));
              Services.getTime(cityCode, dateNow).then((value) {
                  timeAdzan = value;
                    Services.getTime(cityCode, dateTomorrow).then((value) {
                      timeAdzanTomorrow = value;
                      adzanNotification = AdzanNotification(0, "Subuh",
                          timeAdzan.jadwal.data.subuh, dateNow, city);
                      addTime(adzanNotification);
                      adzanNotification = AdzanNotification(1, "Sunrise",
                          timeAdzan.jadwal.data.terbit, dateNow, city);
                      addTime(adzanNotification);
                      adzanNotification = AdzanNotification(2, "Dzuhur",
                          timeAdzan.jadwal.data.dzuhur, dateNow, city);
                      addTime(adzanNotification);
                      adzanNotification = AdzanNotification(3, "Ashar",
                          timeAdzan.jadwal.data.ashar, dateNow, city,);
                      addTime(adzanNotification);
                      adzanNotification = AdzanNotification(4, "Maghrib",
                          timeAdzan.jadwal.data.maghrib, dateNow, city);
                      addTime(adzanNotification);
                      adzanNotification = AdzanNotification(5, "Isya",
                          timeAdzan.jadwal.data.isya, dateNow, city);
                      addTime(adzanNotification);
                      adzanNotification = AdzanNotification(
                          6,
                          "Subuh (Tomorrow)",
                          timeAdzanTomorrow.jadwal.data.subuh,
                          dateTomorrow,
                          city);
                      addTime(adzanNotification);
                      Timer(const Duration(milliseconds: 2000), () {      
                      Navigator.pushReplacementNamed(context,'/home');
                      });
                    });
              });
            });
          });
        });
      });
    } else if(isEmpty == false) {
      print('sini');
      getLocation().then((value) {
        latitude = value.latitude;
        longitude = value.longitude;
        getCity().then((value) {
          if (city == adzanLocation) {
      print('a');
            String dateNow = DateFormat('yyyy-MM-dd').format(DateTime.now());
            if (dateNow == adzanDate) {
      print('b');
              Timer(const Duration(milliseconds: 1500), () {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => Home()));
              });
            } else {
              Services.getCode(city).then((value) {
      print('c');
                Timer(const Duration(milliseconds: 1000), () {
                  print('sini');
                  cityCode = value.kota[0].id;
                  String dateNow =
                      DateFormat('yyyy-MM-dd').format(DateTime.now());
                  String dateTomorrow = DateFormat('yyyy-MM-dd')
                      .format(DateTime.now().add(Duration(days: 1)));
                  Services.getTime(cityCode, dateNow).then((value) {
                    Timer(const Duration(milliseconds: 1500), () {
                      timeAdzan = value;
                      Timer(const Duration(milliseconds: 1500), () {
                        Services.getTime(cityCode, dateTomorrow).then((value) {
                          timeAdzanTomorrow = value;
                          //
                          adzanNotification = AdzanNotification(0, "Subuh",
                              timeAdzan.jadwal.data.subuh, dateNow, city);
                          editTime(adzanNotification);
                          adzanNotification = AdzanNotification(1, "Sunrise",
                              timeAdzan.jadwal.data.terbit, dateNow, city);
                          editTime(adzanNotification);
                          adzanNotification = AdzanNotification(2, "Dzuhur",
                              timeAdzan.jadwal.data.dzuhur, dateNow, city);
                          editTime(adzanNotification);
                          adzanNotification = AdzanNotification(3, "Ashar",
                              timeAdzan.jadwal.data.ashar, dateNow, city);
                          editTime(adzanNotification);
                          adzanNotification = AdzanNotification(4, "Maghrib",
                              timeAdzan.jadwal.data.maghrib, dateNow, city);
                          editTime(adzanNotification);
                          adzanNotification = AdzanNotification(5, "Isya",
                              timeAdzan.jadwal.data.isya, dateNow, city);
                          editTime(adzanNotification);
                          adzanNotification = AdzanNotification(
                              6,
                              "Subuh (Tomorrow)",
                              timeAdzanTomorrow.jadwal.data.subuh,
                              dateTomorrow,
                              city);
                          editTime(adzanNotification);
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Home()));
                        });
                      });
                    });
                  });
                });
              });
            }
          } else {
              Services.getCode(city).then((value) {
                Timer(const Duration(milliseconds: 1000), () {
                  cityCode = value.kota[0].id;
                  String dateNow =
                      DateFormat('yyyy-MM-dd').format(DateTime.now());
                  String dateTomorrow = DateFormat('yyyy-MM-dd')
                      .format(DateTime.now().add(Duration(days: 1)));
                  Services.getTime(cityCode, dateNow).then((value) {
                    Timer(const Duration(milliseconds: 1500), () {
                      timeAdzan = value;
                      Timer(const Duration(milliseconds: 1500), () {
                        Services.getTime(cityCode, dateTomorrow).then((value) {
                          timeAdzanTomorrow = value;
                          //
                          adzanNotification = AdzanNotification(0, "Subuh",
                              timeAdzan.jadwal.data.subuh, dateNow, city);
                          editTime(adzanNotification);
                          adzanNotification = AdzanNotification(1, "Sunrise",
                              timeAdzan.jadwal.data.terbit, dateNow, city);
                          editTime(adzanNotification);
                          adzanNotification = AdzanNotification(2, "Dzuhur",
                              timeAdzan.jadwal.data.dzuhur, dateNow, city);
                          editTime(adzanNotification);
                          adzanNotification = AdzanNotification(3, "Ashar",
                              timeAdzan.jadwal.data.ashar, dateNow, city);
                          editTime(adzanNotification);
                          adzanNotification = AdzanNotification(4, "Maghrib",
                              timeAdzan.jadwal.data.maghrib, dateNow, city);
                          editTime(adzanNotification);
                          adzanNotification = AdzanNotification(5, "Isya",
                              timeAdzan.jadwal.data.isya, dateNow, city);
                          editTime(adzanNotification);
                          adzanNotification = AdzanNotification(
                              6,
                              "Subuh (Tomorrow)",
                              timeAdzanTomorrow.jadwal.data.subuh,
                              dateTomorrow,
                              city);
                          editTime(adzanNotification);
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Home()));
                        });
                      });
                    });
                  });
                });
              });
          }
        });
      });
    }
    });
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: Container(
      child: SafeArea(
          child: Stack(
        children: <Widget>[
          Center(
            child: new Image.asset(
              'assets/images/bg.png',
              width: size.width,
              height: size.height,
              fit: BoxFit.cover,
            ),
          ),
          AnimatedContainer(
            duration: Duration(milliseconds: 600),
            width: size.width,
            height: height1,
            color: Color(0xFFFF5939),
          ),
          Positioned(
            top: 220,
            left: 450,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 900),
              width: size.width,
              height: height2,
              transform: Matrix4.rotationZ(0.855),
              color: Colors.white,
            ),
          ),
          Positioned(
            top: 530,
            left: -310,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 1200),
              width: size.width,
              height: height3,
              transform: Matrix4.rotationZ(-0.850),
              color: Color(0xFF302B62),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image(
                        image: AssetImage('assets/images/logo212.png'),
                        width: 60.0,
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        'Hello ' + name + '!',
                        style: TextStyle(
                            fontFamily: 'AvenirPro',
                            fontSize: 32.0,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 2.5),
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        'Bismillah...',
                        style: TextStyle(
                            fontFamily: 'Avenir',
                            fontSize: 24.0,
                            letterSpacing: 2.5),
                      ),
                      SizedBox(height: 30.0),
                      Image(
                        image: gender == 0
                            ? AssetImage('assets/images/man2.png')
                            : AssetImage('assets/images/woman2.png'),
                        height: 300,
                      )
                    ]),
              ],
            ),
          )
        ],
        overflow: Overflow.clip,
      )),
    ));
  }

  void addTime(AdzanNotification object) async {
    await dbHelperAdzan.insert(object);
  }

  void addIndicator(AdzanIndicator object) async {
    await dbHelperIndicator.insert(object);
  }

  void editTime(AdzanNotification object) async {
    await dbHelperAdzan.update(object);
  }
}
