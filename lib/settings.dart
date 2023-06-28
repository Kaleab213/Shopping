import 'package:flutter/material.dart';
import 'package:practice_flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  late SharedPreferences prefs;

  late final TextEditingController txtWork;
  late final TextEditingController txtShort;
  late final TextEditingController txtLong;
  static const double buttonSize = 30;
  static const String WORKTIME = "workTime";
  static const String SHORTBREAK = "shortBreak";
  static const String LONGBREAK = "longBreak";
  // late int workTime;
  // late int shortBreak;
  // late int longBreak;

  @override
  void initState() {
    txtWork = TextEditingController();
    txtShort = TextEditingController();
    txtLong = TextEditingController();
    readSettings();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = const TextStyle(fontSize: 24);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: Container(
        child: GridView.count(
          crossAxisCount: 3,
          scrollDirection: Axis.vertical,
          childAspectRatio: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          padding: const EdgeInsets.all(20.0),
          children: [
            Text(
              "Work",
              style: textStyle,
            ),
            const Text(""),
            const Text(""),
            SettingsButton(
              callback: updateSetting,
              size: buttonSize,
              setting: WORKTIME,
              color: Color(0xff455a64),
              text: "-",
              value: -1,
            ),
            TextField(
              controller: txtWork,
              style: textStyle,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
            ),
            SettingsButton(
              callback: updateSetting,
              size: buttonSize,
              setting: WORKTIME,
              color: Color(0xff009688),
              text: "+",
              value: 1,
            ),
            Text(
              "Short",
              style: textStyle,
            ),
            const Text(""),
            const Text(""),
            SettingsButton(
              callback: updateSetting,
              size: buttonSize,
              setting: SHORTBREAK,
              color: Color(0xff455a64),
              text: "-",
              value: -1,
            ),
            TextField(
              controller: txtShort,
              style: textStyle,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
            ),
            SettingsButton(
              callback: updateSetting,
              size: buttonSize,
              setting: SHORTBREAK,
              color: Color(0xff009688),
              text: "+",
              value: 1,
            ),
            Text(
              "Long",
              style: textStyle,
            ),
            const Text(""),
            const Text(""),
            SettingsButton(
              callback: updateSetting,
              size: buttonSize,
              setting: LONGBREAK,
              color: Color(0xff455A64),
              text: "-",
              value: -1,
            ),
            TextField(
                controller: txtLong,
                style: textStyle,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number),
            SettingsButton(
              callback: updateSetting,
              size: buttonSize,
              setting: LONGBREAK,
              color: const Color(0xff009688),
              text: "+",
              value: 1,
            ),
          ],
        ),
      ),
    );
  }

  void readSettings() async {
    prefs = await SharedPreferences.getInstance();
    int? workTime = prefs.getInt(WORKTIME);
    if (workTime == null) {
      await prefs.setInt(WORKTIME, int.parse('30'));
      workTime = prefs.getInt(WORKTIME);
    }
    int? shortBreak = prefs.getInt(SHORTBREAK);
    if (shortBreak == null) {
      await prefs.setInt(SHORTBREAK, int.parse('5'));
      shortBreak = prefs.getInt(SHORTBREAK);
    }
//
    int? longBreak = prefs.getInt(LONGBREAK);
    if (longBreak == null) {
      await prefs.setInt(LONGBREAK, int.parse('20'));
      longBreak = prefs.getInt(LONGBREAK);
    }
    setState(() {
      txtWork.text = workTime.toString();
      txtShort.text = shortBreak.toString();
      txtLong.text = longBreak.toString();
    });
  }

  void updateSetting(String key, int value) {
    switch (key) {
      case WORKTIME:
        {
          int workTime = prefs.getInt(WORKTIME)!;
          workTime += value;
          if (workTime >= 1 && workTime <= 180) {
            prefs.setInt(WORKTIME, workTime);
            setState(() {
              txtWork.text = workTime.toString();
            });
          }
        }
        break;
      case SHORTBREAK:
        {
          int short = prefs.getInt(SHORTBREAK)!;
          short += value;
          if (short >= 1 && short <= 120) {
            prefs.setInt(SHORTBREAK, short);
            setState(() {
              txtShort.text = short.toString();
            });
          }
        }
        break;
      case LONGBREAK:
        {
          int long = prefs.getInt(LONGBREAK)!;
          long += value;
          if (long >= 1 && long <= 120) {
            prefs.setInt(LONGBREAK, long);
            setState(() {
              txtLong.text = long.toString();
            });
          }
        }
        break;
    }
  }
}
