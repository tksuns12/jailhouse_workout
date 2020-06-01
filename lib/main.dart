import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:jailhouseworkout/prefs.dart';
import 'package:jailhouseworkout/providers/deck_of_death_provider.dart';
import 'package:jailhouseworkout/providers/juarez_provider.dart';
import 'package:jailhouseworkout/providers/pyramid.provider.dart';
import 'package:jailhouseworkout/screens/deck_of_death_page.dart';
import 'package:jailhouseworkout/screens/juarez_page.dart';
import 'package:jailhouseworkout/screens/pyramid_page.dart';
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
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black,
      child: SafeArea(
        child: PageView(
          children: <Widget>[
            JuarezPage(),
            PyramidPage(),
            DeckOfDeathPage(),
          ],
        ),
      ),
    );
  }
}
