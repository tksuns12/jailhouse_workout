import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:jailhouseworkout/consts.dart';
import 'package:jailhouseworkout/prefs.dart';
import 'package:jailhouseworkout/providers/juarez_provider.dart';
import 'package:provider/provider.dart';

class JuarezScreen extends StatefulWidget {
  @override
  _JuarezScreenState createState() => _JuarezScreenState();
}

class _JuarezScreenState extends State<JuarezScreen>
    with SingleTickerProviderStateMixin {
  AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this);
  }

  @override
  void dispose() async {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final staticJuarez = Provider.of<JuarezProvider>(context, listen: false);
    return WillPopScope(
      onWillPop: () {
        if (staticJuarez.isResting) {
          staticJuarez.timer.cancel();
          controller.stop();
        }
        return (Future(() => true));
      },
      child: SafeArea(
        child: Material(
          color: kMainColor,
          child: Column(
            children: <Widget>[
              Spacer(),
              Row(
                children: <Widget>[
                  Spacer(),
                  NeumorphicButton(
                    onPressed: () {
                      if (staticJuarez.isResting) {
                        staticJuarez.timer.cancel();
                        controller.stop();
                      }
                      Navigator.of(context).pop();
                    },
                    boxShape: NeumorphicBoxShape.circle(),
                    child: Icon(Icons.arrow_back, color: kAccentColor),
                    style: NeumorphicStyle(color: kMainColor),
                  ),
                  Spacer(),
                  Text(
                    "Juarez Valley",
                    style: TextStyle(fontSize: 25, color: kAccentColor),
                  ),
                  Spacer(),
                  NeumorphicButton(
                    onPressed: () {
                      String height;
                      String rest;
                      final _formKey = GlobalKey<FormState>();
                      RegExp _isInt = RegExp(r'^(?:-?(?:0|[1-9][0-9]*))$');
                      showDialog(
                          context: context,
                          child: AlertDialog(
                            backgroundColor: kMainColor,
                            content: Form(
                              key: _formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Neumorphic(
                                    child: TextFormField(
                                      textAlign: TextAlign.center,
                                      decoration: InputDecoration(
                                          enabledBorder: InputBorder.none,
                                          border: InputBorder.none,
                                          hintText: "Enter Max Rep of Juarez",
                                          contentPadding: EdgeInsets.all(10)),
                                      keyboardType: TextInputType.number,
                                      onChanged: (value) {
                                        height = value;
                                      },
                                      controller: TextEditingController()
                                        ..text = '${staticJuarez.height}',
                                      validator: (value) {
                                        if (value.length == 0) {
                                          return 'Enter Some Number';
                                        } else if (!_isInt.hasMatch(value)) {
                                          return 'Invalid Input';
                                        } else if (value.length > 2) {
                                          return 'Number is Too Large';
                                        } else {
                                          return null;
                                        }
                                      },
                                    ),
                                    boxShape: NeumorphicBoxShape.roundRect(
                                      BorderRadius.circular(20),
                                    ),
                                    style: NeumorphicStyle(
                                        depth: 20,
                                        shape: NeumorphicShape.concave,
                                        intensity: 0.8,
                                        color: kMainColor),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Neumorphic(
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "Enter Rest Time"),
                                      textAlign: TextAlign.center,
                                      controller: TextEditingController()
                                        ..text = "${staticJuarez.rest}",
                                      validator: (value) {
                                        if (value.length == 0) {
                                          return 'Enter Some Number';
                                        } else if (!_isInt.hasMatch(value)) {
                                          return 'Invalid Input';
                                        } else if (value.length > 2) {
                                          return 'Number is Too Large';
                                        } else {
                                          return null;
                                        }
                                      },
                                      onChanged: (value) {
                                        rest = value;
                                      },
                                    ),
                                    boxShape: NeumorphicBoxShape.roundRect(
                                        BorderRadius.circular(20)),
                                    style: NeumorphicStyle(
                                        depth: 20,
                                        shape: NeumorphicShape.concave,
                                        intensity: 0.8,
                                        color: kMainColor),
                                  ),
                                ],
                              ),
                            ),
                            actions: <Widget>[
                              NeumorphicButton(
                                onPressed: () async {
                                  if (rest == null && height == null) {
                                    Navigator.of(context).pop();
                                  } else if (_formKey.currentState.validate()) {
                                    if (height != null) {
                                      staticJuarez.setHeight(int.parse(height));
                                      await Hive.box("AppData").put(
                                          kJuarezHeightKey, int.parse(height));
                                    }
                                    if (rest != null) {
                                      staticJuarez.setRest(int.parse(rest));
                                      await Hive.box("AppData")
                                          .put(kJuarezRestKey, int.parse(rest));
                                    }
                                    Navigator.of(context).pop();
                                  }
                                },
                                child: Text("OK",
                                    style: TextStyle(color: kAccentColor)),
                                style: NeumorphicStyle(color: kMainColor),
                              ),
                              NeumorphicButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: Text("CANCEL",
                                    style: TextStyle(color: kAccentColor)),
                                style: NeumorphicStyle(color: kMainColor),
                              )
                            ],
                          ));
                    },
                    boxShape: NeumorphicBoxShape.circle(),
                    child: Icon(FontAwesomeIcons.cog, color: kAccentColor),
                    style: NeumorphicStyle(color: kMainColor),
                  ),
                  Spacer(),
                ],
              ),
              Spacer(),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.width * 0.8,
                child: Stack(
                  children: [
                    Neumorphic(
                      padding: EdgeInsets.all(12),
                      boxShape: NeumorphicBoxShape.circle(),
                      style: NeumorphicStyle(
                        depth: -3,
                        intensity: 1,
                        shape: NeumorphicShape.concave,
                      ),
                      child: Neumorphic(
                        padding: EdgeInsets.all(40),
                        boxShape: NeumorphicBoxShape.circle(),
                        style: NeumorphicStyle(
                            depth: 3,
                            shape: NeumorphicShape.flat,
                            intensity: 0.7,
                            color: kMainColor),
                        child: Neumorphic(
                          padding: EdgeInsets.all(6),
                          boxShape: NeumorphicBoxShape.circle(),
                          style: NeumorphicStyle(depth: -2),
                          child: Consumer(
                            builder: (BuildContext context,
                                JuarezProvider juarez, Widget child) {
                              return Neumorphic(
                                boxShape: NeumorphicBoxShape.circle(),
                                style: NeumorphicStyle(
                                    depth: 7, color: kMainColor),
                                child: Center(
                                    child: juarez.hasBegun
                                        ? juarez.isResting
                                            ? Text(
                                                "${juarez.displayedRestingTime}")
                                            : Text(
                                                "REPS\n ${juarez.displayedReps}")
                                        : Text(
                                            "START",
                                          )),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    CustomPaint(
                      size: Size.fromHeight(
                          MediaQuery.of(context).size.width * 0.8),
                      foregroundPainter:
                          CircularIndicatorPainter(controller, staticJuarez),
                    )
                  ],
                ),
              ),
              Spacer(flex: 2),
              Consumer(
                builder: (BuildContext context, JuarezProvider juarez,
                    Widget child) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Spacer(
                        flex: 1,
                      ),
                      NeumorphicButton(
                        onPressed: () {},
                        boxShape: NeumorphicBoxShape.circle(),
                        child: Icon(FontAwesomeIcons.redo, color: kAccentColor),
                        style: NeumorphicStyle(color: kMainColor),
                      ),
                      Spacer(
                        flex: 2,
                      ),
                      Visibility(
                        maintainState: true,
                        maintainAnimation: true,
                        maintainSize: true,
                        visible: !juarez.hasBegun || juarez.isResting,
                        child: NeumorphicButton(padding: EdgeInsets.all(30),
                          onPressed: () {
                            if (!staticJuarez.hasBegun) {
                              staticJuarez.start();
                            } else if (staticJuarez.isResting &&
                                !staticJuarez.paused) {
                              staticJuarez.onClickPause();
                              controller.stop();
                            } else if (staticJuarez.isResting &&
                                staticJuarez.paused) {
                              staticJuarez.onClickResume();
                              controller.forward(from: controller.value);
                            }
                          },
                          boxShape: NeumorphicBoxShape.circle(),
                          child: Icon(
                              !juarez.isResting || juarez.paused
                                  ? FontAwesomeIcons.play
                                  : FontAwesomeIcons.pause,
                              color: kAccentColor, size: 40,),
                          style: NeumorphicStyle(color: kMainColor),
                        ),
                      ),
                      Spacer(
                        flex: 2,
                      ),
                      Visibility(maintainAnimation: true,
                      maintainSize: true,
                      maintainState: true,
                      visible: juarez.hasBegun,
                        child: NeumorphicButton(
                          onPressed: () {
                            if (!staticJuarez.isResting &&
                                staticJuarez.hasBegun) {
                              staticJuarez.onClickRepFinished();
                              controller
                                ..duration =
                                    Duration(seconds: staticJuarez.rest + 1);
                              controller.forward(from: 0);
                            }
                          },
                          boxShape: NeumorphicBoxShape.circle(),
                          child: Icon(FontAwesomeIcons.stepForward,
                              color: kAccentColor),
                          style: NeumorphicStyle(color: kMainColor),
                        ),
                      ),
                      Spacer(
                        flex: 1,
                      ),
                    ],
                  );
                },
              ),
              Spacer(
                flex: 5,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CircularIndicatorPainter extends CustomPainter {
  final Animation<double> animation;
  final JuarezProvider staticJuarez;

  CircularIndicatorPainter(this.animation, this.staticJuarez)
      : super(repaint: animation);
  @override
  void paint(Canvas canvas, Size size) {
    final myPaint = Paint()
      ..color = Colors.greenAccent
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    double radius = (size.width / 2 - myPaint.strokeWidth / 2) - 3;
    Offset center = Offset(size.width / 2, size.height / 2);
    double arcAngle =
        staticJuarez.isResting ? (1.0 - animation.value) * 2 * pi : 2 * pi;

    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -pi / 2,
        arcAngle, false, myPaint);
  }

  @override
  bool shouldRepaint(CircularIndicatorPainter old) {
    return old.animation.value != animation.value;
  }
}
