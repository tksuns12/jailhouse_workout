import 'dart:async';

import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../prefs.dart';

class PyramidProvider with ChangeNotifier {
  int _height;
  get height => _height;

  bool hasBegun = false;
  bool isResting = false;
  String displayedRestingTime;
  String displayedReps;
  int restWeight;
  List<int> reps = [];
  List<int> rest = [];
  Timer timer;
  AudioCache player;
  bool isDone;
  int pausedTime;
  bool paused;

  PyramidProvider() {
    _height = Hive.box('AppData').get(kPyramidHeightKey);
    restWeight = Hive.box('AppData').get(kPyramidRestWeightKey);
    player = AudioCache();
  }

  void initialize() {
    isDone = false;
    isResting = false;
    hasBegun = true;
    hasBegun = false;
    paused = false;
    reps.clear();
    for (int i = 1; i <= height; ++i) {
      this.reps.add(i);
    }
    this.reps.addAll(reps.sublist(0, (reps.length - 1)).reversed.toList());

    rest.clear();
    for (int rep in reps) {
      this.rest.add(rep * restWeight);
    }
    this.displayedReps = reps.first.toString();
    reps.removeAt(0);

    notifyListeners();
  }

  void start() {
    this.hasBegun = true;
    notifyListeners();
  }

  void onClickRepFinished() {
    if (reps.length == 0) {
      isDone = true;
      isResting = false;
      notifyListeners();
    } else {
      isResting = true;
      setTimer(rest[0]);
      rest.removeAt(0);
    }
  }

  void onClickPause() {
    timer.cancel();
    pausedTime = int.parse(displayedRestingTime);
    paused = true;
    notifyListeners();
  }

  void onClickResume() {
    paused = false;
    setTimer(pausedTime);
  }

  void setHeight(int newHeight) {
    if (newHeight > 0) {
      _height = newHeight;
      notifyListeners();
    }
  }

  void setRestWeight(int restWeight) {
    if (restWeight > 0) {
      this.restWeight = restWeight;
      notifyListeners();
    }
  }

  void setTimer(int restTime) {
    timer = Timer.periodic(Duration(seconds: 1), (timer) async {
      if (restTime >= 1) {
        displayedRestingTime = (restTime--).toString();
        if (restTime < 5) {
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
