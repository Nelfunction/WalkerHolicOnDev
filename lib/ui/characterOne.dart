import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flame/spritesheet.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../logic/global.dart';

class CharacterOne extends StatelessWidget {
  final String nameChar;
  const CharacterOne({this.nameChar = ""});

  @override
  Widget build(BuildContext context) {
    String nameText;
    if (nameChar == "Q") {
      nameText = "???";
    } else {
      nameText = nameChar + ' Cat';
    }

    return Scaffold(
      backgroundColor: Colors.black.withOpacity(.85),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white, width: 4),
                color: Colors.white,
              ),
              margin: EdgeInsets.fromLTRB(5, 150, 5, 5),
              padding: EdgeInsets.all(10),
              child: SizedBox(
                width: 200,
                height: 200,
                child: Image.asset(
                  "assets/images/kittenIcon" + nameChar + ".png",
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Text(
              nameText,
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            // 아래 메뉴
            ClipRRect(
                child: Container(
                    margin: EdgeInsets.fromLTRB(30, 60, 30, 40),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24.0),
                        color: Colors.black,
                        border: Border.all(color: Colors.white, width: 4)),
                    child: Column(
                      children: [
                        Container(
                          child: FlatButton(
                            onPressed: () {
                              // 선택
                              ChooseChareter(nameChar, context);
                            },
                            child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 5),
                                width: 200,
                                height: 50,
                                alignment: Alignment.center,
                                child: Row(children: [
                                  Text("Select",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 22.0,
                                      ))
                                ])),
                          ),
                        ),
                        Divider(
                          height: 1,
                          thickness: 1,
                          color: Colors.white,
                        ),
                        FlatButton(
                          onPressed: () {
                            // 나가기
                            Navigator.of(context).pop();
                          },
                          child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 5),
                              width: 200,
                              height: 50,
                              alignment: Alignment.center,
                              child: Row(children: [
                                Text("Quit",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 22.0,
                                    ))
                              ])),
                        ),
                      ],
                    )))
          ],
        ),
      ),
    );
  }
}

Future<void> ChooseChareter(String nowCharacter, BuildContext context) async {
  SharedPreferences sp = await SharedPreferences.getInstance();

  String key = "NowCharacter";
  sp.setString(key, nowCharacter);
  debugPrint("Write SP, Now Character : $nowCharacter");

  int background_value;
  await firestore
      .collection(userid)
      .doc('Character+Background')
      .get()
      .then((DocumentSnapshot documentSnapshot) {
    if (documentSnapshot.exists) {
      background_value = documentSnapshot.get('background');
    } else {
      background_value = 2;
    }
  });

  firestore.collection(userid).doc("Character+Background").set({
    'character': "kitten" + nowCharacter + ".png",
    'background': background_value
  });

  String myCharacter_str;
  SpriteSheet myCharacter;
  var myAnimation;

  await firestore
      .collection(userid)
      .doc('Character+Background')
      .get()
      .then((DocumentSnapshot documentSnapshot) {
    if (documentSnapshot.exists) {
      myCharacter_str = documentSnapshot.get('character');
      myCharacter = SpriteSheet(
        imageName: myCharacter_str,
        textureWidth: 160,
        textureHeight: 160,
        columns: 4,
        rows: 1,
      );
      myAnimation = myCharacter.createAnimation(0, stepTime: 0.1);
    } else {}
  });

  gamecards[0].myCharacter = myAnimation;

  Navigator.of(context).pop();
}
