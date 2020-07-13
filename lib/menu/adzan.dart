import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:samawa/database/dbHelperIndicator.dart';
import 'package:sqflite/sqflite.dart';
import '../models/adzanIndicator.dart';
import '../notification/notificationHelper.dart';

class Adzan extends StatefulWidget {
  final List<String> data;
  const Adzan({Key key, this.data}) : super(key: key);
  @override
  _AdzanState createState() => _AdzanState();
}

class _AdzanState extends State<Adzan> {
  String adzan = '', adzanTime1 = '', timeDifference = '', timeNow;
  int bgFactor = 0, timeFactor = 0, result;
  bool loading = true;
  List<String> data, adzanTime;
  List<int> listIndicator = List<int>();
  Timer _timer;
  DbHelperIndicator dbHelperIndicator = DbHelperIndicator();
  Future<Database> dbFuture1;

  @override
  void initState() {
    super.initState();
    data = widget.data;
    adzanTime = [
      data[2],
      data[3],
      data[4],
      data[5],
      data[6],
      data[7],
    ];
    timeNow = DateFormat('H:mm:ss').format(DateTime.now());
    _setTime();
    //update time periodically
    _timer =
        Timer.periodic(Duration(seconds: 1), (Timer t) => _getDifference());
    dbFuture1 = dbHelperIndicator.initDbIndicator();
    dbFuture1.then((database) {
      Future<List<AdzanIndicator>> indicatorListFuture =
          dbHelperIndicator.getIndicatorList();
      indicatorListFuture.then((indicatorListFuture) {
        setState(() {
          listIndicator = [
            indicatorListFuture[0].indicator,
            indicatorListFuture[1].indicator,
            indicatorListFuture[2].indicator,
            indicatorListFuture[3].indicator,
            indicatorListFuture[4].indicator,
            indicatorListFuture[5].indicator,
          ];
          loading = false;
        });
      });
    });
  }

  void _getDifference() {
    //get time periodically
    final DateTime now = DateTime.now();
    final String secondNow = _formatDateTime(now);
    String difference = '';

    if (timeFactor != 7)
      result = _getSecond(adzanTime1) - _getSecond(secondNow);
    else
      result = 86400 + _getSecond(adzanTime1) - _getSecond(secondNow);

    difference = secondToDate(result);

    dbFuture1 = dbHelperIndicator.initDbIndicator();
    dbFuture1.then((database) {
      Future<List<AdzanIndicator>> indicatorListFuture =
          dbHelperIndicator.getIndicatorList();
      indicatorListFuture.then((indicatorListFuture) {
        setState(() {
          listIndicator = [
            indicatorListFuture[0].indicator,
            indicatorListFuture[1].indicator,
            indicatorListFuture[2].indicator,
            indicatorListFuture[3].indicator,
            indicatorListFuture[4].indicator,
            indicatorListFuture[5].indicator,
          ];
          loading = false;
        });
      });
    });

    setState(() {
      timeDifference = difference;
      _setTime();
      //timeString = formattedDateTime;
    });
  }

  void _setTime() {
    if (_getSecond(timeNow) < _getSecond(data[2])) {
      bgFactor = 1;
      timeFactor = 1;
      adzanTime1 = data[2];
      adzan = 'Subuh';
    } else if (_getSecond(timeNow) < _getSecond(data[3])) {
      bgFactor = 1;
      timeFactor = 2;
      adzanTime1 = data[3];
      adzan = 'Terbit';
    } else if (_getSecond(timeNow) < _getSecond(data[4])) {
      bgFactor = 2;
      timeFactor = 3;
      adzanTime1 = data[4];
      adzan = 'Dzuhur';
    } else if (_getSecond(timeNow) < _getSecond(data[5])) {
      bgFactor = 2;
      timeFactor = 4;
      adzanTime1 = data[5];
      adzan = 'Ashar';
    } else if (_getSecond(timeNow) < _getSecond(data[6])) {
      bgFactor = 3;
      timeFactor = 5;
      adzanTime1 = data[6];
      adzan = 'Maghrib';
    } else if (_getSecond(timeNow) < _getSecond(data[7])) {
      bgFactor = 1;
      timeFactor = 6;
      adzanTime1 = data[7];
      adzan = 'Isya';
    } else {
      bgFactor = 1;
      timeFactor = 7;
      adzanTime1 = data[8];
      adzan = 'Subuh (Tomorrow)';
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('H:mm:ss').format(dateTime);
  }

  int _getSecond(String time) {
    String hours, minute, second;
    hours = time.substring(0, time.indexOf(":"));
    minute = time.substring(time.indexOf(":") + 1, time.lastIndexOf(":"));
    second = time.substring(time.lastIndexOf(":") + 1);
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

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Widget _buildAdzanTime(String name, String time, int indicator, int index) {
    return Container(
      margin: const EdgeInsets.only(top: 7),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 5.0),
        child: Container(
          margin: const EdgeInsets.only(left: 4.0, right: 4.0),
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/bg2.png"),
                  fit: BoxFit.cover),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [BoxShadow(color: Colors.grey, offset: Offset(2, 2))],
              color: Colors.white),
          child: Padding(
            padding: const EdgeInsets.only(
                left: 10.0, right: 10.0, top: 10.0, bottom: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(children: [
                  Expanded(
                    child: Text(
                      name,
                      style: TextStyle(fontFamily: 'Avenir', fontSize: 28),
                    ),
                  ),
                  Text(
                    time.substring(0,5),
                    style: TextStyle(
                        fontFamily: 'AvenirPro',
                        fontWeight: FontWeight.w700,
                        fontSize: 24),
                  ),
                  SizedBox(width: 15),
                  GestureDetector(
                    onTap: () {
                      print(indicator);
                      if (indicator == 1) {
                        indicator = 0;
                        cancelNotif(index);
                      } else {
                        indicator = 1;
                        addNotif(index, time);
                      }
                      AdzanIndicator adzanIndicator =
                          AdzanIndicator(index, indicator);
                      editIndicator(adzanIndicator);
                    },
                    child: Container(
                      height: 35,
                      width: 35,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: indicator == 1
                              ? Colors.grey[50]
                              : Color(0xFF494949),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey,
                                offset: indicator == 1
                                    ? Offset(2, 2)
                                    : Offset(2, 2))
                          ]),
                      child: Icon(
                        indicator == 1
                            ? FontAwesomeIcons.volumeUp
                            : FontAwesomeIcons.ban,
                        size: 22,
                        color: indicator == 1
                            ? Color(0xFF5B5B5B)
                            : Colors.grey[50],
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                ])
              ],
            ),
          ),
          alignment: Alignment(0.0, 0.0),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
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
              top: 20.0,
              right: -70.0,
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
                  padding: const EdgeInsets.only(top: 40.0, bottom: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Hero(
                        tag: 'city',
                        child: Material(
                          color: Colors.transparent,
                          child: Text(
                            data[0] + ', ',
                            style: TextStyle(
                                color:
                                    bgFactor == 2 ? Colors.black : Colors.white,
                                fontSize: 20.0,
                                fontFamily: 'AvenirPro',
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                      Hero(
                        tag: 'date',
                        child: Material(
                          color: Colors.transparent,
                          child: Text(
                            data[1],
                            style: TextStyle(
                                color:
                                    bgFactor == 2 ? Colors.black : Colors.white,
                                fontSize: 20.0,
                                fontFamily: 'AvenirPro',
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 0.0, bottom: 0.0),
                  child: Center(
                      child: Text(
                    'Next Prayer Times',
                    style: TextStyle(
                        color: bgFactor == 2 ? Colors.black : Colors.white,
                        fontSize: 18.0,
                        fontFamily: 'AvenirPro',
                        fontWeight: FontWeight.w700),
                  )),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 20.0),
                  child: Align(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
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
                          adzan + ', ' + adzanTime1,
                          style: TextStyle(
                              color:
                                  bgFactor == 2 ? Colors.black : Colors.white,
                              fontSize: 20.0,
                              fontFamily: 'AvenirPro',
                              fontWeight: FontWeight.w700),
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Align(
                      alignment: Alignment.bottomRight,
                      child: Hero(
                        tag: 'botContainer',
                        child: Material(
                          color: Colors.transparent,
                          child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: new BorderRadius.only(
                                    topLeft: const Radius.circular(50.0),
                                    topRight: const Radius.circular(50.0),
                                  )),
                              child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 130.0, right: 130.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        child: Divider(
                                          color: Colors.black,
                                          thickness: 4,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    Text(
                                      'Based on Kemenag Jakarta Pusat\nGMT +7 · Time might be different',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: 'Avenir',
                                        fontSize: 16.0,
                                      ),
                                    ),
                                    Expanded(
                                      child: Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 30.0,
                                              right: 30.0,
                                              bottom: 30.0,
                                              top: 10),
                                          child: Container(
                                              child: ListView.builder(
                                            itemCount: adzanTime.length,
                                            // ignore: missing_return
                                            itemBuilder: (context, index) {
                                              String name;
                                              switch (index) {
                                                case 0:
                                                  name = "Subuh";
                                                  break;
                                                case 1:
                                                  name = "Sunrise";
                                                  break;
                                                case 2:
                                                  name = "Dzuhur";
                                                  break;
                                                case 3:
                                                  name = "Ashar";
                                                  break;
                                                case 4:
                                                  name = "Maghrib";
                                                  break;
                                                case 5:
                                                  name = "Isya";
                                                  break;
                                                default:
                                              }
                                              if (loading) {
                                                //
                                              } else {
                                                return _buildAdzanTime(
                                                    name,
                                                    adzanTime[index],
                                                    listIndicator[index],
                                                    index);
                                              }
                                            },
                                          )),
                                        ),
                                      ),
                                    )
                                  ])),
                        ),
                      )),
                ),
              ]),
        ])),
      ),
    );
  }

  void editIndicator(AdzanIndicator object) async {
    await dbHelperIndicator.update(object);
  }
  addNotif(int id, String time) {
    int h = int.parse(time.substring(0, 2));
    int m = int.parse(time.substring(3, 5));
    NotificationHelper().showNotification(id, h, m);
  }

  cancelNotif(int id) async{
    await NotificationHelper().cancelNotif(0);
  }
}
