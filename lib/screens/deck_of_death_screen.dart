import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:hive/hive.dart';
import 'package:jailhouseworkout/prefs.dart';
import 'package:jailhouseworkout/providers/deck_of_death_provider.dart';
import 'package:provider/provider.dart';

class DeckOfDeathScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, DeckOfDeathProvider deck, child) {
        return WillPopScope(
          child: Material(
            color: Color(0xffe0e5ec),
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
                                  child: Icon(Icons.arrow_back),
                                  style: NeumorphicStyle(
                                      color: Color(0xffe0e5ec), intensity: 0.9),
                                  onPressed: () => Navigator.of(context).pop()),
                              Text(
                                "Deck of Death",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.blueGrey),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.09,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(
                                height: 80,
                                width: 200,
                                child: deck.hasBegun
                                    ? deck.isInfinite
                                        ? Center(
                                            child: Text(
                                            "No Limit Mode",
                                            style: TextStyle(fontSize: 20),
                                          ))
                                        : Text(
                                            "${deck.displayedMin.toString().padLeft(2, '0')}:${deck.displayedSec.toString().padLeft(2, '0')}",
                                            style: TextStyle(fontSize: 40),
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
                                                      Colors.blueGrey),
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
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.5,
                                width: MediaQuery.of(context).size.height *
                                    0.5 *
                                    0.69,
                                child: NeumorphicButton(
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
                                            style: TextStyle(fontSize: 40),
                                            key: ValueKey(2),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                  style: NeumorphicStyle(
                                      intensity: 0.8,
                                      color: Color(0xffe0e5ec),
                                      depth: 10),
                                ),
                              ),
                              SizedBox(
                                height: 30,
                                width: double.infinity,
                              ),
                              deck.hasBegun
                                  ? Neumorphic(
                                      padding: EdgeInsets.all(10),
                                      boxShape: NeumorphicBoxShape.roundRect(
                                          BorderRadius.circular(10)),
                                      child: Text(
                                        'REPS: ${deck.displayedCard.reps}\n${deck.deck.length} Cards Left',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      style: NeumorphicStyle(
                                          intensity: 0.8,
                                          depth: -10,
                                          color: Color(0xffe0e5ec)),
                                    )
                                  : SizedBox(
                                      height: 10,
                                    ),
                            ],
                          ),
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
