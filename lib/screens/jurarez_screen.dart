import 'dart:math';
import 'package:firebase_admob/firebase_admob.dart';
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
  JuarezProvider staticJuarez;
  static MobileAdTargetingInfo mobileAdTargetingInfo = MobileAdTargetingInfo(
      contentUrl: 'https://flutter.dev',
      testDevices: ["6EAC7A5ADE81922E8DEAAC9CD837C554"],
      keywords: ['workout'],
      childDirected: false);

  BannerAd bannerAd = BannerAd(
    adUnitId: "ca-app-pub-4385209419925513/8799793750",
    size: AdSize.smartBanner,
    targetingInfo: mobileAdTargetingInfo,
    listener: (event) => print("$event"),
  );

  @override
  void initState() {
    super.initState();
    staticJuarez = Provider.of<JuarezProvider>(context, listen: false);
    controller = AnimationController(vsync: this);
    bannerAd
      ..load()
      ..show(anchorType: AnchorType.bottom);
  }

  @override
  void dispose() async {
    super.dispose();
    controller.dispose();
    bannerAd.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                  Consumer(
                    builder: (BuildContext context, JuarezProvider juarez,
                        Widget child) {
                      return NeumorphicButton(
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
                                              helperText: "Max Rep",
                                              enabledBorder: InputBorder.none,
                                              border: InputBorder.none,
                                              hintText: "Enter Max Rep",
                                              contentPadding:
                                                  EdgeInsets.all(10)),
                                          keyboardType: TextInputType.number,
                                          onChanged: (value) {
                                            height = value;
                                          },
                                          controller: TextEditingController()
                                            ..text = '${staticJuarez.height}',
                                          validator: (value) {
                                            if (value.length == 0) {
                                              return 'Enter Some Number';
                                            } else if (!_isInt
                                                .hasMatch(value)) {
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
                                              contentPadding:
                                                  EdgeInsets.all(10),
                                              helperText: "Rest Time",
                                              border: InputBorder.none,
                                              hintText: "Enter Rest Time"),
                                          textAlign: TextAlign.center,
                                          controller: TextEditingController()
                                            ..text = "${staticJuarez.rest}",
                                          validator: (value) {
                                            if (value.length == 0) {
                                              return 'Enter Some Number';
                                            } else if (!_isInt
                                                .hasMatch(value)) {
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
                                      } else if (_formKey.currentState
                                          .validate()) {
                                        if (height != null) {
                                          staticJuarez
                                              .setHeight(int.parse(height));
                                          await Hive.box("AppData").put(
                                              kJuarezHeightKey,
                                              int.parse(height));
                                        }
                                        if (rest != null) {
                                          staticJuarez.setRest(int.parse(rest));
                                          await Hive.box("AppData").put(
                                              kJuarezRestKey, int.parse(rest));
                                        }
                                        staticJuarez.initialize();
                                        Navigator.of(context).pop();
                                      }
                                    },
                                    child: Text("OK",
                                        style: TextStyle(color: kAccentColor)),
                                    style: NeumorphicStyle(color: kMainColor),
                                  ),
                                  NeumorphicButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
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
                        isEnabled: !juarez.hasBegun,
                      );
                    },
                  ),
                  Spacer(),
                ],
              ),
              Spacer(flex: 4),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                height: MediaQuery.of(context).size.width * 0.7,
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
                          padding: EdgeInsets.all(5),
                          boxShape: NeumorphicBoxShape.circle(),
                          style: NeumorphicStyle(
                              depth: -2, color: Colors.blueGrey[200]),
                          child: Consumer(
                            builder: (BuildContext context,
                                JuarezProvider juarez, Widget child) {
                              return Neumorphic(
                                boxShape: NeumorphicBoxShape.circle(),
                                style: NeumorphicStyle(
                                    depth: 7, color: kMainColor),
                                child: Center(
                                    child: juarez.isDone
                                        ? Text("Well Done!",
                                            style: TextStyle(
                                                fontSize: 25,
                                                color: kDarkerAccentColor))
                                        : juarez.hasBegun
                                            ? juarez.isResting
                                                ? Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      Text("REST",
                                                          style: TextStyle(
                                                              fontSize: 25,
                                                              color:
                                                                  kDarkerAccentColor)),
                                                      Text(
                                                          "${juarez.displayedRestingTime.toString().padLeft(2, '0')}",
                                                          style: TextStyle(
                                                            fontFamily:
                                                                "PocketCal",
                                                            fontSize: 70,
                                                            color: kNumberColor,
                                                          )),
                                                    ],
                                                  )
                                                : Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      Text("REPS",
                                                          style: TextStyle(
                                                              fontSize: 25,
                                                              color:
                                                                  kDarkerAccentColor)),
                                                      Text(
                                                          "${juarez.displayedReps.toString().padLeft(2, '0')}",
                                                          style: TextStyle(
                                                            fontFamily:
                                                                "PocketCal",
                                                            fontSize: 70,
                                                            color: kNumberColor,
                                                          ))
                                                    ],
                                                  )
                                            : Text(
                                                "START",
                                                style: TextStyle(
                                                    fontSize: 35,
                                                    color: kDarkerAccentColor),
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
              SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: Neumorphic(
                    padding: EdgeInsets.all(2),
                    boxShape:
                        NeumorphicBoxShape.roundRect(BorderRadius.circular(10)),
                    style: NeumorphicStyle(color: kMainColor, depth: 7),
                    child: Neumorphic(
                      style: NeumorphicStyle(color: kMainColor, depth: -3),
                      boxShape: NeumorphicBoxShape.roundRect(
                          BorderRadius.circular(10)),
                      child: Consumer(builder: (BuildContext context,
                          JuarezProvider juarez, Widget child) {
                        return Visibility(
                          visible: juarez.hasBegun,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      "Next Reps",
                                      style:
                                          TextStyle(color: kDarkerAccentColor),
                                      textAlign: TextAlign.center,
                                    ),
                                    Text(
                                      "${(staticJuarez.reps.length == 0 ? 0 : staticJuarez.reps[0]).toString().padLeft(2, '0')}",
                                      style: TextStyle(
                                          fontFamily: "PocketCal",
                                          color: kNumberColor,
                                          fontSize: 50),
                                    )
                                  ]),
                              SizedBox(width: 20),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    "Sets Left",
                                    style: TextStyle(color: kDarkerAccentColor),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    "${juarez.reps.length}",
                                    style: TextStyle(
                                        fontFamily: "PocketCal",
                                        color: kNumberColor,
                                        fontSize: 50),
                                  )
                                ],
                              )
                            ],
                          ),
                        );
                      }),
                    ),
                  )),
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
                        onPressed: () {
                          if (staticJuarez.isResting) {
                            staticJuarez.timer.cancel();
                            controller.stop();
                          }
                          staticJuarez.initialize();
                        },
                        boxShape: NeumorphicBoxShape.circle(),
                        child: Icon(FontAwesomeIcons.redo, color: kAccentColor),
                        style: NeumorphicStyle(color: kMainColor),
                      ),
                      Spacer(
                        flex: 2,
                      ),
                      NeumorphicButton(
                        isEnabled: !juarez.hasBegun || juarez.isResting,
                        onPressed: () {
                          if (!staticJuarez.hasBegun) {
                            staticJuarez.start();
                          } else if (staticJuarez.isResting &&
                              !staticJuarez.paused) {
                            staticJuarez.onClickPause();
                            controller.stop();
                            controller.value = (staticJuarez.rest -
                                    staticJuarez.pausedTime -
                                    1) /
                                staticJuarez.rest;
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
                          color: kAccentColor,
                        ),
                        style: NeumorphicStyle(color: kMainColor),
                      ),
                      Spacer(
                        flex: 2,
                      ),
                      NeumorphicButton(
                        isEnabled: juarez.hasBegun,
                        onPressed: () {
                          if (!staticJuarez.isResting &&
                              staticJuarez.hasBegun) {
                            staticJuarez.onClickRepFinished();
                            if (staticJuarez.reps.length != 0) {
                              controller
                                ..duration =
                                    Duration(seconds: staticJuarez.rest + 1);
                              controller.forward(from: 0);
                            }
                          } else if (staticJuarez.isResting) {
                            staticJuarez.onClickSkip();
                            controller.stop();
                            controller.value = 0.0;
                          }
                        },
                        boxShape: NeumorphicBoxShape.circle(),
                        child: Icon(FontAwesomeIcons.stepForward,
                            color: kAccentColor),
                        style: NeumorphicStyle(color: kMainColor),
                      ),
                      Spacer(
                        flex: 1,
                      ),
                    ],
                  );
                },
              ),
              Spacer(
                flex: 10,
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
    final outterPaint = Paint()
      ..color = Color(0xff2deffc)
      ..strokeWidth = 7
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    final shinyPaint = Paint()
      ..color = Color(0xff2deffc).withOpacity(0.15)
      ..strokeWidth = 17
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    double radius = (size.width / 2 - outterPaint.strokeWidth / 2) - 3;
    Offset center = Offset(size.width / 2, size.height / 2);
    double arcAngle =
        staticJuarez.isResting ? (1.0 - animation.value) * 2 * pi : 2 * pi;

    outterPaint.shader = LinearGradient(
            end: Alignment.bottomCenter,
            begin: Alignment.topCenter,
            colors: [Color(0xff2deffc), Color(0xff1ca6b0)])
        .createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -pi / 2,
        arcAngle, false, outterPaint);
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius + 2), -pi / 2,
        arcAngle, false, shinyPaint);
  }

  @override
  bool shouldRepaint(CircularIndicatorPainter old) {
    return old.animation.value != animation.value;
  }
}
