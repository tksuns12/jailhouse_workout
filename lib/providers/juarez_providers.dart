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

  JuarezProvider() {
    player = AudioCache();
    _height = Hive.box('AppData').get(kJuarezHeightKey);
    rest = Hive.box('AppData').get(kJuarezRestKey);
  }

  void initialize() {
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

  void setHeight(int newHeight) {
    if (newHeight > 0) {
      _height = newHeight;
      notifyListeners();
    }
  }

  void next() {
    if (!this.isResting) {
      int restTime = this.rest;
      isResting = true;
      timer = Timer.periodic(Duration(seconds: 1), (timer) async {
        if (restTime < 1) {
          if (reps.length == 0) {
            await player.play('sounds/oh_yeah.mp3');
            isDone = true;
          }
          isResting = false;
          onRestFinished();
          timer.cancel();
          notifyListeners();
        } else {
          if (restTime < 5) {
            await player.play('sounds/short_beep.mp3');
          }
          displayedRestingTime = restTime.toString();
          --restTime;
          notifyListeners();
        }
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

