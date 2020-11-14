import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:ui';
import 'package:flutter/cupertino.dart';

import 'logic/login.dart';

class MyOption extends StatefulWidget {
  final StreamController ctrl;
  MyOption({@required this.ctrl});

  @override
  _MyOptionState createState() => _MyOptionState(ctrl);
}

class _MyOptionState extends State<MyOption> {
  final StreamController ctrl;
  _MyOptionState(this.ctrl);

  showPicker() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 200,
            child: CupertinoPicker(
              //scrollController: FixedExtentScrollController(initialItem: (ctrl.stream.last ?? 0)),
              backgroundColor: Colors.white,
              onSelectedItemChanged: (value) {
                ctrl.add(value);
              },
              itemExtent: 32.0,
              children: const [
                Text('Pinkish'),
                Text('Azur'),
                Text('DayLight'),
              ],
            ),
          );
        });
  }

  accountSync() async {
    await signInWithGoogle();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 30.0, sigmaY: 30.0),
          child: Container(
              margin: EdgeInsets.fromLTRB(30, 60, 30, 40),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24.0),
                color: const Color(0x7fffffff),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      child: Text(
                        'Properties',
                        style: TextStyle(fontSize: 36, color: Colors.black87),
                      )),
                  Divider(height: 1, thickness: 1),
                  FlatButton(
                    onPressed: showPicker,
                    child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        child: Row(children: [
                          Text("BackColor Theme",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 22.0,
                              ))
                        ])),
                  ),
                  Divider(height: 1, thickness: 1),
                  FlatButton(
                    onPressed: () {
                      accountSync();
                    },
                    child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        child: Row(children: [
                          Text("Google Account Sync",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 22.0,
                              ))
                        ])),
                  ),
                  Divider(height: 1, thickness: 1),
                  FlatButton(
                    onPressed: () {},
                    child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        child: Row(children: [
                          Text("Background Option",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 22.0,
                              ))
                        ])),
                  ),
                  Divider(height: 1, thickness: 1),
                ],
              )),
        ),
      ),
    );
  }
}
