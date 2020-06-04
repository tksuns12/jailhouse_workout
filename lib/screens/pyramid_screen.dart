import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:hive/hive.dart';
import 'package:jailhouseworkout/consts.dart';
import 'package:jailhouseworkout/prefs.dart';
import 'package:jailhouseworkout/providers/pyramid.provider.dart';
import 'package:provider/provider.dart';

class PyramidScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, PyramidProvider pyramid, Widget child) {
        return WillPopScope(
            child: Material(
              color: kMainColor,
              child: pyramid.isDone
                  ? Container(
                      child: Center(
                        child: Text("Well Done!"),
                      ),
                    )
                  : SafeArea(
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              NeumorphicButton(
                                  margin: EdgeInsets.all(7),
                                  boxShape: NeumorphicBoxShape.circle(),
                                  child: Icon(Icons.arrow_back),
                                  style: NeumorphicStyle(
                                      color: kMainColor, intensity: 0.9),
                                  onPressed: () {
                                    if (pyramid.isResting) {
                                      pyramid.timer.cancel();
                                    }
                                    Navigator.of(context).pop();
                                  }),
                              Text(
                                "Pyramid & Reverse Pyramid",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.blueGrey),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.07,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.05,
                                child: pyramid.isResting
                                    ? Center(
                                        child: Text(
                                            "Next Rep: ${pyramid.reps[0]}\nSets Left: ${pyramid.reps.length}"))
                                    : SizedBox(),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.41,
                                width:
                                    MediaQuery.of(context).size.height * 0.41,
                                child: NeumorphicButton(
                                  onPressed: () {
                                    if (!pyramid.hasBegun) {
                                      pyramid.start();
                                    } else if (!pyramid.isResting) {
                                      pyramid.onClickRepFinished();
                                    } else if (pyramid.isResting &&
                                        !pyramid.paused) {
                                      pyramid.onClickPause();
                                    } else if (pyramid.isResting &&
                                        pyramid.paused) {
                                      pyramid.onClickResume();
                                    }
                                  },
                                  margin: EdgeInsets.all(20),
                                  padding: EdgeInsets.all(55),
                                  boxShape: NeumorphicBoxShape.circle(),
                                  style: NeumorphicStyle(
                                      surfaceIntensity:
                                          pyramid.isResting ? 0.8 : 0.45,
                                      shape: pyramid.hasBegun
                                          ? pyramid.isResting
                                              ? NeumorphicShape.concave
                                              : NeumorphicShape.flat
                                          : NeumorphicShape.flat,
                                      intensity: 1,
                                      lightSource: LightSource.topLeft,
                                      border: NeumorphicBorder(
                                          color: Colors.white, width: 3.5),
                                      depth: pyramid.isResting ? -10 : 10,
                                      color: kMainColor),
                                  child: AnimatedSwitcher(
                                    transitionBuilder: (child, animation) {
                                      return SlideTransition(
                                        position: Tween<Offset>(
                                          begin: Offset(2, 0),
                                          end: const Offset(0, 0),
                                        ).animate(animation),
                                        child: child,
                                      );
                                    },
                                    duration: Duration(milliseconds: 500),
                                    child: pyramid.hasBegun
                                        ? pyramid.isResting
                                            ? Text(
                                                "${pyramid.displayedRestingTime}",
                                                key: ValueKey(0),
                                                style: TextStyle(fontSize: 50),
                                                textAlign: TextAlign.center,
                                              )
                                            : Text(
                                                "REPS\n${pyramid.displayedReps}",
                                                key: ValueKey(1),
                                                style: TextStyle(fontSize: 50),
                                                textAlign: TextAlign.center,
                                              )
                                        : Text(
                                            "START",
                                            style: TextStyle(fontSize: 50),
                                            key: ValueKey(2),
                                            textAlign: TextAlign.center,
                                            maxLines: 1,
                                            overflow: TextOverflow.clip,
                                          ),
                                  ),
                                ),
                              ),SizedBox(height: 20,),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.75,
                                child: Neumorphic(
                                  boxShape: NeumorphicBoxShape.roundRect(
                                      BorderRadius.circular(5)),
                                  style: NeumorphicStyle(
                                      color: kMainColor,
                                      shape: NeumorphicShape.concave,
                                      depth: 10,
                                      intensity: 0.85,
                                      surfaceIntensity: 0.4),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.all(15),
                                        child: Column(
                                          children: <Widget>[
                                            Text(
                                              "HEIGHT",
                                              style: TextStyle(fontSize: 15),
                                            ),
                                            NeumorphicButton(
                                              isEnabled: !pyramid.hasBegun,
                                              onPressed: () {
                                                final _formKey0 =
                                                    GlobalKey<FormState>();
                                                String text;
                                                RegExp _int = RegExp(
                                                    r'^(?:-?(?:0|[1-9][0-9]*))$');
                                                showDialog(
                                                    context: context,
                                                    child: AlertDialog(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20)),
                                                      content: Neumorphic(
                                                        boxShape:
                                                            NeumorphicBoxShape
                                                                .roundRect(
                                                                    BorderRadius
                                                                        .circular(
                                                                            20)),
                                                        child: Form(
                                                          key: _formKey0,
                                                          child: TextFormField(
                                                            controller:
                                                                TextEditingController()
                                                                  ..text =
                                                                      "${pyramid.height}",
                                                            validator: (value) {
                                                              if (value
                                                                      .length ==
                                                                  0) {
                                                                return 'Enter Some Number';
                                                              } else if (!_int
                                                                  .hasMatch(
                                                                      value)) {
                                                                return 'Invalid Input';
                                                              } else if (value
                                                                      .length >
                                                                  2) {
                                                                return 'Number is Too Large';
                                                              } else {
                                                                return null;
                                                              }
                                                            },
                                                            onChanged: (value) {
                                                              text = value;
                                                            },
                                                            keyboardType:
                                                                TextInputType
                                                                    .number,
                                                            textAlign:
                                                                TextAlign.left,
                                                            decoration: InputDecoration(
                                                                border:
                                                                    InputBorder
                                                                        .none,
                                                                hintText:
                                                                    "Enter Height of Pyramid",
                                                                contentPadding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            10)),
                                                          ),
                                                        ),
                                                        style: NeumorphicStyle(
                                                            color: kMainColor,
                                                            depth: -10,
                                                            intensity: 1),
                                                      ),
                                                      backgroundColor:
                                                          kMainColor,
                                                      actions: <Widget>[
                                                        NeumorphicButton(
                                                            style: NeumorphicStyle(
                                                                color: Color(
                                                                    0xFFe0e5ec)),
                                                            onPressed:
                                                                () async {
                                                              if (text ==
                                                                  null) {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              } else if (_formKey0
                                                                  .currentState
                                                                  .validate()) {
                                                                pyramid.setHeight(
                                                                    int.parse(
                                                                        text));
                                                                pyramid
                                                                    .initialize();
                                                                await Hive.box(
                                                                        "AppData")
                                                                    .put(
                                                                        kPyramidHeightKey,
                                                                        int.parse(
                                                                            text));
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              }
                                                            },
                                                            child: Text("OK")),
                                                        NeumorphicButton(
                                                            style: NeumorphicStyle(
                                                                color: Color(
                                                                    0xFFe0e5ec)),
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            child:
                                                                Text("Cancel"))
                                                      ],
                                                    ));
                                              },
                                              boxShape:
                                                  NeumorphicBoxShape.roundRect(
                                                      BorderRadius.circular(3)),
                                              margin: EdgeInsets.symmetric(
                                                  vertical: 10),
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 30),
                                              style: NeumorphicStyle(
                                                  color: kMainColor),
                                              child: Text(
                                                "${pyramid.height}",
                                                style: TextStyle(fontSize: 30),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(15),
                                        child: Column(
                                          children: <Widget>[
                                            Text(
                                              "REST per REP",
                                              style: TextStyle(fontSize: 15),
                                            ),
                                            NeumorphicButton(
                                              isEnabled: !pyramid.hasBegun,
                                              onPressed: () {
                                                final _formKey1 =
                                                    GlobalKey<FormState>();
                                                String text;
                                                RegExp _int = RegExp(
                                                    r'^(?:-?(?:0|[1-9][0-9]*))$');
                                                showDialog(
                                                    context: context,
                                                    child: AlertDialog(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20)),
                                                      content: Neumorphic(
                                                        boxShape:
                                                            NeumorphicBoxShape
                                                                .roundRect(
                                                                    BorderRadius
                                                                        .circular(
                                                                            20)),
                                                        child: Form(
                                                          key: _formKey1,
                                                          child: TextFormField(
                                                            controller:
                                                                TextEditingController()
                                                                  ..text =
                                                                      "${pyramid.restWeight}",
                                                            validator: (value) {
                                                              if (value
                                                                      .length ==
                                                                  0) {
                                                                return 'Enter Some Number';
                                                              } else if (!_int
                                                                  .hasMatch(
                                                                      value)) {
                                                                return 'Invalid Input';
                                                              } else if (value
                                                                      .length >
                                                                  2) {
                                                                return 'Number is Too Large';
                                                              } else {
                                                                return null;
                                                              }
                                                            },
                                                            onChanged: (value) {
                                                              text = value;
                                                            },
                                                            keyboardType:
                                                                TextInputType
                                                                    .number,
                                                            textAlign:
                                                                TextAlign.left,
                                                            decoration: InputDecoration(
                                                                border:
                                                                    InputBorder
                                                                        .none,
                                                                hintText:
                                                                    "Enter Rest Second per Rep",
                                                                contentPadding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            10)),
                                                          ),
                                                        ),
                                                        style: NeumorphicStyle(
                                                            color: kMainColor,
                                                            depth: -10,
                                                            intensity: 1),
                                                      ),
                                                      backgroundColor:
                                                          kMainColor,
                                                      actions: <Widget>[
                                                        NeumorphicButton(
                                                            style: NeumorphicStyle(
                                                                color: Color(
                                                                    0xFFe0e5ec)),
                                                            onPressed:
                                                                () async {
                                                              if (text ==
                                                                  null) {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              } else if (_formKey1
                                                                  .currentState
                                                                  .validate()) {
                                                                pyramid.setRestWeight(
                                                                    int.parse(
                                                                        text));
                                                                await Hive.box(
                                                                        "AppData")
                                                                    .put(
                                                                        kPyramidRestWeightKey,
                                                                        int.parse(
                                                                            text));
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              }
                                                            },
                                                            child: Text("OK")),
                                                        NeumorphicButton(
                                                            style: NeumorphicStyle(
                                                                color: Color(
                                                                    0xFFe0e5ec)),
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            child:
                                                                Text("Cancel"))
                                                      ],
                                                    ));
                                              },
                                              boxShape:
                                                  NeumorphicBoxShape.roundRect(
                                                      BorderRadius.circular(3)),
                                              margin: EdgeInsets.symmetric(
                                                  vertical: 10),
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 30),
                                              style: NeumorphicStyle(
                                                  color: kMainColor),
                                              child: Text(
                                                "${pyramid.restWeight}",
                                                style: TextStyle(fontSize: 30),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
            ),
            onWillPop: () {
              if (pyramid.isResting) {
                pyramid.timer.cancel();
              }
              return Future(() => true);
            });
      },
    );
  }
}
