import 'dart:async';

import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';

import '../prefs.dart';

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
  bool isInifinite;

  DeckOfDeathProvider() {
    rest = Hive.box('AppData').get(kDeckTimeLimitKey);
    isInifinite = Hive.box('AppData').get(kDeckIsInfiniteKey);
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

  void changeInfiniteMode() {
    if (isInifinite) {
      isInifinite = false;
    } else {
      isInifinite = true;
    }
    notifyListeners();
  }

  void start() {
    if (!isInifinite) {
      timer = Timer.periodic(Duration(seconds: 1), (timer) async {
        if (deck.length == 0) {
          await player.play('sounds/oh_yeah.mp3');
          isDone = true;
          timer.cancel();
          notifyListeners();
        } else {
          if (displayedSec == 0 && displayedMin > 0) {
            displayedSec = 59;
            if (displayedMin == 0) {
              await player.play('sounds/sigh.mp3');
              isFailed = true;
              isDone = true;
            }
            displayedMin--;
            notifyListeners();
          } else {
            displayedSec--;
            notifyListeners();
          }
        }
      });
    } else {
      if (deck.length == 0) {
        isDone = true;
        notifyListeners();
      }
    }
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

enum CardType { Heart, Diamond, Spade, Club, Joker }
List<String> cardNames = ['hearts', 'diamonds', 'spades', 'clubs', 'joker'];
