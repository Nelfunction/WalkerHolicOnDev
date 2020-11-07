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
          itemCount: gamecards.length,
          itemBuilder: (context, index) {
            return cardview(gamecards[index]);
          },
        ),
      ),
    );
  }

  Widget cardview(Gamecard gamecard) {
    return Container(
      margin: EdgeInsets.fromLTRB(30, 60, 30, 40),
      child: InkWell(
          onTap: () {
            print("tapped!");
            Navigator.of(context).push(createRoute(FullGame(gamecard)));
          },
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: new AssetImage('assets/images/pixel_background' +
                          gamecard.character.toString() +
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
                      gamecard.name,
                      style: thumbnailStyle,
                    ),
                    Text(
                      (gamecard.cardSteps).toString() + " Steps",
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

class Gamecard {
  String name;
  int cardSteps;
  int character;
  Gamecard(String name, int steps, int character) {
    this.name = name;
    this.cardSteps = steps;
    this.character = character;
  }

  static String getdate(DateTime date) {
    var date_YMD = "${date.year}-${date.month}-${date.day}";
    return date_YMD;
  }

//cloud firestore 친구 목록에서부터 친구들의 오늘의 steps을 gamecards에 넣는 함수

  Future<int> loadAsyncData() async {
    return datastep;
  }

  static Future<void> loadfrienddata() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    int gamecardstep = 0;
    int character = 1;
    await FirebaseFirestore.instance //자신의 Gamecard 를 생성
        .collection(userid)
        .doc(getdate(DateTime.now()))
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        gamecardstep = documentSnapshot.get('steps');
      } else {
        gamecardstep = 0;
      }
    });
    await FirebaseFirestore.instance //자신의 Gamecard 를 생성
        .collection(userid)
        .doc('character')
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        character = documentSnapshot.get('character');
      } else {
        character = 1;
      }
    });

    gamecards.add(Gamecard(userid, gamecardstep, character)); //gamecards에 추가

    int friendnum = 0;

    await FirebaseFirestore.instance //친구의 숫자를 받음
        .collection(userid)
        .doc('friend_list')
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        friendnum = documentSnapshot.get('num');
      } else {
        datastep = steps;
      }
    });
    for (int i = 1; i <= friendnum; i++) //친구의 숫자만큼 gamecards에 추가
    {
      String temp = 'name' + i.toString();
      String friendname = 'temp';
      await FirebaseFirestore.instance
          .collection(userid)
          .doc('friend_list')
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          friendname = documentSnapshot.get(temp);
        } else {
          friendname = 'null';
        }
      });
      await FirebaseFirestore.instance
          .collection(friendname)
          .doc(getdate(DateTime.now()))
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          gamecardstep = documentSnapshot.get('steps');
        } else {
          gamecardstep = 99;
        }
      });
      await FirebaseFirestore.instance //자신의 Gamecard 를 생성
          .collection(friendname)
          .doc('character')
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          character = documentSnapshot.get('character');
        } else {
          character = 1;
        }
      });

      gamecards.add(Gamecard(friendname, gamecardstep, character));
    }
  }
}
