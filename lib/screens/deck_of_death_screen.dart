import 'package:flutter/material.dart';
import 'package:jailhouseworkout/providers.dart';
import 'package:provider/provider.dart';

class DeckOfDeathScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<DeckOfDeathProvider>(
      builder: (BuildContext context, DeckOfDeathProvider deck, Widget child) {
        return WillPopScope(
          onWillPop: () {
            deck.timer.cancel();
            return Future(() => true);
          },
          child: deck.isDone
              ? deck.isFailed?(Container(
                          color: Colors.black,
                          child: Center(
                              child: Text(
                            'Time is Up :(\n Try Next Time!',
                            style: TextStyle(color: Colors.red, fontSize: 70),
                          )),
                        )):(Container(
                  color: Colors.black,
                  child: Center(
                      child: Text(
                    'Well Done!',
                    style: TextStyle(color: Colors.greenAccent, fontSize: 70),
                  )),
                ))
              : Material(
                  color: Colors.black,
                  child: SafeArea(
                      child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          '${deck.displayedMin.toString().padLeft(2, '0')}:${deck.displayedSec.toString().padLeft(2, '0')}',
                          style: TextStyle(
                              fontSize: 40, color: Colors.greenAccent),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Image.asset(
                            deck.displayedCard.imagePath,
                            scale: 2.0,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Text(
                            'REPS: ${deck.displayedCard.reps}',
                            style: TextStyle(color: Colors.green, fontSize: 20),
                          ),
                        ),
                        FlatButton(
                          onPressed: () {
                            deck.next();
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.greenAccent,
                                  borderRadius: BorderRadius.circular(5)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Next Card',
                                  style: TextStyle(fontSize: 25),
                                ),
                              )),
                        )
                      ],
                    ),
                  )),
                ),
        );
      },
    );
  }
}
