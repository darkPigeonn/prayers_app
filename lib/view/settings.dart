import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/notification.dart';

class Settings extends StatefulWidget {
  Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool notifAngelus = false;
  bool notifMass = false;

  List options = [
    {
      'title': 'Alarm Doa Malaikat Tuhan',
      'isActive': false,
      'code': 'notifikasiAngelus',
      'message': 'Waktunya Doa',
      'time': Time(12, 00)
    },
    {
      'title': 'Alarm Misa Harian',
      'isActive': false,
      'code': 'notifikasiMisa',
      'message': 'Waktunya Misa',
      'time': Time(11, 00)
    }
  ];

  @override
  void initState() {
    super.initState();
    getNotifiactionStatus();
  }

  getNotifiactionStatus() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    options.map((e) {
      var code = e['code'];
      var notif = pref.getString(code).toString();
      print(notif);

      if (notif == 'actived') {
        setState(() {
          e['isActive'] = true;
        });
      }
    }).toList();
  }

  setNotificationStatus(int code, String params) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    //mengaktifkan notifikasi
    if (code == 1) {
      pref.setString(params, 'actived');
    } else if (code == 0) {
      pref.setString(params, 'deActived');
    }
  }

  onChangeFunction(newValue, option) async {
    setState(() {
      option['isActive'] = newValue;
      options[options
          .indexWhere((element) => element['code'] == option['code'])] = option;
    });

    if (newValue) {
      await scheduleWorkTime(0, option['message'], '', option['time']);
      setNotificationStatus(1, option['code']);
      Fluttertoast.showToast(
        msg: option['message'] + ' Aktif',
        backgroundColor: Color.fromARGB(255, 2, 115, 0),
        textColor: Colors.white,
      );
    } else {
      await cancelNotification();
      setNotificationStatus(0, option['code']);
      Fluttertoast.showToast(
        msg: option['message'] + ' Nonaktif',
        backgroundColor: Color.fromARGB(255, 2, 115, 0),
        textColor: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        margin: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pengaturan',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 30,
            ),
            // customSwitch(
            //     'Alarm Doa Malaikat Tuhan', notifAngelus, onChangeFunction, 1),
            // customSwitch('Alarm Misa Harian', notifMass, onChangeFunction, 0),
            Wrap(
              children: options
                  .map((e) => new Container(
                        child: customSwitch(
                            e['title'], e['isActive'], onChangeFunction, e),
                      ))
                  .toList(),
            )
          ],
        ),
      )),
    );
  }

  Widget customSwitch(
      String text, bool val, Function onChangeMethod, Map option) {
    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: TextStyle(
                fontSize: 16, fontFamily: 'Roboto', color: Colors.black),
          ),
          Spacer(),
          Container(
            height: 40,
            width: 40,
            child: FittedBox(
              fit: BoxFit.contain,
              child: CupertinoSwitch(
                  trackColor: Colors.grey,
                  activeColor: Colors.blue,
                  value: val,
                  onChanged: (newValue) {
                    onChangeMethod(newValue, option);
                  }),
            ),
          )
        ],
      ),
    );
  }
}
