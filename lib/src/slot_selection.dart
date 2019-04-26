import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:grubtime/main.dart';

class SlotSelection extends StatefulWidget {
  @override
  _SlotSelectionState createState() => _SlotSelectionState();
}

class _SlotSelectionState extends State<SlotSelection> {

  var selectedColor = '';

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
        title: Text('Pick up your time slot'),
        actions: [addDoneButton()],
      ),
      body: buildTimeSlots(context),
    );
  }

  Widget buildTimeSlots(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
      child: Column(
        children: <Widget>[
          Text('BBQ Friday! Build a Burger! We be having 100% beef burgers no Filler, with fried onions & potato salad. If you are vegetarian we have Beyond Burgers for you.', 
            style: TextStyle(fontSize: 18.0),
          ),
          Padding(padding: EdgeInsets.only(top: 20.0),),
          Row(
            children: <Widget>[
              GestureDetector(
                child: Opacity(
                  opacity: (selectedColor == 'red' || selectedColor == '') ? 1 : 0.2,
                  child: CircleAvatar(
                    child: Text(
                      '11 - 11:30',
                      style: TextStyle(fontSize: 24.0, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    backgroundColor: Colors.red,
                    radius: (MediaQuery.of(context).size.width - 60) / 4,
                  ),
                ),
                onTap: () {
                  setState(() {
                    selectedColor = 'red';
                  });
                },
              ),
              Padding(padding: EdgeInsets.only(left: 20.0),),
              GestureDetector(
                child: Opacity(
                  opacity: (selectedColor == 'yellow' || selectedColor == '') ? 1 : 0.2,
                  child: CircleAvatar(
                    child: Text(
                      '11:30 - 12',
                      style: TextStyle(fontSize: 24.0, color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    backgroundColor: Colors.yellow,
                    radius: (MediaQuery.of(context).size.width - 60) / 4,
                  ),
                ),
                onTap: () {
                  setState(() {
                    selectedColor = 'yellow';
                  });
                },
              ),
            ],
          ),
          Padding(padding: EdgeInsets.only(top: 20.0),),
          Row(
            children: <Widget>[
              GestureDetector(
                child: Opacity(
                  opacity: (selectedColor == 'green' || selectedColor == '') ? 1 : 0.2,
                  child: CircleAvatar(
                    child: Text(
                      '12 - 12:30',
                      style: TextStyle(fontSize: 24.0, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    backgroundColor: Colors.green,
                    radius: (MediaQuery.of(context).size.width - 60) / 4,
                  ),
                ),
                onTap: () {
                  setState(() {
                    selectedColor = 'green';
                  });
                },
              ),
              Padding(padding: EdgeInsets.only(left: 20.0),),
              GestureDetector(
                child: Opacity(
                  opacity: (selectedColor == 'blue' || selectedColor == '') ? 1 : 0.2,
                  child: CircleAvatar(
                    child: Text(
                      '12:30 - 1PM',
                      style: TextStyle(fontSize: 24.0, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    backgroundColor: Colors.blue,
                    radius: (MediaQuery.of(context).size.width - 60) / 4,
                  ),
                ),
                onTap: () {
                  setState(() {
                    selectedColor = 'blue';
                  });
                },
              ),
            ],
          ),
          Padding(padding: EdgeInsets.only(top: 20.0),),
          displaySelectedTokenMessage()
        ],
      ),
    );
  }

  Widget displaySelectedTokenMessage() {
    if (selectedColor != '') {
      return Text('You selected ${selectedColor.toUpperCase()} token');
    } else {
      return Container();
    }
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
        'Its lunch time!!',
        'Your time slot starts now. Community waits for your arrival.',
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

  Widget addDoneButton() {
    if (selectedColor != '') {
      return FlatButton(
        child: Text('DONE', style: TextStyle(color: Colors.white),),
        onPressed: () async {
          await _scheduleNotification();
        },
      );
    }
    else {
      return Container();
    }
  }
}