import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flame/spritesheet.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../logic/global.dart';

class BackgroundOne extends StatelessWidget {
  final String nameChar;
  final String name;
  const BackgroundOne({this.nameChar, this.name});

  int codeReturn(String nameChar) {
    if (nameChar == "pixel_background1") {
      return 1;
    } else if (nameChar == "pixel_background2") {
      return 2;
    } else {
      return 3;
    }
  }

  @override
  Widget build(BuildContext context) {
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
                border: Border.all(color: Colors.white, width: 1),
                color: Colors.white,
              ),
              margin: EdgeInsets.fromLTRB(5, 80, 5, 5),
              padding: EdgeInsets.all(10),
              child: SizedBox(
                width: 270,
                height: 400,
                child: Image.asset(
                  "assets/images/" + nameChar + ".jpg",
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Text(
              name,
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            // 아래 메뉴
            ClipRRect(
                child: Container(
                    margin: EdgeInsets.fromLTRB(30, 20, 30, 40),
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
                              ChooseBackground(codeReturn(nameChar), context);
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

Future<void> ChooseBackground(int nowBackground, BuildContext context) async {
  SharedPreferences sp = await SharedPreferences.getInstance();

  String key = "background";
  sp.setInt(key, nowBackground);
  debugPrint("Write SP, Now Character : $nowBackground");

  String character_value;
  await firestore
      .collection(userid)
      .doc('Character+Background')
      .get()
      .then((DocumentSnapshot documentSnapshot) {
    if (documentSnapshot.exists) {
      character_value = documentSnapshot.get('character');
    } else {
      character_value = "";
    }
  });

  firestore
      .collection(userid)
      .doc("Character+Background")
      .set({'character': character_value, 'background': nowBackground});

  int background_int;

  await firestore
      .collection(userid)
      .doc('Character+Background')
      .get()
      .then((DocumentSnapshot documentSnapshot) {
    if (documentSnapshot.exists) {
      background_int = documentSnapshot.get('background');
    } else {
      background_int = 1;
    }
  });

  gamecards[0].background = background_int;

  Navigator.of(context).pop();
}
