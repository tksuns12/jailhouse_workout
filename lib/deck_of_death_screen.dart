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
              child: Scaffold(
                backgroundColor: Color(0xffe0e5ec),
                appBar: AppBar(
                  textTheme: TextTheme(
                      headline6:
                          TextStyle(color: Colors.blueGrey, fontSize: 20)),
                  centerTitle: true,
                  backgroundColor: Color(0xffe0e5ec),
                  elevation: 0,
                  title: Text("Deck Of Death"),
                ),
                body: SafeArea(
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
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(
                                height: 60,
                                width: 200,
                                child: deck.hasBegun
                                    ? deck.isInfinite
                                        ? Text("No Limit Mode")
                                        : Text(
                                            "${deck.displayedMin.toString().padLeft(2, '0')}:${deck.displayedSec.toString().padLeft(2, '0')}",
                                            style: TextStyle(fontSize: 40),
                                            textAlign: TextAlign.center,
                                          )
                                    : Column(
                                        children: <Widget>[
                                          Text("No Limit Mode"),
                                          NeumorphicSwitch(
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
                                        ],
                                      ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 30, bottom: 20),
                                child: SizedBox(
                                  height: 363,
                                  width: 250,
                                  child: NeumorphicButton(
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
                                              "CLICK\nto SHUFFLE",
                                              style: TextStyle(fontSize: 40),
                                              key: ValueKey(2),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                    style: NeumorphicStyle(
                                        color: Color(0xffe0e5ec), depth: 10),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
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
                                          depth: -10, color: Color(0xffe0e5ec)),
                                    )
                                  : SizedBox(
                                      height: 30,
                                    ),
                            ],
                          )),
              )),
          onWillPop: () {
            if (!deck.isInfinite) {
              if (deck.hasBegun){
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
