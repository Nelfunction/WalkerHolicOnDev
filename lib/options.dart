import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:walkerholic/logic/format.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

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
                visualize.add(0);
              },
            ),
          ),
          ListTile(
            title: Text('Weekly'),
            trailing: CupertinoSwitch(
              value: options.showList[1],
              onChanged: (bool value) {
                stateSetter(() => options.showList[1] = value);
                visualize.add(1);
              },
            ),
          ),
          ListTile(
            title: Text('Monthly'),
            trailing: CupertinoSwitch(
              value: options.showList[2],
              onChanged: (bool value) {
                stateSetter(() => options.showList[2] = value);
                visualize.add(2);
              },
            ),
          ),
          ListTile(
            title: Text('Pedestrian Status'),
            trailing: CupertinoSwitch(
              value: options.showList[3],
              onChanged: (bool value) {
                stateSetter(() => options.showList[3] = value);
                visualize.add(3);
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
                showRGB();
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

  Color a = Colors.limeAccent;
  void changeColor(Color color) => setState(() => currentColor = color);

  showRGB() {
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
              pickerColor: currentColor,
              onColorChanged: changeColor,
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
                      showCuDialog();
                    },
                    context: context,
                    text: 'Add Friend',
                  ),
                  Divider(height: 1, thickness: 1),
                  flatbutton(
                    onPressed: () {},
                    context: context,
                    text: 'Friend Requests',
                  ),
                  Divider(height: 1, thickness: 1),
                  flatbutton(
                      onPressed: () {
                        accountSync();
                      },
                      context: context,
                      text: 'Google Account Sync'),
                  Divider(height: 1, thickness: 1),
                ],
              )),
        ),
      ),
    );
  }
}
