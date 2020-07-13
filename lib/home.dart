import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:samawa/menu/adzan.dart';
import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:hijri/hijri_calendar.dart';
import 'package:samawa/database/dbHelperUser.dart';
import 'package:samawa/database/dbHelperAdzan.dart';
import 'package:samawa/database/dbHelperIndicator.dart';
import 'package:samawa/models/adzanIndicator.dart';
import 'models/user.dart';
import 'models/adzanNotification.dart';
import 'package:sqflite/sqflite.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'notification/notificationHelper.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //initiate variable for adzan time
  String adzan = '', adzanTime = '', timeDifference = '', timeNow;
  int bgFactor = 0, timeFactor = 0, result;
  var dateNow, dateApiNow;

  var dateHijriFormat = new HijriCalendar.now();
  String dateToDisplay;

  String locationToDisplay = '';

  static String images = 'assets/images/';
  List<String> menu = [images + 'quran.png', images + 'doa.png'];
  List<String> menuText = ['Quran', 'Dua'];

  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  //static List<String> dataApiNow;
  //static List<String> dataApiTomorrow;
  List<String> dataToPass;

  DbHelperUser dbHelperUser = DbHelperUser();
  DbHelperAdzan dbHelperAdzan = DbHelperAdzan();
  DbHelperIndicator dbHelperIndicator = DbHelperIndicator();
  int gender = 0;
  String subuh1 = "",
      subuh2 = "",
      sunrise1 = "",
      dzuhur1 = "",
      ashar1 = "",
      maghrib1 = "",
      isya1 = "",
      location = "",
      date = "";
  AdzanNotification adzanNotification;
  User user;

  bool loading = true;

  @override
  void initState() {
    final Future<Database> dbFuture1 = dbHelperUser.initDbUser();
    final Future<Database> dbFuture2 = dbHelperAdzan.initDbAdzan();
    final Future<Database> dbFuture3 = dbHelperIndicator.initDbIndicator();
    //get data from database
    Future.delayed(new Duration(seconds: 2), () async {
      dbFuture1.then((database) {
        Future<List<User>> userListFuture = dbHelperUser.getUserList();
        userListFuture.then((userList) {
          setState(() {
            this.gender = userList[0].gender;
          });
          dbFuture2.then((database) {
            Future<List<AdzanNotification>> adzanListFuture =
                dbHelperAdzan.getAdzanList();
            adzanListFuture.then((adzanList) {
              setState(() {
                this.subuh1 = adzanList[0].time + ":00";
                this.sunrise1 = adzanList[1].time + ":00";
                this.dzuhur1 = adzanList[2].time + ":00";
                this.ashar1 = adzanList[3].time + ":00";
                this.maghrib1 = adzanList[4].time + ":00";
                this.isya1 = adzanList[5].time + ":00";
                this.subuh2 = adzanList[6].time + ":00";
                this.location = adzanList[0].location;
                this.date = adzanList[0].date;
              });
              dbFuture3.then((value) {
                Future<List<AdzanIndicator>> indicatorListFuture =
                    dbHelperIndicator.getIndicatorList();
                indicatorListFuture.then((indicator) {
                  if (indicator[0].indicator == 1) {
                    addNotif(0, subuh1);
                  } else if (indicator[1].indicator == 1) {
                    addNotif(1, sunrise1);
                  } else if (indicator[2].indicator == 1) {
                    addNotif(2, dzuhur1);
                  } else if (indicator[3].indicator == 1) {
                    addNotif(3, ashar1);
                  } else if (indicator[4].indicator == 1) {
                    addNotif(4, maghrib1);
                  } else if (indicator[5].indicator == 1) {
                    addNotif(5, isya1);
                  }
                  locationToDisplay = location;

                  //get date and parse date
                  dateNow = DateFormat('yyyy-MM-dd').format(DateTime.now());
                  //int indexSpace = date.indexOf(" "); //get spacing after comma

                  dateApiNow = date;

                  //logic algorithmm
                  _setTime();

                  //update time periodically
                  Timer.periodic(
                      Duration(seconds: 1), (Timer t) => _getDifference());

                  //get hijri date
                  HijriCalendar.setLocal("ID");
                  dateToDisplay = dateHijriFormat.hDay.toString() +
                      " " +
                      dateHijriFormat.longMonthName +
                      " " +
                      dateHijriFormat.hYear.toString();
                  loading = false;
                });
              });
            });
          });
        });
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //
    // var now = new DateTime.now();
    //print(now);
    dataToPass = [
      locationToDisplay,
      dateToDisplay,
      subuh1,
      sunrise1,
      dzuhur1,
      ashar1,
      maghrib1,
      isya1,
      subuh2
    ];
    Size size = MediaQuery.of(context).size;
    if (loading) {
      return Scaffold(
        body: Container(
            decoration: BoxDecoration(
                image:
                    DecorationImage(image: AssetImage('assets/images/bg.png'))),
            width: size.width,
            height: size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  height: 50,
                  width: 50,
                  child: CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(Colors.black),
                    strokeWidth: 5.0,
                  ),
                )
              ],
            )),
      );
    } else {
      return MaterialApp(
        home: Scaffold(
          endDrawer: Drawer(
              child: ListView(children: [
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed("/changeName");
              },
              child: ListTile(
                  leading: Icon(
                    FontAwesomeIcons.idCard,
                    color: Colors.black,
                  ),
                  title: Text(
                    'Change Name',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontFamily: 'Avenir'),
                  )),
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed("/changeGender");
              },
              child: ListTile(
                  leading: Icon(
                    FontAwesomeIcons.userFriends,
                    color: Colors.black,
                  ),
                  title: Text(
                    'Change Friend Gender',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontFamily: 'Avenir'),
                  )),
            )
          ])),
          key: _drawerKey,
          body: Container(
            width: size.width,
            height: size.height,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage((() {
                      switch (bgFactor) {
                        case 1:
                          return 'assets/images/bgNight.png';
                        case 2:
                          return 'assets/images/bgNoon.png';
                        case 3:
                          return 'assets/images/bgEvening.png';
                        default:
                      }
                    }())),
                    fit: BoxFit.cover)),
            child: SafeArea(
                child: Stack(children: [
              Positioned(
                  top: 75.0,
                  left: 220.0,
                  child: Hero(
                    tag: 'sun',
                    child: Image(
                      image: AssetImage((() {
                        switch (bgFactor) {
                          case 1:
                            return 'assets/images/moon.png';
                          case 2:
                            return 'assets/images/sun.png';
                          case 3:
                            return 'assets/images/sun1.png';
                          default:
                        }
                      }())),
                    ),
                  )),
              Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(children: <Widget>[
                        Text(
                          'Home',
                          style: TextStyle(
                              color:
                                  bgFactor == 2 ? Colors.black : Colors.white,
                              fontFamily: 'AvenirPro',
                              fontSize: 36.0,
                              fontWeight: FontWeight.w700),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: () =>
                                  _drawerKey.currentState.openEndDrawer(),
                              child: Container(
                                  height: 43.0,
                                  width: 43.0,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.circular(30.0)),
                                  child: Icon(
                                    FontAwesomeIcons.bars,
                                    size: 22.0,
                                  )),
                            ),
                          ),
                        ),
                      ]),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                      child: Container(
                          child: (Stack(
                        children: [
                          Container(
                            height: 33.0,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16.0)),
                          ),
                          Positioned(
                            top: 6.5,
                            left: 10.0,
                            child: Icon(
                              FontAwesomeIcons.search,
                              size: 20.0,
                              color: Colors.grey,
                            ),
                          )
                        ],
                      ))),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20.0, bottom: 20.0, top: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                FontAwesomeIcons.mapMarkerAlt,
                                size: 20,
                                color:
                                    bgFactor == 2 ? Colors.black : Colors.white,
                              ),
                              SizedBox(
                                width: 5.0,
                              ),
                              // kota
                              Hero(
                                tag: 'city',
                                child: Material(
                                  color: Colors.transparent,
                                  child: Text(
                                    locationToDisplay,
                                    style: TextStyle(
                                        color: bgFactor == 2
                                            ? Colors.black
                                            : Colors.white,
                                        fontSize: 20.0,
                                        fontFamily: 'AvenirPro',
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 5.0),
                          // tanggal
                          Hero(
                            tag: 'date',
                            child: Material(
                              color: Colors.transparent,
                              child: Text(
                                dateToDisplay,
                                style: TextStyle(
                                    color: bgFactor == 2
                                        ? Colors.black
                                        : Colors.white,
                                    fontSize: 20.0,
                                    fontFamily: 'AvenirPro',
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Next Prayer Times',
                              style: TextStyle(
                                fontSize: 24.0,
                                fontFamily: 'Avenir',
                                color:
                                    bgFactor == 2 ? Colors.black : Colors.white,
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Hero(
                              tag: 'timer',
                              child: Material(
                                color: Colors.transparent,
                                child: Text(
                                  timeDifference,
                                  style: TextStyle(
                                      color: bgFactor == 2
                                          ? Colors.black
                                          : Colors.white,
                                      fontSize: 48.0,
                                      fontFamily: 'AvenirPro',
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                            ),
                            Text(
                              adzan + ', ' + adzanTime.substring(0, 5),
                              style: TextStyle(
                                fontSize: 20.0,
                                fontFamily: 'Avenir',
                                color:
                                    bgFactor == 2 ? Colors.black : Colors.white,
                              ),
                            ),
                            SizedBox(
                              height: 15.0,
                            ),
                            GestureDetector(
                              onTap: () async {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            Adzan(data: dataToPass)));
                              },
                              child: Container(
                                  padding: EdgeInsets.only(
                                      left: 20.0,
                                      right: 20.0,
                                      top: 7.0,
                                      bottom: 7.0),
                                  decoration: BoxDecoration(
                                      color: bgFactor == 1
                                          ? const Color.fromARGB(100, 0, 0, 0)
                                          : const Color.fromARGB(
                                              100, 255, 255, 255),
                                      border: Border.all(
                                        color: bgFactor == 2
                                            ? Colors.black
                                            : Colors.white,
                                      ),
                                      borderRadius:
                                          BorderRadius.circular(25.0)),
                                  child: Text(
                                    'see more',
                                    style: TextStyle(
                                      color: bgFactor == 2
                                          ? Colors.black
                                          : Colors.white,
                                    ),
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Align(
                          alignment: Alignment.bottomRight,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      Align(
                                        alignment: Alignment.bottomLeft,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 20.0),
                                          child: Image(
                                            height: 230,
                                            image: gender == 0
                                                ? AssetImage(
                                                    'assets/images/man3.png')
                                                : AssetImage(
                                                    'assets/images/woman3.png'),
                                          ),
                                        ),
                                      ),
                                      Flexible(
                                        child: Align(
                                          alignment: Alignment.bottomRight,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10.0, right: 20.0),
                                            child: Column(children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16)),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10.0,
                                                          top: 5.0,
                                                          bottom: 5.0,
                                                          right: 5.0),
                                                  child: Text(
                                                      'Assalamualaikum.\nDont forget to recite Quran.',
                                                      style: TextStyle(
                                                          fontFamily: 'Avenir',
                                                          fontSize: 14,
                                                          color: Colors.black)),
                                                ),
                                              ),
                                              Flexible(
                                                child: Container(
                                                  height: 130.0,
                                                  child: ListView.builder(
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      itemCount: menu.length,
                                                      itemBuilder:
                                                          (BuildContext context,
                                                              int index) {
                                                        return Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  top: 10.0,
                                                                  bottom: 10.0,
                                                                  right: 10.0),
                                                          height: 110.0,
                                                          width: 107.0,
                                                          decoration: BoxDecoration(
                                                              color:
                                                                  Colors.white,
                                                              boxShadow: [
                                                                BoxShadow(
                                                                    color: Colors
                                                                        .grey,
                                                                    offset:
                                                                        Offset(
                                                                            0.1,
                                                                            2.0))
                                                              ],
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10.0)),
                                                          child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Image(
                                                                  image: AssetImage(
                                                                      menu[
                                                                          index]),
                                                                ),
                                                                SizedBox(
                                                                  height: 5,
                                                                ),
                                                                Text(
                                                                  menuText[
                                                                      index],
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          'Avenir',
                                                                      fontSize:
                                                                          18,
                                                                      letterSpacing:
                                                                          1.5),
                                                                )
                                                              ]),
                                                        );
                                                      }),
                                                ),
                                              ),
                                            ]),
                                          ),
                                        ),
                                      )
                                    ]),
                              ),
                              Hero(
                                tag: 'botContainer',
                                child: Container(
                                  height: 25.0,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: new BorderRadius.only(
                                        topLeft: const Radius.circular(50.0),
                                        topRight: const Radius.circular(50.0),
                                      )),
                                ),
                              ),
                            ],
                          )),
                    ),
                  ]),
            ])),
          ),
        ),
      );
    }
  }

  void _getDifference() {
    //get time periodically
    final DateTime now = DateTime.now();
    final String secondNow = _formatDateTime(now);
    String difference = '';

    if (timeFactor != 7)
      result = _getSecond(adzanTime) - _getSecond(secondNow);
    else
      result = 86400 + _getSecond(adzanTime) - _getSecond(secondNow);
    if (result == 0 || result == 86400 || result < 0) {
      setState(() {
        _setTime();
      });
    }

    final Future<Database> dbFuture1 = dbHelperUser.initDbUser();
    dbFuture1.then((database) {
      Future<List<User>> userListFuture = dbHelperUser.getUserList();
      userListFuture.then((userList) {
        setState(() {
          this.gender = userList[0].gender;
        });
      });
    });

    difference = secondToDate(result);
    setState(() {
      timeDifference = difference;
      //timeString = formattedDateTime;
    });
  }

  savePref(String name, String value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    setState(() {
      preferences.setString(name, value);
    });
  }

  int _getSecond(String data) {
    String hours, minute, second;
    hours = data.substring(0, data.indexOf(":"));
    minute = data.substring(data.indexOf(":") + 1, data.lastIndexOf(":"));
    second = data.substring(data.lastIndexOf(":") + 1);
    int seconds =
        int.parse(hours) * 60 * 60 + int.parse(minute) * 60 + int.parse(second);
    return seconds;
  }

  String secondToDate(int second) {
    String timeToDisplay;
    if (second < 60) {
      timeToDisplay = second.toString().padLeft(2, '0');
      second = second - 1;
    } else if (second < 3600) {
      int m = second ~/ 60;
      int s = second - (60 * m);
      timeToDisplay =
          m.toString().padLeft(2, '0') + ":" + s.toString().padLeft(2, '0');
      second = second - 1;
    } else {
      int h = second ~/ 3600;
      int t = second - (3600 * h);
      int m = t ~/ 60;
      int s = t - (60 * m);
      timeToDisplay = h.toString().padLeft(2, '0') +
          ":" +
          m.toString().padLeft(2, '0') +
          ":" +
          s.toString().padLeft(2, '0');
      second = second - 1;
    }
    return timeToDisplay;
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('H:mm:ss').format(dateTime);
  }

  void _setTime() {
    //get time
    timeNow = DateFormat('H:mm:ss').format(DateTime.now());
    //print(timeNow);

    if (dateNow == dateApiNow) {
      if (_getSecond(timeNow) < _getSecond(subuh1)) {
        bgFactor = 1;
        timeFactor = 1;
        adzanTime = subuh1;
        adzan = 'Subuh';
      } else if (_getSecond(timeNow) < _getSecond(sunrise1)) {
        bgFactor = 1;
        timeFactor = 2;
        adzanTime = sunrise1;
        adzan = 'Terbit';
      } else if (_getSecond(timeNow) < _getSecond(dzuhur1)) {
        bgFactor = 2;
        timeFactor = 3;
        adzanTime = dzuhur1;
        adzan = 'Dzuhur';
      } else if (_getSecond(timeNow) < _getSecond(ashar1)) {
        bgFactor = 2;
        timeFactor = 4;
        adzanTime = ashar1;
        adzan = 'Ashar';
      } else if (_getSecond(timeNow) < _getSecond(maghrib1)) {
        bgFactor = 3;
        timeFactor = 5;
        adzanTime = maghrib1;
        adzan = 'Maghrib';
      } else if (_getSecond(timeNow) < _getSecond(isya1)) {
        bgFactor = 1;
        timeFactor = 6;
        adzanTime = isya1;
        adzan = 'Isya';
      } else {
        bgFactor = 1;
        timeFactor = 7;
        adzanTime = subuh2;
        adzan = 'Subuh (Tomorrow)';
      }
    } else {}
  }

  getPref(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String data = prefs.getString(name);

    print(data);
  }

  addNotif(int id, String time) {
    int h = int.parse(time.substring(0, 2));
    int m = int.parse(time.substring(3, 5));
    NotificationHelper().showNotification(id, h, m);
  }
}
