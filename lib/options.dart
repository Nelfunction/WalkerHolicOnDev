import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:walkerholic/bloc/provider.dart';
import 'package:walkerholic/friend_request_list.dart';
import 'package:walkerholic/logic/format.dart';
import 'package:walkerholic/randomBox.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import 'friend.dart';
import 'attendance.dart';

import 'logic/login.dart';
import 'logic/global.dart';

class MyOption extends StatefulWidget {
  @override
  _MyOptionState createState() => _MyOptionState();
}

class _MyOptionState extends State<MyOption> {
  Widget colorPicker(Property provider) {
    return ScrollConfiguration(
      behavior: ScrollBehavior()
        ..buildViewportChrome(context, null, AxisDirection.down),
      child: CupertinoPicker(
        scrollController:
            FixedExtentScrollController(initialItem: (provider.presetNum ?? 0)),
        backgroundColor: Colors.white,
        onSelectedItemChanged: (value) {
          provider.setPreset(value);
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

  Widget customPicker(Property provider) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter stateSetter) {
      return ListView(
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          ListTile(
              title: Text('Color 1'),
              trailing: RaisedButton(
                  color: provider.colortheme.colors[0],
                  onPressed: () {
                    stateSetter(() => showRGB(provider, 0));
                  })),
          ListTile(
              title: Text('Color 2'),
              trailing: RaisedButton(
                  color: provider.colortheme.colors[1],
                  onPressed: () {
                    stateSetter(() => showRGB(provider, 1));
                  })),
        ],
      );
    });
  }

  Widget visualStatus(Property provider) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter stateSetter) {
      return ListView(
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          ListTile(
            title: Text('Daily'),
            trailing: CupertinoSwitch(
              value: provider.visualize[0],
              onChanged: (bool value) {
                stateSetter(() => provider.setVisualize(0));
              },
            ),
          ),
          ListTile(
            title: Text('Weekly'),
            trailing: CupertinoSwitch(
              value: provider.visualize[1],
              onChanged: (bool value) {
                stateSetter(() => provider.setVisualize(1));
              },
            ),
          ),
          ListTile(
            title: Text('Monthly'),
            trailing: CupertinoSwitch(
              value: provider.visualize[2],
              onChanged: (bool value) {
                stateSetter(() => provider.setVisualize(2));
              },
            ),
          ),
          ListTile(
            title: Text('Pedestrian Status'),
            trailing: CupertinoSwitch(
              value: provider.visualize[3],
              onChanged: (bool value) {
                stateSetter(() => provider.setVisualize(3));
              },
            ),
          ),
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

  cupertinoBottom(Property provider) {
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
                  content: colorPicker(provider),
                );
              },
            ),
            CupertinoActionSheetAction(
              child: const Text('Customize'),
              onPressed: () {
                Navigator.pop(context, 'Two');
                bottomContent(
                  title: 'Customize',
                  content: customPicker(provider),
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

  showCuDialog() {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return Friend();
      },
    );
  }

  showRGB(Property provider, int n) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          titlePadding: const EdgeInsets.all(0.0),
          contentPadding: const EdgeInsets.all(0.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
          content: SingleChildScrollView(
            child: SlidePicker(
              pickerColor: provider.colortheme.colors[n],
              onColorChanged: (color) {
                provider.setColor(color, n);
              },
              paletteType: PaletteType.rgb,
              enableAlpha: false,
              displayThumbColor: true,
              showLabel: false,
              showIndicator: true,
              indicatorAlignmentBegin: Alignment(-1, 0),
              indicatorAlignmentEnd: Alignment(1, 0),
              indicatorBorderRadius: const BorderRadius.vertical(
                top: const Radius.circular(25.0),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<Property>(context);

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
                          content: colorPicker(provider),
                        );
                      },
                      context: context,
                      text: 'BackColor Theme'),
                  Divider(height: 1, thickness: 1),
                  flatbutton(
                      onPressed: () {
                        cupertinoBottom(provider);
                      },
                      context: context,
                      text: 'Background Option'),
                  Divider(height: 1, thickness: 1),
                  flatbutton(
                    onPressed: () {
                      bottomContent(
                        title: 'Visualize',
                        size: 250,
                        content: visualStatus(provider),
                      );
                    },
                    context: context,
                    text: 'Visualize',
                  ),
                  Divider(height: 1, thickness: 1),
                  flatbutton(
                    onPressed: () {
                      showCuDialog();
                    },
                    context: context,
                    text: 'Add Friend',
                  ),
                  Divider(height: 1, thickness: 1),
                  flatbutton(
                    onPressed: () {
                      bottomContent(
                        title: 'Friend Requests',
                        size: 250,
                        content: Friend_request_list(),
                      );
                    },
                    context: context,
                    text: 'Friend Requests',
                  ),
                  Divider(height: 1, thickness: 1),
                  flatbutton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AttendancePage()),
                      );
                    },
                    context: context,
                    text: 'Attendance',
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
                      if (randomBoxNumber > 0) {
                        Navigator.of(context)
                            .push(CustomPageRoute(RandomBox()));
                      } else {
                        Scaffold.of(context).showSnackBar(SnackBar(
                          content: SizedBox(
                            height: 30,
                            child: Center(
                              child: Text(
                                "Not Enough RandomBox! :(",
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                          backgroundColor: Colors.black.withOpacity(0.5),
                        ));
                      }
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
