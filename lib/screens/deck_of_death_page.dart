import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'deck_of_death_screen.dart';
import 'package:jailhouseworkout/providers.dart';

class DeckOfDeathPage extends StatelessWidget {
  const DeckOfDeathPage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<DeckOfDeathProvider>(
      builder: (BuildContext context, DeckOfDeathProvider death, Widget child) {
        return Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Icon(FontAwesomeIcons.chevronLeft, color: Colors.grey,),
              Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 330),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white24,
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Deck of Death',
                            style:
                                TextStyle(color: Colors.greenAccent, fontSize: 45),
                          ),
                        ),
                      ),
                    ),
                    FlatButton(
                      onPressed: () {
                        death.initialize();
                        death.start();
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => DeckOfDeathScreen()));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.greenAccent,
                            borderRadius: BorderRadius.circular(5)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'SHUFFLE!',
                            style: TextStyle(color: Colors.black, fontSize: 40),
                          ),
                        ),
                      ),
                    ),
                  ]),
                  Icon(FontAwesomeIcons.chevronRight),
            ],
          ),
        );
      },
    );
  }
}
