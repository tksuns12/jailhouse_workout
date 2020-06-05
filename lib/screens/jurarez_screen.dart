import 'dart:math';

import 'package:audioplayers/audio_cache.dart';
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
              Row(
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
                  NeumorphicButton(
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
                    child: Consumer(
                      builder: (BuildContext context, JuarezProvider juarez,
                          Widget child) {
                        return Icon(
                            !juarez.isResting || juarez.paused
                                ? FontAwesomeIcons.play
                                : FontAwesomeIcons.pause,
                            color: kAccentColor);
                      },
                    ),
                    style: NeumorphicStyle(color: kMainColor),
                  ),
                  Spacer(
                    flex: 2,
                  ),
                  NeumorphicButton(
                    onPressed: () {
                      if (!staticJuarez.isResting && staticJuarez.hasBegun) {
                        staticJuarez.onClickRepFinished();
                        controller
                          ..duration = Duration(seconds: staticJuarez.rest + 1);
                        controller.forward(from: 0);
                      }
                    },
                    boxShape: NeumorphicBoxShape.circle(),
                    child:
                        Icon(FontAwesomeIcons.stepForward, color: kAccentColor),
                    style: NeumorphicStyle(color: kMainColor),
                  ),
                  Spacer(
                    flex: 1,
                  ),
                ],
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

// class NeumorphicCircularIndicator extends AnimatedWidget {
//   final AnimationController controller;
//   final Size size;

//   NeumorphicCircularIndicator({this.size, Key key, this.controller})
//       : super(key: key, listenable: controller);

//   Animation<double> get _progress => listenable;

//   @override
//   Widget build(BuildContext context) {
//     return CustomPaint(
//       size: size,
//       foregroundPainter: CircularIndicatorPainter(_progress),
//     );
//   }
// }
