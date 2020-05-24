import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:jailhouseworkout/prefs.dart';
import 'package:audioplayers/audio_cache.dart';

enum CardType { Heart, Diamond, Spade, Club, Joker }
List<String> cardNames = ['hearts', 'diamonds', 'spades', 'clubs', 'joker'];

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
          isResting = false;
          onRestFinished();
          timer.cancel();
          notifyListeners();
        } else {
          if (restTime < 5) {
            await player.play('sounds/short_beep.mp3');
            if (reps.length == 0) {
              await player.play('sounds/oh_yeah.mp3');
              isDone = true;
            }
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
  }

  void initialize() {
    isDone = false;
    isResting = false;
    reps.clear();
    for (int i = 1; i <= height; ++i) {
      this.reps.add(i);
    }
    this.reps.addAll(reps.reversed.toList());

    rest.clear();
    for (int rep in reps) {
      this.rest.add(rep * restWeight);
    }
    isResting = false;
    this.displayedReps = reps.first.toString();
    reps.removeAt(0);

    notifyListeners();
  }

  void next() {
    if (!this.isResting && rest.length > 0) {
      int restTime = rest.first;
      rest.removeAt(0);
      isResting = true;
      timer = Timer.periodic(Duration(seconds: 1), (timer) async {
        if (restTime < 1) {
          isResting = false;
          onRestFinished();
          timer.cancel();
          notifyListeners();
        } else {
          if (restTime < 5) {
            await player.play('sounds/short_beep.mp3');
            if (reps.length == 0) {
              await player.play('sounds/oh_yeah.wav');
              isDone = true;
            }
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
      await player.play('sounds/long_beep.mp3');
      isResting = false;
      displayedReps = reps.first.toString();
      reps.removeAt(0);
    }
  }

  void setHeight(int newHeight) {
    if (newHeight > 0) {
      _height = newHeight;
      notifyListeners();
    }
  }
}

class DeckOfDeathProvider with ChangeNotifier {
  List<_Card> deck = [];
  Timer timer;
  _Card displayedCard;
  int rest;
  bool isDone = false;
  bool isFailed = false;
  int displayedMin;
  int displayedSec;
  AudioCache player;

  DeckOfDeathProvider() {
    rest = Hive.box('AppData').get(kDeckTimeLimitKey);
  }

  void initialize() {
    player = AudioCache();
    isDone = false;
    isFailed = false;
    deck.clear();
    for (CardType type in CardType.values) {
      for (int i = 1; i < 14; ++i) {
        if (type != CardType.Joker) {
          deck.add(_Card(i, type));
        } else {
          if (i < 3) {
            deck.add(_Card(i, type));
          }
        }
      }
    }

    deck.shuffle();

    displayedCard = deck.first;
    deck.removeAt(0);
    displayedMin = rest;
    displayedSec = 0;
    notifyListeners();
  }

  void start() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) async {
      if (displayedSec < 1 && displayedMin < 1) {
        await player.play('sounds/oh_yeah.wav');
        isDone = true;
        timer.cancel();
      } else {
        if (displayedSec == 0) {
          displayedSec = 59;
          displayedMin--;
          if (displayedMin == 0) {
            await player.play('sounds/sigh.wav');
            isFailed = true;
          }
        } else {
          displayedSec--;
        }
        notifyListeners();
      }
    });
  }

  void next() {
    if (deck.length > 0) {
      displayedCard = deck.first;
      deck.removeAt(0);
      notifyListeners();
    }
  }
}

class _Card {
  final int number;
  final CardType type;

  _Card(this.number, this.type);

  get reps {
    if (type == CardType.Joker || number >= 10) {
      return 10;
    } else if (number == 1) {
      return 11;
    } else {
      return number;
    }
  }

  get imagePath {
    return 'assets/images/${number}_of_${cardNames[type.index]}.png';
  }
}
