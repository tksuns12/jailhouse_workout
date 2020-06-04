import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:wakelock/wakelock.dart';

import '../consts.dart';
import '../prefs.dart';
import 'home_screen.dart';

class InitialScreen extends StatefulWidget {
  @override
  _InitialScreenState createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  Future<void> init() async {
    await Hive.initFlutter();
    var box = await Hive.openBox('AppData');
    if (box.isEmpty) {
      box
        ..put(kJuarezHeightKey, 20)
        ..put(kJuarezRestKey, 15)
        ..put(kPyramidHeightKey, 10)
        ..put(kPyramidRestWeightKey, 10)
        ..put(kDeckTimeLimitKey, 15)
        ..put(kDeckIsInfiniteKey, true);
    }

    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => MainScreen()), (route) => false);
  }

  @override
  void initState() {
    super.initState();
    Wakelock.enable();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return Container(color: kMainColor);
  }
}
