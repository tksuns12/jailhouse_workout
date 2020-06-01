import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:jailhouseworkout/prefs.dart';
import 'package:jailhouseworkout/providers/juarez_provider.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'juarez_screen.dart';

class JuarezPage extends StatelessWidget {
  const JuarezPage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<JuarezProvider>(
      builder: (BuildContext context, JuarezProvider juarez, Widget child) {
        return Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              SizedBox(width: 10,),
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
                          'Juarez\'s Valley',
                          style: TextStyle(color: Colors.red, fontSize: 45),
                        ),
                      ),
                    ),
                  ),
                  Text('Height of Valley',
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('${juarez.height}',
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
                                              InputDecoration(labelText: 'Height'),
                                          controller: TextEditingController()
                                            ..text = '${juarez.height}',
                                          keyboardType: TextInputType.number,
                                          onChanged: (input) {
                                            juarez.setHeight(int.parse(input));
                                          },
                                        ),
                                        TextField(
                                          decoration: InputDecoration(
                                              labelText: 'Rest Time'),
                                          controller: TextEditingController()
                                            ..text = '${juarez.rest}',
                                          keyboardType: TextInputType.number,
                                          onChanged: (input) {
                                            juarez.rest = int.parse(input);
                                          },
                                        )
                                      ],
                                    ),
                                    actions: <Widget>[
                                      FlatButton(
                                        onPressed: () {
                                          Hive.box('AppData')
                                            ..put(kJuarezHeightKey, juarez.height)
                                            ..put(kJuarezRestKey, juarez.rest);
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
                        onPressed: () async {
                          var result = await Permission.storage.request();
                          if(result.isGranted){
                          juarez.initialize();
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => JuarezScreen()));}
                        },
                        child: Container(
                            decoration: BoxDecoration(
                                color: Colors.red,
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
      },
    );
  }
}