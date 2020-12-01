import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

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
  Stopwatch stopwatch = new Stopwatch()..start();
  WidgetsFlutterBinding.ensureInitialized();

  // 랜덤박스 에니메이션 초기화
  randomAnimation = kittenRandomSprite.createAnimation(0, stepTime: 0.1);

  debugPrint('=========================== A ===========================');

  /// Hive init test
  await Hive.initFlutter();
  await Hive.openBox('Property');
  await Hive.openBox('BoolCharacter');

  await initstep(); //step을 최초 stream으로부터 불러옴
  await Firebase.initializeApp();
  await initPermission();
  debugPrint('=========================== B ===========================');

  await signInWithGoogle();

  await getLocaldata(); // sp에서 어제 페도미터를 가져와 pstep 저장
  await senddata();
  await loadmydata();
  await getServerdata(); //파이어베이스의 토탈스탭 불러옴
  await loadfrienddata();
  await loadfriend_request_list();
  await attendance(); //출석관련 함수-global.dart에 있음
  print('1 executed in ${stopwatch.elapsed}');
  await loadrecentweeks();
  print('2 executed in ${stopwatch.elapsed}');
  await loadrecentmonths();
  print('3 executed in ${stopwatch.elapsed}');
  debugPrint(
      '=========================== ${gamecards.length} ===========================');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Property 정보
    var property = Hive.box('Property');
    var character = Hive.box('BoolCharacter');

    character.put('bool', globalCharacterListBool);

    return ChangeNotifierProvider<Property>(
      create: (_) => Property(
        (property.get('presetNum') ?? 2),
        (property.get('visualize') ?? [true, true, true, true, true]),
        (Color(property.get('textColor') ?? 0xffffffff)),
        (property.get('number') ?? 10),
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
            ColorTheme.colorPreset[property.presetNum].buildContainer(),
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
