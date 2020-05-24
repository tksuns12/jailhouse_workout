import 'package:flutter/material.dart';
import 'package:jailhouseworkout/providers.dart';
import 'package:provider/provider.dart';

class PyramidScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, PyramidProvider pyramid, Widget child) {
        return WillPopScope(
          onWillPop: () {
            if (pyramid.isResting) {
              pyramid.timer.cancel();
            }
            return Future(() => true);
          },
          child: Material(
            color: Colors.black,
            child: SafeArea(
              child: pyramid.isResting
                  ? Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('REST', style: TextStyle(color: Colors.amberAccent, fontSize: 60)),
                          Text('${pyramid.displayedRestingTime}',
                              style: TextStyle(color: Colors.white, fontSize: 35)),
                        ],
                      ),
                    )
                  : Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('REPS',
                              style: TextStyle(
                                  color: Colors.amberAccent, fontSize: 60)),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 50),
                            child: Text('${pyramid.displayedReps}',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 35)),
                          ),
                          FlatButton(
                              onPressed: () {
                                pyramid.next();
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.amberAccent,
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
