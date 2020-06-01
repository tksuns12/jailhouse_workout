import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:jailhouseworkout/prefs.dart';
import 'package:jailhouseworkout/providers/pyramid.providers.dart';
import 'package:jailhouseworkout/screens/pyramid_screen.dart';
import 'package:provider/provider.dart';

class PyramidPage extends StatelessWidget {
  const PyramidPage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, PyramidProvider pyramid, child) {
      return Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Icon(FontAwesomeIcons.chevronLeft, color: Colors.grey,),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 150),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Pyramid \n Reverse Pyramid',
                        style: TextStyle(color: Colors.amberAccent, fontSize: 30),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                Text('Height of Pyramid',
                    style: TextStyle(color: Colors.white, fontSize: 20)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('${pyramid.height}',
                        style: TextStyle(color: Colors.white, fontSize: 17)),
                    IconButton(
                        icon: Icon(
                          FontAwesomeIcons.cog,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          return showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('Set Height'),
                                  content: Column(
                                    children: <Widget>[
                                      TextField(
                                        decoration:
                                            InputDecoration(labelText: 'Heihgt'),
                                        controller: TextEditingController()
                                          ..text = '${pyramid.height}',
                                        keyboardType: TextInputType.number,
                                        onChanged: (input) {
                                          pyramid.setHeight(int.parse(input));
                                        },
                                      ),
                                      TextField(
                                        decoration: InputDecoration(
                                            labelText: 'Rest Time per Rep'),
                                        controller: TextEditingController()
                                          ..text = '${pyramid.restWeight}',
                                        keyboardType: TextInputType.number,
                                        onChanged: (input) {
                                          pyramid.setHeight(int.parse(input));
                                        },
                                      ),
                                    ],
                                  ),
                                  actions: <Widget>[
                                    FlatButton(
                                      onPressed: () {
                                        Hive.box('AppData')
                                          ..put(kPyramidHeightKey, pyramid.height)
                                          ..put(kPyramidRestWeightKey,
                                              pyramid.restWeight);
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Done'),
                                    ),
                                  ],
                                );
                              });
                        }),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 110),
                  child: FlatButton(
                      onPressed: () {
                        pyramid.initialize();
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => PyramidScreen()));
                      },
                      child: Container(
                          decoration: BoxDecoration(
                              color: Colors.amberAccent,
                              borderRadius: BorderRadius.circular(5)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('START!',
                                style:
                                    TextStyle(color: Colors.black, fontSize: 50)),
                          ))),
                )
              ],
            ),
            Icon(FontAwesomeIcons.chevronRight, color: Colors.grey,),
          ],
        ),
      );
    });
  }
}
