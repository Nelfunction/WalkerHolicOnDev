import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:walkerholic/bloc/provider.dart';
import 'package:walkerholic/ui/friend_request_list.dart';
import 'package:walkerholic/logic/format.dart';
import 'package:walkerholic/ui/randomBox.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import 'ui/friend.dart';
import 'ui/attendance.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'logic/login.dart';
import 'logic/global.dart';

class MyOption extends StatefulWidget {
  @override
  _MyOptionState createState() => _MyOptionState();
}

class _MyOptionState extends State<MyOption> {
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
                Hive.box('Property').put('visualize', provider.visualize);
              },
            ),
          ),
          ListTile(
            title: Text('Weekly'),
            trailing: CupertinoSwitch(
              value: provider.visualize[1],
              onChanged: (bool value) {
                stateSetter(() => provider.setVisualize(1));
                Hive.box('Property').put('visualize', provider.visualize);
              },
            ),
          ),
          ListTile(
            title: Text('Monthly'),
            trailing: CupertinoSwitch(
              value: provider.visualize[2],
              onChanged: (bool value) {
                stateSetter(() => provider.setVisualize(2));
                Hive.box('Property').put('visualize', provider.visualize);
              },
            ),
          ),
          ListTile(
            title: Text('Friends'),
            trailing: CupertinoSwitch(
              value: provider.visualize[3],
              onChanged: (bool value) {
                stateSetter(() => provider.setVisualize(3));
                Hive.box('Property').put('visualize', provider.visualize);
              },
            ),
          ),
          ListTile(
            title: Text('Pedestrian Status'),
            trailing: CupertinoSwitch(
              value: provider.visualize[4],
              onChanged: (bool value) {
                stateSetter(() => provider.setVisualize(4));
                Hive.box('Property').put('visualize', provider.visualize);
              },
            ),
          ),
        ],
      );
    });
  }

  colorThemeBackground({Property provider}) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  title: Text('Background Color',
                      style: TextStyle(
                        fontSize: 20.0,
                      )),
                  trailing: FlatButton(
                      onPressed: () {
                        Hive.box('Property')
                            .put('presetNum', provider.presetNum);
                        Navigator.pop(context, 'Cancel');
                      },
                      child: Text('Close',
                          style: TextStyle(
                            fontSize: 20.0,
                          )))),
              Divider(height: 1, thickness: 1),
              Container(
                  height: 200,
                  child: ScrollConfiguration(
                    behavior: ScrollBehavior()
                      ..buildViewportChrome(context, null, AxisDirection.down),
                    child: CupertinoPicker(
                      scrollController: FixedExtentScrollController(
                          initialItem: (provider.presetNum ?? 0)),
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
                  )),
            ],
          );
        });
  }

  colorThemeText({Property provider}) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                  title: Text('Text Color', style: TextStyle(fontSize: 20.0)),
                  trailing: FlatButton(
                      onPressed: () {
                        Hive.box('Property')
                            .put('textColor', provider.textColor.value);
                        Navigator.pop(context, 'Cancel');
                      },
                      child: Text('Close',
                          style: TextStyle(
                            fontSize: 20.0,
                          )))),
              Divider(height: 1, thickness: 1),
              Container(
                  //height: 235,
                  child: StatefulBuilder(
                      builder: (BuildContext context, StateSetter stateSetter) {
                return SlidePicker(
                  pickerColor: provider.textColor,
                  onColorChanged: (color) {
                    stateSetter(() => provider.setColor(color));
                  },
                  sliderSize: Size(MediaQuery.of(context).size.width - 20, 50),
                  indicatorSize: Size(MediaQuery.of(context).size.width, 50),
                  paletteType: PaletteType.hsv,
                  enableAlpha: false,
                  displayThumbColor: true,
                  showLabel: false,
                  showIndicator: true,
                  indicatorAlignmentBegin: Alignment(-1, 0),
                  indicatorAlignmentEnd: Alignment(1, 0),
                );
              })),
            ],
          );
        });
  }

  cupertinoBottom(Property provider) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
          title: const Text('Color Theme'),
          //message: const Text('Your options are '),
          actions: <Widget>[
            CupertinoActionSheetAction(
              child: const Text('Background'),
              onPressed: () {
                Navigator.pop(context, 'One');
                colorThemeBackground(provider: provider);
              },
            ),
            CupertinoActionSheetAction(
              child: const Text('Text'),
              onPressed: () {
                Navigator.pop(context, 'Two');
                colorThemeText(provider: provider);
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

  Future<int> get_RandomBoxnNumber() async {
    int result;

    SharedPreferences sp = await SharedPreferences.getInstance();
    result = sp.getInt("randomBoxKey");

    return result;
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
                        cupertinoBottom(provider);
                      },
                      context: context,
                      text: 'Color Theme'),
                  Divider(height: 1, thickness: 1),
                  flatbutton(
                    onPressed: () {
                      bottomContent(
                        title: 'Visualize',
                        size: 300,
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
                            builder: (context) =>
                                AttendancePage(provider.presetNum)),
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
                  Container(
                    child: SizedBox(
                      height: 50,
                      child: InkWell(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "RandomBox",
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 22.0,
                                ),
                              ),
                              Text(
                                "${provider.number}",
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 22.0,
                                ),
                              )
                            ],
                          ),
                        ),
                        onTap: () {
                          if (provider.number > 0) {
                            Navigator.of(context)
                                .push(CustomPageRoute(RandomBox(provider)));
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
                      ),
                    ),
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
