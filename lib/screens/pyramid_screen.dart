import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:hive/hive.dart';
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
              color: Color(0xFFe0e5ec),
              child: Scaffold(
                backgroundColor: Color(0xFFe0e5ec),
                appBar: AppBar(
                  textTheme: TextTheme(
                      headline6:
                          TextStyle(color: Colors.blueGrey, fontSize: 20)),
                  centerTitle: true,
                  backgroundColor: Color(0xFFe0e5ec),
                  elevation: 0,
                  title: Text("Pyramid & Reverse Pyramid"),
                ),
                body: pyramid.isDone
                    ? Container(
                        child: Center(
                          child: Text("Well Done!"),
                        ),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            height: 300,
                            width: 350,
                            child: NeumorphicButton(
                              isEnabled:
                                  (!pyramid.hasBegun || !pyramid.isResting),
                              onPressed: () {
                                if (!pyramid.hasBegun) {
                                  pyramid.start();
                                } else if (!pyramid.isResting) {
                                  pyramid.next();
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
                                      : NeumorphicShape.convex,
                                  intensity: 1,
                                  lightSource: LightSource.topLeft,
                                  border: NeumorphicBorder(
                                      color: Colors.white, width: 3.5),
                                  depth: pyramid.isResting ? -10 : 10,
                                  color: Color(0xFFe0e5ec)),
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
                                      ),
                              ),
                            ),
                          ),
                          Neumorphic(
                            boxShape: NeumorphicBoxShape.roundRect(
                                BorderRadius.circular(5)),
                            margin: EdgeInsets.all(10),
                            padding: EdgeInsets.all(5),
                            child: Text("Configuration"),
                            style: NeumorphicStyle(
                                depth: -10,
                                color: Color(0xFFe0e5ec),
                                intensity: 1),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Neumorphic(
                                boxShape: NeumorphicBoxShape.roundRect(
                                    BorderRadius.circular(10)),
                                padding: EdgeInsets.all(15),
                                style: NeumorphicStyle(
                                    intensity: 0.8,
                                    border: NeumorphicBorder(
                                        color: Colors.white, width: 2.5),
                                    color: Color(0xFFe0e5ec),
                                    depth: -30),
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
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20)),
                                              content: Neumorphic(
                                                boxShape: NeumorphicBoxShape
                                                    .roundRect(
                                                        BorderRadius.circular(
                                                            20)),
                                                child: Form(
                                                  key: _formKey0,
                                                  child: TextFormField(
                                                    controller:
                                                        TextEditingController()
                                                          ..text =
                                                              "${pyramid.height}",
                                                    validator: (value) {
                                                      if (value.length == 0) {
                                                        return 'Enter Some Number';
                                                      } else if (!_int
                                                          .hasMatch(value)) {
                                                        return 'Invalid Input';
                                                      } else if (value.length >
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
                                                        TextInputType.number,
                                                    textAlign: TextAlign.left,
                                                    decoration: InputDecoration(
                                                        border:
                                                            InputBorder.none,
                                                        hintText:
                                                            "Enter Height of Pyramid",
                                                        contentPadding:
                                                            EdgeInsets.all(10)),
                                                  ),
                                                ),
                                                style: NeumorphicStyle(
                                                    color: Color(0xFFe0e5ec),
                                                    depth: -10,
                                                    intensity: 1),
                                              ),
                                              backgroundColor:
                                                  Color(0xFFe0e5ec),
                                              actions: <Widget>[
                                                NeumorphicButton(
                                                    style: NeumorphicStyle(
                                                        color:
                                                            Color(0xFFe0e5ec)),
                                                    onPressed: () async {
                                                      if (text == null) {
                                                        Navigator.of(context)
                                                            .pop();
                                                      } else if (_formKey0
                                                          .currentState
                                                          .validate()) {
                                                        pyramid.setHeight(
                                                            int.parse(text));
                                                        pyramid.initialize();
                                                        await Hive.box(
                                                                "AppData")
                                                            .put(
                                                                kPyramidHeightKey,
                                                                int.parse(
                                                                    text));
                                                        Navigator.of(context)
                                                            .pop();
                                                      }
                                                    },
                                                    child: Text("OK")),
                                                NeumorphicButton(
                                                    style: NeumorphicStyle(
                                                        color:
                                                            Color(0xFFe0e5ec)),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: Text("Cancel"))
                                              ],
                                            ));
                                      },
                                      boxShape: NeumorphicBoxShape.roundRect(
                                          BorderRadius.circular(3)),
                                      margin:
                                          EdgeInsets.symmetric(vertical: 10),
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 30),
                                      style: NeumorphicStyle(
                                          color: Color(0xFFe0e5ec)),
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
                              Neumorphic(
                                boxShape: NeumorphicBoxShape.roundRect(
                                    BorderRadius.circular(10)),
                                padding: EdgeInsets.all(15),
                                style: NeumorphicStyle(
                                    intensity: 0.8,
                                    border: NeumorphicBorder(
                                        color: Colors.white, width: 2.5),
                                    color: Color(0xFFe0e5ec),
                                    depth: -30),
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
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20)),
                                              content: Neumorphic(
                                                boxShape: NeumorphicBoxShape
                                                    .roundRect(
                                                        BorderRadius.circular(
                                                            20)),
                                                child: Form(
                                                  key: _formKey1,
                                                  child: TextFormField(
                                                    controller:
                                                        TextEditingController()
                                                          ..text =
                                                              "${pyramid.restWeight}",
                                                    validator: (value) {
                                                      if (value.length == 0) {
                                                        return 'Enter Some Number';
                                                      } else if (!_int
                                                          .hasMatch(value)) {
                                                        return 'Invalid Input';
                                                      } else if (value.length >
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
                                                        TextInputType.number,
                                                    textAlign: TextAlign.left,
                                                    decoration: InputDecoration(
                                                        border:
                                                            InputBorder.none,
                                                        hintText:
                                                            "Enter Rest Second per Rep",
                                                        contentPadding:
                                                            EdgeInsets.all(10)),
                                                  ),
                                                ),
                                                style: NeumorphicStyle(
                                                    color: Color(0xFFe0e5ec),
                                                    depth: -10,
                                                    intensity: 1),
                                              ),
                                              backgroundColor:
                                                  Color(0xFFe0e5ec),
                                              actions: <Widget>[
                                                NeumorphicButton(
                                                    style: NeumorphicStyle(
                                                        color:
                                                            Color(0xFFe0e5ec)),
                                                    onPressed: () async {
                                                      if (text == null) {
                                                        Navigator.of(context)
                                                            .pop();
                                                      } else if (_formKey1
                                                          .currentState
                                                          .validate()) {
                                                        pyramid.setRestWeight(
                                                            int.parse(text));
                                                        await Hive.box(
                                                                "AppData")
                                                            .put(
                                                                kPyramidRestWeightKey,
                                                                int.parse(
                                                                    text));
                                                        Navigator.of(context)
                                                            .pop();
                                                      }
                                                    },
                                                    child: Text("OK")),
                                                NeumorphicButton(
                                                    style: NeumorphicStyle(
                                                        color:
                                                            Color(0xFFe0e5ec)),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: Text("Cancel"))
                                              ],
                                            ));
                                      },
                                      boxShape: NeumorphicBoxShape.roundRect(
                                          BorderRadius.circular(3)),
                                      margin:
                                          EdgeInsets.symmetric(vertical: 10),
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 30),
                                      style: NeumorphicStyle(
                                          color: Color(0xFFe0e5ec)),
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
