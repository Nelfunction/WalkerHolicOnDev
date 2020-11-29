import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:walkerholic/friend_request_list.dart';
import 'package:walkerholic/logic/format.dart';
import 'package:walkerholic/randomBox.dart';

import 'friend.dart';

import 'logic/login.dart';
import 'logic/global.dart';

class MyOption extends StatefulWidget {
  final StreamController ctrl;
  MyOption({@required this.ctrl});

  @override
  _MyOptionState createState() => _MyOptionState(ctrl);
}

class _MyOptionState extends State<MyOption> {
  final StreamController ctrl;
  _MyOptionState(this.ctrl);

  Widget colorPicker() {
    return ScrollConfiguration(
      behavior: ScrollBehavior()
        ..buildViewportChrome(context, null, AxisDirection.down),
      child: CupertinoPicker(
        //scrollController: FixedExtentScrollController(initialItem: (ctrl.stream.last ?? 0)),
        backgroundColor: Colors.white,
        onSelectedItemChanged: (value) {
          if (prefs != null) {
            prefs.setInt('myColor', value);
          }
          ctrl.add(ColorTheme.colorPreset[value]);
        },
        itemExtent: 32.0,
        children: const [
          Text('Pinkish'),
          Text('Azur'),
          Text('DayLight'),
          Text('Forest'),
          Text('Peach'),
        ],
      ),
    );
  }

  Widget visualStatus() {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter stateSetter) {
      return ListView(
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          ListTile(
              title: Text('Daily'),
              trailing: CupertinoSwitch(
                value: options.showList[0],
                onChanged: (bool value) {
                  stateSetter(() => options.showList[0] = value);
                },
              ),
              onTap: () {
                setState(() {
                  options.showList[0] = !options.showList[0];
                });
              }),
          ListTile(
              title: Text('Weekly'),
              trailing: CupertinoSwitch(
                value: options.showList[1],
                onChanged: (bool value) {
                  stateSetter(() => options.showList[1] = value);
                },
              ),
              onTap: () {
                setState(() {
                  options.showList[1] = !options.showList[1];
                });
              }),
          ListTile(
              title: Text('Monthly'),
              trailing: CupertinoSwitch(
                value: options.showList[2],
                onChanged: (bool value) {
                  stateSetter(() => options.showList[2] = value);
                },
              ),
              onTap: () {
                setState(() {
                  options.showList[2] = !options.showList[2];
                });
              }),
          ListTile(
              title: Text('Pedestrian Status'),
              trailing: CupertinoSwitch(
                value: options.showList[3],
                onChanged: (bool value) {
                  stateSetter(() => options.showList[3] = value);
                },
              ),
              onTap: () {
                setState(() {
                  options.showList[3] = !options.showList[3];
                });
              }),
        ],
      );
    });
  }

  bottomContent({
    String title = 'Title',
    double size = 200.0,
    Widget content,
  }) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  title: Text(title,
                      style: TextStyle(
                        fontSize: 20.0,
                      )),
                  trailing: FlatButton(
                      onPressed: () {
                        Navigator.pop(context, 'Cancel');
                      },
                      child: Text('Close',
                          style: TextStyle(
                            fontSize: 20.0,
                          )))),
              Divider(height: 1, thickness: 1),
              Container(height: size, child: content),
            ],
          );
        });
  }

  cupertinoBottom() {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
          title: const Text('Background Theme'),
          //message: const Text('Your options are '),
          actions: <Widget>[
            CupertinoActionSheetAction(
              child: const Text('Use Preset'),
              onPressed: () {
                Navigator.pop(context, 'One');
                bottomContent(
                  title: 'Choose Preset',
                  content: colorPicker(),
                );
              },
            ),
            CupertinoActionSheetAction(
              child: const Text('Customize'),
              onPressed: () {
                Navigator.pop(context, 'Two');
                bottomContent(
                  title: 'Customize',
                  content: visualStatus(),
                );
              },
            )
          ],
          cancelButton: CupertinoActionSheetAction(
            child: const Text('Cancel'),
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context, 'Cancel');
            },
          )),
    );
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
                  flatbutton(
                      onPressed: () {
                        bottomContent(
                          title: 'BackColor Theme',
                          content: colorPicker(),
                        );
                      },
                      context: context,
                      text: 'BackColor Theme'),
                  Divider(height: 1, thickness: 1),
                  flatbutton(
                      onPressed: () {
                        cupertinoBottom();
                      },
                      context: context,
                      text: 'Background Option'),
                  Divider(height: 1, thickness: 1),
                  flatbutton(
                    onPressed: () {
                      Navigator.of(context).push(CustomPageRoute(Friend()));
                    },
                    context: context,
                    text: 'add_friend',
                  ),
                  Divider(height: 1, thickness: 1),
                  flatbutton(
                    onPressed: () {
                      Navigator.of(context).push(CustomPageRoute(Friend_request_list()));
                    },
                    context: context,
                    text: 'friend_requested_list',
                  ),
                  Divider(height: 1, thickness: 1),
                  flatbutton(
                    onPressed: () {
                      bottomContent(
                        title: 'Visualize',
                        size: 250,
                        content: visualStatus(),
                      );
                    },
                    context: context,
                    text: 'Visualize',
                  ),
                  Divider(height: 1, thickness: 1),
                  flatbutton(
                      onPressed: () {
                        accountSync();
                      },
                      context: context,
                      text: 'Google Account Sync'),
                      Divider(height: 1, thickness: 1),
                  flatbutton(
                    onPressed: () {
                      Navigator.of(context).push(CustomPageRoute(RandomBox()));
                    },
                    context: context,
                    text: 'RandomBox',
                  ),
                  Divider(height: 1, thickness: 1),
                ],
              )),
        ),
      ),
    );
  }
}


class CustomPageRoute<T> extends PageRoute<T> {
  CustomPageRoute(this.child);
  @override
  // TODO: implement barrierColor
  Color get barrierColor => Colors.black.withOpacity(0.01);

  @override
  String get barrierLabel => null;

  @override
  // TODO: implement opaque
  bool get opaque => false;

  final Widget child;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => Duration(milliseconds: 500);
}