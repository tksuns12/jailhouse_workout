import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:jailhouseworkout/jurarez_screen.dart';
import 'package:jailhouseworkout/prefs.dart';
import 'package:jailhouseworkout/providers/deck_of_death_provider.dart';
import 'package:jailhouseworkout/providers/juarez_provider.dart';
import 'package:jailhouseworkout/providers/pyramid.provider.dart';
import 'package:jailhouseworkout/screens/deck_of_death_page.dart';
import 'package:jailhouseworkout/screens/juarez_page.dart';
import 'package:jailhouseworkout/screens/pyramid_screen.dart';
import 'package:provider/provider.dart';
import 'package:wakelock/wakelock.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Wakelock.enable();
  await Hive.initFlutter();
  var box = await Hive.openBox('AppData');
  if (box.isEmpty) {
    box
      ..put(kJuarezHeightKey, 20)
      ..put(kJuarezRestKey, 15)
      ..put(kPyramidHeightKey, 10)
      ..put(kPyramidRestWeightKey, 10)
      ..put(kDeckTimeLimitKey, 15)
      ..put(kDeckIsInfiniteKey, true);
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (BuildContext context) {
          return JuarezProvider();
        }),
        ChangeNotifierProvider(create: (context) {
          return PyramidProvider();
        }),
        ChangeNotifierProvider(create: (context) {
          return DeckOfDeathProvider();
        })
      ],
      child: MaterialApp(
        title: 'Jailhouse Workout Routines',
        home: HomePage(),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer3(
      builder: (BuildContext context, JuarezProvider juarez,
          PyramidProvider pyramid, DeckOfDeathProvider deck, Widget child) {
        return Material(
          color: Color(0xFFe0e5ec),
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                NeumorphicButton(
                  onPressed: () {
                    juarez.initialize();
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> JuarezScreen()));
                  },
                  margin: EdgeInsets.all(20),
                  child: Text(
                    "Juarez's Valley",
                    style: TextStyle(fontSize: 30),
                  ),
                  boxShape:
                      NeumorphicBoxShape.roundRect(BorderRadius.circular(15)),
                  style: NeumorphicStyle(
                    intensity: 0.8,
                      shape: NeumorphicShape.flat,
                      color: Color(0xFFe0e5ec),
                      depth: 10,
                      lightSource: LightSource.topLeft),
                ),
                NeumorphicButton(
                  onPressed: () {
                    pyramid.initialize();
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => PyramidScreen()));
                  },
                  margin: EdgeInsets.all(20),
                  child: Text(
                    "Pyramid\n&\nReverse Pyramid",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 30),
                  ),
                  boxShape:
                      NeumorphicBoxShape.roundRect(BorderRadius.circular(15)),
                  style: NeumorphicStyle(
                    intensity: 0.8,
                      shape: NeumorphicShape.flat,
                      color: Color(0xFFe0e5ec),
                      depth: 10,
                      lightSource: LightSource.topLeft),
                ),
                NeumorphicButton(
                  onPressed: () {},
                  margin: EdgeInsets.all(20),
                  child: Text(
                    "Deck of Death",
                    style: TextStyle(fontSize: 30),
                  ),
                  boxShape:
                      NeumorphicBoxShape.roundRect(BorderRadius.circular(15)),
                  style: NeumorphicStyle(
                    intensity: 0.8,
                      shape: NeumorphicShape.flat,
                      color: Color(0xFFe0e5ec),
                      depth: 10,
                      lightSource: LightSource.topLeft),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
