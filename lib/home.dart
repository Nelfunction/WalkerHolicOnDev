import 'package:flutter/material.dart';
import 'game_screen.dart';
import 'global.dart';
import 'login.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:walkerholic_sprite/pedometer.dart';

class MyHome extends StatefulWidget {
  @override
  _MyHomeState createState() => _MyHomeState();
}

double catsize = 200;

class _MyHomeState extends State<MyHome> {
  TextStyle thumbnailStyle =
      new TextStyle(fontSize: 20, fontWeight: FontWeight.w600, shadows: [
    Shadow(
        // bottomLeft
        offset: Offset(-1.5, -1.5),
        color: Colors.black),
    Shadow(
        // bottomRight
        offset: Offset(1.5, -1.5),
        color: Colors.black),
    Shadow(
        // topRight
        offset: Offset(1.5, 1.5),
        color: Colors.black),
    Shadow(
        // topLeft
        offset: Offset(-1.5, 1.5),
        color: Colors.black),
  ]);

  //MyGame game = MyGame();
  TextEditingController controller = new TextEditingController();


/*
  void initState() {
    super.initState();
    loadfrienddata().then((result) {
      // If we need to rebuild the widget with the resulting data,
      // make sure to use `setState`
      setState(() {

      });
    });
  }
*/

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: Colors.black,
          accentColor: Colors.white,
          buttonColor: Colors.black),
      home: Scaffold(
        backgroundColor: Colors.transparent,
        body: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount:  gamecards.length ,
          itemBuilder: (context, index) {
            return temp(gamecards[index]);
          },
        ),
      ),
    );
  }

  Widget temp(gamecard Gamecard) {
    return Container(
      margin: EdgeInsets.fromLTRB(30, 60, 30, 40),
      child: InkWell(
          onTap: () {
            print("tapped!");
            Navigator.of(context).push(createRoute(FullGame(Gamecard)));
          },
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: new AssetImage('assets/images/pixel_background' +
                          Gamecard.character.toString() +
                          '.jpg'),
                      fit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.transparent, width: 150),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      offset: Offset(0.0, 2.0), //(x,y)
                      blurRadius: 6.0,
                    ),
                  ],
                ),
              ),
              Positioned(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      Gamecard.name,
                      style: thumbnailStyle,
                    ),
                    Text(
                      (Gamecard.steps).toString() + " Steps",
                      style: thumbnailStyle,
                    )
                  ],
                ),
                right: 20,
                bottom: 20,
              )
            ],
          )),
    );
  }
}

class gamecard {
  String name;
  int steps;
  int character;
  gamecard(String name, int steps, int character) {
    this.name = name;
    this.steps = steps;
    this.character = character;
  }
}

String getdate(DateTime date) {
  var date_YMD = "${date.year}-${date.month}-${date.day}";
  return date_YMD;
}


