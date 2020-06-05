import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jailhouseworkout/consts.dart';
import 'package:jailhouseworkout/providers/deck_of_death_provider.dart';
import 'package:jailhouseworkout/providers/juarez_provider.dart';
import 'package:jailhouseworkout/providers/pyramid.provider.dart';
import 'package:jailhouseworkout/screens/jurarez_screen.dart';
import 'package:jailhouseworkout/screens/pyramid_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'deck_of_death_screen.dart';

final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer3(
      builder: (BuildContext context, JuarezProvider juarez,
          PyramidProvider pyramid, DeckOfDeathProvider deck, Widget child) {
        return Scaffold(
          key: scaffoldKey,
          backgroundColor: kMainColor,
          drawer: Drawer(
            child: ListView(
              children: <Widget>[
                NeumorphicButton(
                  onPressed: () => showAboutDialog(context: context),
                  boxShape:
                      NeumorphicBoxShape.roundRect(BorderRadius.circular(10)),
                  margin: EdgeInsets.all(10),
                  style: NeumorphicStyle(color: Colors.white),
                  child: ListTile(
                    title: Text("About"),
                  ),
                ),
                NeumorphicButton(
                  onPressed: () {},
                  boxShape:
                      NeumorphicBoxShape.roundRect(BorderRadius.circular(10)),
                  margin: EdgeInsets.all(10),
                  style: NeumorphicStyle(color: Colors.white),
                  child: ListTile(
                    title: Text("How to Use"),
                  ),
                ),
              ],
            ),
          ),
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    NeumorphicButton(
                      onPressed: () {
                        scaffoldKey.currentState.openDrawer();
                      },
                      margin: EdgeInsets.all(5),
                      boxShape: NeumorphicBoxShape.circle(),
                      child: Icon(
                        FontAwesomeIcons.bars,
                        color: kAccentColor,
                      ),
                      style: NeumorphicStyle(color: kMainColor, intensity: 0.9),
                    )
                  ],
                ),
                Spacer(),
                NeumorphicButton(
                  onPressed: () async {
                    var result = await Permission.storage.request();
                    if (result.isGranted) {
                      juarez.initialize();
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => JuarezScreen()));
                    }
                  },
                  margin: EdgeInsets.all(20),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: Center(
                      child: Text(
                        "Juarez Valley",
                        style: TextStyle(fontSize: 30, color: kAccentColor),
                      ),
                    ),
                  ),
                  boxShape:
                      NeumorphicBoxShape.roundRect(BorderRadius.circular(15)),
                  style: NeumorphicStyle(
                      intensity: 0.8,
                      shape: NeumorphicShape.flat,
                      color: kMainColor,
                      depth: 10,
                      lightSource: LightSource.topLeft),
                ),
                NeumorphicButton(
                  onPressed: () async {
                    var result = await Permission.storage.request();
                    if (result.isGranted) {
                      pyramid.initialize();
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => PyramidScreen()));
                    }
                  },
                  margin: EdgeInsets.all(20),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: Center(
                      child: Text(
                        "Pyramid\n&\nReverse Pyramid",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 30, color: kAccentColor),
                      ),
                    ),
                  ),
                  boxShape:
                      NeumorphicBoxShape.roundRect(BorderRadius.circular(15)),
                  style: NeumorphicStyle(
                      intensity: 0.8,
                      shape: NeumorphicShape.flat,
                      color: kMainColor,
                      depth: 10,
                      lightSource: LightSource.topLeft),
                ),
                NeumorphicButton(
                  onPressed: () async {
                    var result = await Permission.storage.request();
                    if (result.isGranted) {
                      deck.initialize();
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => DeckOfDeathScreen()));
                    }
                  },
                  margin: EdgeInsets.all(20),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: Center(
                      child: Text(
                        "Deck of Death",
                        style: TextStyle(fontSize: 30, color: kAccentColor),
                      ),
                    ),
                  ),
                  boxShape:
                      NeumorphicBoxShape.roundRect(BorderRadius.circular(15)),
                  style: NeumorphicStyle(
                      intensity: 0.8,
                      shape: NeumorphicShape.flat,
                      color: kMainColor,
                      depth: 10,
                      lightSource: LightSource.topLeft),
                ),
                Spacer(),
              ],
            ),
          ),
        );
      },
    );
  }
}
