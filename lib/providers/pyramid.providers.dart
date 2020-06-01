import 'dart:async';

import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../prefs.dart';

class PyramidProvider with ChangeNotifier {
  int _height;
  get height => _height;

  bool isResting = false;
  String displayedRestingTime;
  String displayedReps;
  int restWeight;
  List<int> reps = [];
  List<int> rest = [];
  Timer timer;
  AudioCache player;
  bool isDone;

  PyramidProvider() {
    _height = Hive.box('AppData').get(kPyramidHeightKey);
    restWeight = Hive.box('AppData').get(kPyramidRestWeightKey);
    player = AudioCache();
  }

  void initialize() {
    isDone = false;
    isResting = false;
    reps.clear();
    for (int i = 1; i <= height; ++i) {
      this.reps.add(i);
    }
    this.reps.addAll(reps.sublist(0, (reps.length - 2)).reversed.toList());

    rest.clear();
    for (int rep in reps) {
      this.rest.add(rep * restWeight);
    }
    isResting = false;
    this.displayedReps = reps.first.toString();

    notifyListeners();
  }

  void next() async {
    if (!this.isResting && rest.length > 0) {
      int restTime = rest.first;
      isResting = true;
      timer = Timer.periodic(Duration(seconds: 1), (timer) async {
        if (restTime < 1) {
          if (reps.length == 0) {
            await player.play('sounds/oh_yeah.mp3');
            isDone = true;
          }
          await onRestFinished();
          reps.removeAt(0);
          displayedReps = reps.first.toString();
          rest.removeAt(0);

          timer.cancel();
          isResting = false;
          notifyListeners();
          print(displayedReps);
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
    await player.play('sounds/long_beep.mp3');
  }

  void setHeight(int newHeight) {
    if (newHeight > 0) {
      _height = newHeight;
      notifyListeners();
    }
  }
}

