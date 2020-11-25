import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home.dart';
import 'characterPage.dart';
import 'pedometer.dart';
import 'options.dart';

import 'bloc/provider.dart';
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

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Property 정보
    return ChangeNotifierProvider<Property>(
      create: (_) => Property(
        true,
        0,
        [true, true, true, true],
        ColorTheme.colorPreset[0],
      ),
      child: Body(),
    );
  }
}

class Body extends StatefulWidget {
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
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
  }

  @override
  Widget build(BuildContext context) {
    final property = Provider.of<Property>(context);
    return MaterialApp(
        title: "WalkerHolic_Sprite",
        theme: ThemeData(fontFamily: 'IBM'),
        home: Stack(
          children: [
            if (property.presentUsed)
              ColorTheme.colorPreset[property.presetNum].buildContainer(),
            if (!property.presentUsed) property.colortheme.buildContainer(),
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
                    MyOption(),
                  ],
                ),
                bottomNavigationBar: Bottom(),
              ),
            )
          ],
        ));
  }
}
