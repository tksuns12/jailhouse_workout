import 'package:flutter/material.dart';
import 'package:jailhouseworkout/providers.dart';
import 'package:provider/provider.dart';

class JuarezScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, JuarezProvider juarez, Widget child) {
        return WillPopScope(
          onWillPop: () {
            if (juarez.isResting) {
              juarez.timer.cancel();
            }
            return Future(() => true);
          },
          child: Material(
            color: Colors.black,
            child: SafeArea(
              child: juarez.isResting
                  ? Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('REST',
                              style:
                                  TextStyle(color: Colors.red, fontSize: 60)),
                          Text('${juarez.displayedRestingTime}',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 35)),
                        ],
                      ),
                    )
                  : Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('REPS',
                              style:
                                  TextStyle(color: Colors.red, fontSize: 60)),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 50),
                            child: Text('${juarez.displayedReps}',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 35)),
                          ),
                          FlatButton(
                              onPressed: () {
                                juarez.next();
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(5)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('NEXT',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 50)),
                                ),
                              )),
                        ],
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }
}
