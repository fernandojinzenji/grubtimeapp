import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:grubtime/main.dart';
import 'package:grubtime/src/slot_selection.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  var _radioValue = 0;

  @override
  void initState() {
    super.initState();
    var initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidRecieveLocalNotification);
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            Icon(Icons.restaurant),
            Padding(
              padding: EdgeInsets.only(left: 4.0),
            ),
            Text('GrubTime'),
          ],
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'SAVE',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () async {
              await _scheduleNotification();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SlotSelection()),
              );
            },
          )
        ],
      ),
      body: Padding(
        padding:
            EdgeInsets.only(left: 16.0, right: 16.0, top: 80.0, bottom: 12.0),
        child: Column(
          children: <Widget>[
            TextField(
              decoration: InputDecoration(labelText: 'Your traction email'),
            ),
            Padding(
              padding: EdgeInsets.only(top: 80.0),
            ),
            Text('Select a time to be reminded to pick up a time slot:'),
            Padding(
              padding: EdgeInsets.only(top: 16.0),
            ),
            Row(
              children: <Widget>[
                Radio(
                  value: 7,
                  groupValue: _radioValue,
                  onChanged: _handleRadioValueChange,
                ),
                Text(
                  '7:00 AM',
                  style: new TextStyle(fontSize: 16.0),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Radio(
                  value: 8,
                  groupValue: _radioValue,
                  onChanged: _handleRadioValueChange,
                ),
                Text(
                  '8:00 AM',
                  style: new TextStyle(fontSize: 16.0),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Radio(
                  value: 9,
                  groupValue: _radioValue,
                  onChanged: _handleRadioValueChange,
                ),
                Text(
                  '9:00 AM',
                  style: new TextStyle(fontSize: 16.0),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Radio(
                  value: 10,
                  groupValue: _radioValue,
                  onChanged: _handleRadioValueChange,
                ),
                Text(
                  '10:00 AM',
                  style: new TextStyle(fontSize: 16.0),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _handleRadioValueChange(value) {
    setState(() {
      _radioValue = value;
    });
  }

  Future<void> _scheduleNotification() async {
    var scheduledNotificationDateTime =
        DateTime.now().add(Duration(seconds: 10));
    var vibrationPattern = Int64List(4);
    vibrationPattern[0] = 0;
    vibrationPattern[1] = 1000;
    vibrationPattern[2] = 5000;
    vibrationPattern[3] = 2000;

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your other channel id',
        'your other channel name',
        'your other channel description',
        icon: 'secondary_icon',
        sound: 'slow_spring_board',
        largeIcon: 'sample_large_icon',
        largeIconBitmapSource: BitmapSource.Drawable,
        vibrationPattern: vibrationPattern,
        enableLights: true,
        color: const Color.fromARGB(255, 255, 0, 0),
        ledColor: const Color.fromARGB(255, 255, 0, 0),
        ledOnMs: 1000,
        ledOffMs: 500);
    var iOSPlatformChannelSpecifics =
        IOSNotificationDetails(sound: "slow_spring_board.aiff");
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.schedule(
        0,
        'Daily reminder',
        'It is time to pick up your virtual token. Dont starve!',
        scheduledNotificationDateTime,
        platformChannelSpecifics);
  }

  Future<void> onDidRecieveLocalNotification(
      int id, String title, String body, String payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    await showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
            title: Text(title),
            content: Text(body),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Text('Ok'),
                onPressed: () async {
                  Navigator.of(context, rootNavigator: true).pop();
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SlotSelection(),
                    ),
                  );
                },
              )
            ],
          ),
    );
  }

  Future<void> onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }

    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SlotSelection()),
    );
  }
}
