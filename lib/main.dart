import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:walkerholic_sprite/login.dart';
import 'package:walkerholic_sprite/characterPage.dart';

import 'bottom.dart';
import 'home.dart';
import 'pedometer.dart';
import 'options.dart';
import 'data/data.dart';
import 'pedoForeground.dart';
import 'global.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Stopwatch stopwatch = new Stopwatch()..start();
  await Firebase.initializeApp();
  debugPrint('YYYfirebase.initialize ${stopwatch.elapsed}');
  await signInWithGoogle();
  debugPrint('YYYsign google ${stopwatch.elapsed}');
  await senddata();
  debugPrint('YYYsendatat ${stopwatch.elapsed}');
  await loadmydata();
  debugPrint('YYYloadmydata ${stopwatch.elapsed}');
  await  loadfrienddata();
  debugPrint('YYYloadfrienddata ${stopwatch.elapsed}');

  runApp(MyApp());

}

class MyApp extends StatefulWidget {
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Variables for background color
  StreamController<int> myColor = StreamController<int>();
  SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();

    // Load Color Option.
    _initPermission();
    _loadPref();
    maybeStartFGS();
  }

  //Close stream when unused.
  @override
  void dispose() {
    super.dispose();
    myColor.close();
  }

  void _initPermission() async {
    if (await Permission.activityRecognition.request().isGranted) {
      debugPrint("PERMISSION OK");
    } else {
      debugPrint("ERROR : PERMISSION");
    }
  }

  // Load Saved Preference.
  _loadPref() async {
    _prefs = await SharedPreferences.getInstance();
    myColor.add(_prefs.getInt('myColor') ?? 0);
  }

  @override
  Widget build(BuildContext context) {
    //final myOption = MyOption.of(context);
    return MaterialApp(
        title: "WalkerHolic_Sprite",
        home: Stack(
          children: [
            //Background Color
            StreamBuilder(
              stream: myColor.stream, // Replace with Bloc result
              initialData: 0,
              builder: (context, snapshot) {
                if (_prefs != null) {
                  _prefs.setInt('myColor', snapshot.data);
                }
                return ColorTheme.colorpreset[snapshot.data].buildContainer();
              },
            ),
            DefaultTabController(
              length: 4,
              child: Scaffold(
                backgroundColor: Colors.transparent,
                body: TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  children: <Widget>[
                    MyHome(),
                    CharacterPage(),
                    MyPedo(),
                    MyOption(
                      ctrl: myColor,
                    ),
                    //Container(child: Center(child: Text('Additional'),),)
                  ],
                ),
                bottomNavigationBar: Bottom(),
              ),
            )
          ],
        ));
  }
}
