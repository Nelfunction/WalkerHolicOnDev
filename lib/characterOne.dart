import 'dart:ui';

import 'package:flutter/material.dart';

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
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white, width: 4),
                color: Color.fromARGB(100, 255, 255, 255),
              ),
              margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
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
            ClipRRect(
                child: Container(
                    margin: EdgeInsets.fromLTRB(30, 60, 30, 40),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24.0),
                      color: const Color(0x7fffffff),
                    ),
                    child: Column(
                      children: [
                        FlatButton(
                          child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 5),
                              width: 200,
                              height: 50,
                              child: Row(children: [
                                Text("선택",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 22.0,
                                    ))
                              ])),
                        ),
                        Divider(height: 1, thickness: 1),
                        FlatButton(
                          child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 5),
                              width: 200,
                              height: 50,
                              child: Row(children: [
                                Text("선택",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 22.0,
                                    ))
                              ])),
                        ),
                        Divider(height: 1, thickness: 1),
                        FlatButton(
                          child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 5),
                              width: 200,
                              height: 50,
                              child: Row(children: [
                                Text("나가기",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.black54,
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
