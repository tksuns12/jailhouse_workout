import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:hive/hive.dart';
import 'package:jailhouseworkout/consts.dart';
import 'package:jailhouseworkout/prefs.dart';
import 'package:jailhouseworkout/providers/deck_of_death_provider.dart';
import 'package:provider/provider.dart';

class DeckOfDeathScreen extends StatefulWidget {
  @override
  _DeckOfDeathScreenState createState() => _DeckOfDeathScreenState();
}

class _DeckOfDeathScreenState extends State<DeckOfDeathScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, DeckOfDeathProvider deck, child) {
        return WillPopScope(
          child: Material(
            color: kMainColor,
            child: SafeArea(
                child: deck.isDone
                    ? deck.isFailed
                        ? Container(
                            child: Text("Time is up :(\nTry Next Time!"),
                          )
                        : Container(
                            child: Center(
                              child: Text("Well Done!"),
                            ),
                          )
                    : Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              NeumorphicButton(
                                  margin: EdgeInsets.all(7),
                                  boxShape: NeumorphicBoxShape.circle(),
                                  child: Icon(Icons.arrow_back,
                                      color: kAccentColor),
                                  style: NeumorphicStyle(
                                      color: kMainColor, intensity: 0.9),
                                  onPressed: () {
                                    if (deck.hasBegun && !deck.isInfinite) {
                                      deck.timer.cancel();
                                    }
                                    Navigator.of(context).pop();
                                  }),
                              Spacer(),
                              Text(
                                "Deck of Death",
                                style: TextStyle(
                                    fontSize: 20, color: kAccentColor),
                              ),
                              Spacer(
                                flex: 2,
                              ),
                            ],
                          ),
                          Spacer(),
                          Column(
                            children: <Widget>[
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.4,
                                width: MediaQuery.of(context).size.height *
                                    0.4 *
                                    0.69,
                                child: NeumorphicButton(
                                  boxShape: deck.hasBegun
                                      ? NeumorphicBoxShape.roundRect(
                                          BorderRadius.circular(10))
                                      : NeumorphicBoxShape.circle(),
                                  padding: EdgeInsets.all(1),
                                  onPressed: () {
                                    if (deck.hasBegun) {
                                      deck.next();
                                    } else {
                                      deck.start();
                                    }
                                  },
                                  child: deck.hasBegun
                                      ? Image.asset(
                                          deck.displayedCard.imagePath)
                                      : Center(
                                          child: Text(
                                            "SHUFFLE!",
                                            style: TextStyle(
                                                fontSize: 40,
                                                color: kDarkerAccentColor),
                                            key: ValueKey(2),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                  style: NeumorphicStyle(
                                      intensity: 0.8,
                                      color: kMainColor,
                                      depth: 10),
                                ),
                              ),
                              SizedBox(height: 30),
                              SizedBox(
                                height: 80,
                                width: 200,
                                child: deck.hasBegun
                                    ? deck.isInfinite
                                        ? Center(
                                            child: Text(
                                            "Speed Doesn't Matter",
                                            style: TextStyle(fontSize: 20, color: kDarkerAccentColor),
                                          ))
                                        : Text(
                                            "${deck.displayedMin.toString().padLeft(2, '0')}:${deck.displayedSec.toString().padLeft(2, '0')}",
                                            style: TextStyle(
                                                fontSize: 60,
                                                fontFamily: "PocketCal",
                                                color: kNumberColor),
                                            textAlign: TextAlign.center,
                                          )
                                    : Column(
                                        children: <Widget>[
                                          Text("No Limit Mode"),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 10),
                                            child: NeumorphicSwitch(
                                              style: NeumorphicSwitchStyle(
                                                  activeTrackColor:
                                                      Color(0xff1ca6b0)),
                                              value: deck.isInfinite,
                                              onChanged: (value) {
                                                deck.changeInfiniteMode();
                                                Hive.box('AppData').put(
                                                    kDeckIsInfiniteKey, value);
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                              ),
                              Visibility(
                                visible: deck.hasBegun,
                                child: SizedBox(width: MediaQuery.of(context).size.height *
                                    0.4 *
                                    0.69,
                                  child: Neumorphic(
                                    padding: EdgeInsets.all(5),
                                    boxShape: NeumorphicBoxShape.roundRect(
                                        BorderRadius.circular(10)),
                                    child: Neumorphic(
                                      style: NeumorphicStyle(
                                          color: kMainColor, depth: -5),
                                      padding: EdgeInsets.all(10),
                                      boxShape: NeumorphicBoxShape.roundRect(
                                          BorderRadius.circular(10)),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Column(
                                            children: <Widget>[
                                              Text(
                                                "Reps",
                                                style: TextStyle(
                                                    color: kDarkerAccentColor),
                                              ),
                                              Text(
                                                "${deck.displayedCard.reps.toString().padLeft(2, '0')}",
                                                style: TextStyle(
                                                    color: kNumberColor,
                                                    fontFamily: "PocketCal",
                                                    fontSize: 50),
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Column(
                                            children: <Widget>[
                                              Text(
                                                "Cards Left",
                                                style: TextStyle(
                                                    color: kDarkerAccentColor),
                                              ),
                                              Text(
                                                "${deck.deck.length.toString().padLeft(2, '0')}",
                                                style: TextStyle(
                                                    color: kNumberColor,
                                                    fontFamily: "PocketCal",
                                                    fontSize: 50),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    style: NeumorphicStyle(
                                        depth: 5, color: kMainColor),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Spacer(flex: 6),
                        ],
                      )),
          ),
          onWillPop: () {
            if (!deck.isInfinite) {
              if (deck.hasBegun) {
                deck.timer.cancel();
              }
            }
            return Future(() => true);
          },
        );
      },
    );
  }
}
