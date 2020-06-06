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
  bool paused;
  int pausedTime;
  AnimationController controller;

  

  void initialize() {
    player = AudioCache();
    _height = Hive.box('AppData').get(kJuarezHeightKey);
    rest = Hive.box('AppData').get(kJuarezRestKey);
    hasBegun = false;
    isDone = false;
    isResting = false;
    paused = false;
    reps.clear();
    for (int i = _height; i > _height / 2; --i) {
      this.reps.add(i);
      if (i != 1) {
        this.reps.add(_height - i + 1);
      }
    }
    displayedReps = reps.first.toString();
    reps.removeAt(0);
    notifyListeners();
  }

  void start() {
    hasBegun = true;
    notifyListeners();
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

  void onClickRepFinished() {
    if (reps.length == 0) {
      isDone = true;
      isResting = false;
      notifyListeners();
    } else {
      isResting = true;
      setTimer(rest);
    }
  }

  void onClickPause() {
    timer.cancel();
    pausedTime = int.parse(displayedRestingTime) - 1 ;
    paused = true;
    notifyListeners();
  }

  void onClickResume() {
    paused = false;
    setTimer(pausedTime);
  }

  void setTimer(int rest) {
    int restTime = rest;
    timer = Timer.periodic(Duration(seconds: 1), (timer) async {
      if (restTime >= 1) {
        displayedRestingTime = ((restTime--)).toString();
        if (restTime < 5) {
          await player.play('sounds/short_beep.mp3');
        }
      } else {
        displayedReps = reps.first.toString();
        reps.removeAt(0);
        await player.play('sounds/long_beep.mp3');
        isResting = false;
        timer.cancel();
        displayedRestingTime = rest.toString();
      }
      notifyListeners();
    });
  }
}
