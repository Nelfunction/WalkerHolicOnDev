import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home.dart';
import 'characterPage.dart';
import 'pedometer.dart';
import 'options.dart';

import 'ui/bottom.dart';
import 'logic/format.dart';
import 'logic/global.dart';
import 'logic/pedoForeground.dart';
import 'logic/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await signInWithGoogle();
  await initPermission();
  await getServerdata();
  await getLocaldata();
  await loadfrienddata();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Variables for background color
  @override
  void initState() {
    super.initState();
    //_initPermission();
    maybeStartFGS();
  }

  //Close stream when unused.
  @override
  void dispose() {
    super.dispose();
    myColor.close();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "WalkerHolic_Sprite",
        home: Stack(
          children: [
            //Background Color
            StreamBuilder(
              stream: myColor.stream, // Replace with Bloc result
              initialData: 0,
              builder: (context, snapshot) {
                if (prefs != null) {
                  prefs.setInt('myColor', snapshot.data);
                }
                return ColorTheme.colorPreset[snapshot.data].buildContainer();
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
