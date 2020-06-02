import 'dart:async';

import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../prefs.dart';

class JuarezProvider with ChangeNotifier {
  int _height;
  get height => _height;
  int rest;
  List<int> reps = [];
  String displayedRestingTime;
  String displayedReps;
  bool isResting = false;
  bool isDone;
  Timer timer;
  AudioCache player;
  bool hasBegun = false;

  JuarezProvider() {
    player = AudioCache();
    _height = Hive.box('AppData').get(kJuarezHeightKey);
    rest = Hive.box('AppData').get(kJuarezRestKey);
  }

  void initialize() {
    hasBegun = false;
    isDone = false;
    isResting = false;
    reps.clear();
    for (int i = _height; i > 0; --i) {
      this.reps.add(i);
      if (i != 1) {
        this.reps.add(_height - i + 1);
      }
    }
    displayedReps = reps.first.toString();
    reps.removeAt(0);
  }

  void start() {
    hasBegun = true;
  }

  void setHeight(int newHeight) {
    if (newHeight > 0) {
      _height = newHeight;
      notifyListeners();
    }
  }

  void setRest(int newRest) {
    if (newRest > 0) {
      this.rest = newRest;
      notifyListeners();
    }
  }

  void next() {
    if (reps.length == 0) {
      isDone = true;
      isResting = false;
      notifyListeners();
    } else {
      isResting = true;
      int restsec = this.rest;

      timer = Timer.periodic(Duration(seconds: 1), (timer) async {
        if (restsec >= 1) {
          displayedRestingTime = (restsec--).toString();
          if (restsec < 5) {
            await player.play('sounds/short_beep.mp3');
          }
        } else {
          displayedReps = reps.first.toString();
          reps.removeAt(0);
          await player.play('sounds/long_beep.mp3');
          isResting = false;
          timer.cancel();
        }
        notifyListeners();
      });
    }
  }

  Future<void> onRestFinished() async {
    if (reps.length > 0 && !isResting) {
      isResting = false;
      displayedReps = reps.first.toString();
      reps.removeAt(0);
      await player.play('sounds/long_beep.mp3');
    }
  }
}
