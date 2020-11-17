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

  debugPrint('=========================== A ===========================');

  await Firebase.initializeApp();
  await initPermission();
  await signInWithGoogle();
  await getServerdata();
  await getLocaldata();
  await senddata();
  await loadmydata();
  await loadfrienddata();
  await loadfriend_request_list();
  debugPrint(
      '=========================== ${gamecards.length} ===========================');
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
        theme: ThemeData(fontFamily: 'IBM'),
        home: Stack(
          children: [
            //Background Color
            StreamBuilder(
              stream: myColor.stream, // Replace with Bloc result
              initialData: ColorTheme.colorPreset[0],
              builder: (context, snapshot) {
                return snapshot.data.buildContainer();
              },
            ),
            DefaultTabController(
              length: 4,
              child: Scaffold(
                resizeToAvoidBottomPadding: false,
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
                  ],
                ),
                bottomNavigationBar: Bottom(),
              ),
            )
          ],
        ));
  }
}
