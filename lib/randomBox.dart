import 'dart:math';

import 'package:flame/spritesheet.dart';
import 'package:flame/widgets/animation_widget.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:walkerholic/bloc/provider.dart';

import 'logic/global.dart';

class RandomBox extends StatefulWidget {
  Property property;
  RandomBox(this.property);
  @override
  _RandomBoxState createState() => _RandomBoxState(property);
}

class _RandomBoxState extends State<RandomBox> {
  String randomName = "Now Opening...";
  int flag = 99;

  Property property;

  _RandomBoxState(this.property);

  bool onetime = true;

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
                border: Border.all(color: Colors.white, width: 4),
                color: Colors.white,
              ),
              margin: EdgeInsets.fromLTRB(5, 150, 5, 5),
              padding: EdgeInsets.all(10),
              child: SizedBox(width: 200, height: 200, child: AnimationOrNot()),
            ),
            Text(
              randomName,
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
                              if (onetime) {
                                ChangeFlag();
                                onetime = false;
                              }
                            },
                            child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 5),
                                width: 200,
                                height: 50,
                                alignment: Alignment.center,
                                child: Row(children: [
                                  Text("Choose",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20.0,
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

  Future<void> ChangeFlag() async {
    flag = Random().nextInt(globalCharacters.length);
    randomName = globalCharacters[flag] + " Cat";
    property.minusNumber();
    Hive.box('Property').put('number', property.number);

    List<dynamic> temp = globalCharacterListBool;
    temp[0][flag] = true;
    Hive.box('BoolCharacter').put('bool', temp);
    setState(() {
      debugPrint("Random Box : Now Flag is $flag");
    });
  }

  Widget AnimationOrNot() {
    if (flag == 99) {
      // animation
      return AnimationWidget(
        animation: randomAnimation,
        playing: true,
      );
    } else {
      return Image.asset(
        "assets/images/kittenIcon" + globalCharacters[flag] + ".png",
        fit: BoxFit.cover,
      );
    }
  }
}
