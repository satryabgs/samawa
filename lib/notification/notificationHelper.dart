import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';

class NotificationHelper {

  final BehaviorSubject<String> selectNotificationSubject =
      BehaviorSubject<String>();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  AndroidInitializationSettings androidInitializationSettings;
  IOSInitializationSettings iosInitializationSettings;
  InitializationSettings initializationSettings;
  BuildContext context;

  NotificationHelper() {
    initializedNotification();
  }

  void initializedNotification() async {
    androidInitializationSettings = AndroidInitializationSettings('app_icon');
    iosInitializationSettings = IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    initializationSettings = InitializationSettings(
        androidInitializationSettings, iosInitializationSettings);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String payload) async {
      if (payload != null) {
        debugPrint('notification payload: ' + payload);
      }
      selectNotificationSubject.add(payload);
      debugPrint('notifica');
    });
  }

  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payLoad) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
                title: Text(title),
                content: Text(body),
                actions: <Widget>[
                  CupertinoDialogAction(
                    isDefaultAction: true,
                    child: Text('Okay'),
                    onPressed: () {
                      //
                    },
                  )
                ]));
  }

  Future<void> showNotification(int id,int h, int m) async {
    var time = Time(h, m, 0);
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
        'repeatDailyAtTime channel id',
        'repeatDailyAtTime channel name',
        'repeatDailyAtTime description',
      importance: Importance.Max,
      priority: Priority.High,
      sound: RawResourceAndroidNotificationSound('adzan'),
      playSound: true,
    );

    IOSNotificationDetails iosNotificationDetails = IOSNotificationDetails();
    NotificationDetails notificationDetails =
        NotificationDetails(androidNotificationDetails, iosNotificationDetails);

    // await flutterLocalNotificationsPlugin.show(
    //     0, "Hello there!", "Plaease subscribe my channel", notificationDetails);
    await flutterLocalNotificationsPlugin.showDailyAtTime(
        id, 'Adzan', 'Adzan ditempatmu sudah berkumandang. Sholat jangan ditunda-tunda ya!', time, notificationDetails);
  }
  Future<void> showNotif() async {
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'channel_Id',
      'Channel Name',
      'Channel Description',
      importance: Importance.Max,
      priority: Priority.High,
      sound: RawResourceAndroidNotificationSound('adzan'),
      enableVibration: true,
      enableLights: true,
      ticker: 'test ticker',
      playSound: true,
    );

    IOSNotificationDetails iosNotificationDetails = IOSNotificationDetails();
    NotificationDetails notificationDetails =
        NotificationDetails(androidNotificationDetails, iosNotificationDetails);

    // await flutterLocalNotificationsPlugin.show(
    //     0, "Hello there!", "Plaease subscribe my channel", notificationDetails);
    await flutterLocalNotificationsPlugin.show(
        99, 'scheduled title', 'scheduled body', notificationDetails);
  }

  Future<void> cancelNotifAll() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
  Future<void> cancelNotif(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }
}
