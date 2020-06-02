import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:jailhouseworkout/providers/deck_of_death_provider.dart';
import 'package:jailhouseworkout/providers/juarez_provider.dart';
import 'package:jailhouseworkout/providers/pyramid.provider.dart';
import 'package:jailhouseworkout/screens/init_screen.dart';
import 'package:provider/provider.dart';

void main() {
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
        home: InitialScreen(),
      ),
    );
  }
}