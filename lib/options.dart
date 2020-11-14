import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:walkerholic/logic/format.dart';

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
                  flatbutton(
                      onPressed: showPicker,
                      context: context,
                      text: 'BackColor Theme'),
                  Divider(height: 1, thickness: 1),
                  flatbutton(
                      onPressed: () {
                        accountSync();
                      },
                      context: context,
                      text: 'Google Account Sync'),
                  Divider(height: 1, thickness: 1),
                  flatbutton(
                      onPressed: () {},
                      context: context,
                      text: 'Background Option'),
                  Divider(height: 1, thickness: 1),
                  flatbutton(
                    onPressed: () {},
                    context: context,
                    text: '1',
                  ),
                  Divider(height: 1, thickness: 1),
                  flatbutton(
                    onPressed: () {},
                    context: context,
                    text: '2',
                  ),
                  Divider(height: 1, thickness: 1),
                ],
              )),
        ),
      ),
    );
  }
}
