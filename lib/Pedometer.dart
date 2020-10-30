import 'package:flutter/material.dart';
import 'dart:async';
import 'package:pedometer/pedometer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Data.dart';
import 'login.dart';

class MyPedo extends StatefulWidget {
  @override
  _MyPedoState createState() => _MyPedoState();
}

class _MyPedoState extends State<MyPedo> {
  //Test variable
  final PersonalStatus ps = PersonalStatus(
    DateTime.now(),
    todayCount: 2222,
    totalCount: 24601,
    recentMonth: [222222, 272222, 75000],
    currentDate: DateTime.now(),
  );
  // Test end
  SharedPreferences sp;
  //MyPedo pedo = MyPedo();
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  //var timestamp;
  //dynamic step;

  Stream<StepCount> _stepCountStream;
  Stream<PedestrianStatus> _pedestrianStatusStream;

  String _status = 'stopped';
  int _steps = 100;
  int _psteps = 10;
  int _datastep = 50;
  int _totalsteps = 1000;

  double max = 10000;

  static String id = email;

  Future<int> loadAsyncData() async {
    await FirebaseFirestore.instance
        .collection(id)
        .doc(getdate(DateTime.now()))
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        _datastep = _steps - documentSnapshot.get('step');
      } else {
        _datastep = _steps;
      }
    });
    return _datastep;
  }

  Future<int> loadtotalstep() async {
    int result;
    await FirebaseFirestore.instance
        .collection(id)
        .doc('total_steps')
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        result = documentSnapshot.get('total_steps');
      } else {
        result = 0;
      }
    });
    return result;
  }

  Future<int> loadSPdata() async {
    SharedPreferences sp;
    sp = await SharedPreferences.getInstance();
    DateTime temp_DateTime = new DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day - 1);
    String sp_key =
        "${temp_DateTime.year}-${temp_DateTime.month}-${temp_DateTime.day}";
    int result = sp.getInt(sp_key);
    return result;
  }

  @override
  void initState() {
    super.initState();
    initPlatformState();
    /* Firebase에서 오늘 걸은 수를 반환하는 함수
    loadAsyncData().then((result) {
      // If we need to rebuild the widget with the resulting data,
      // make sure to use `setState`
      setState(() {
        _psteps = result;
      });
    });
    */
    loadSPdata().then((result) {
      // If we need to rebuild the widget with the resulting data,
      // make sure to use `setState`
      setState(() {
        _psteps = result;
        ps.todayCount = _steps - _psteps;
      });
    });
    loadtotalstep().then((result) {
      // If we need to rebuild the widget with the resulting data,
      // make sure to use `setState`
      setState(() {
        _totalsteps = result;
        ps.totalCount = _totalsteps;
      });
    });
  }

  String getdate(DateTime date) {
    var date_YMD = "${date.year}-${date.month}-${date.day}";
    return date_YMD;
  }

  void onStepCount(StepCount event) {
    print(event);
    setState(() {
      _steps = event.steps;
      ps.todayCount = _steps - _psteps;
      ps.totalCount = _totalsteps + _steps - _psteps;
    });
  }

  void onPedestrianStatusChanged(PedestrianStatus event) {
    print(event);
    setState(() {
      _status = event.status;
    });
  }

  void onPedestrianStatusError(error) {
    print('onPedestrianStatusError: $error');
    setState(() {
      _status = 'Pedestrian Status not available';
    });
    print(_status);
  }

  void initPlatformState() async {
    _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
    _pedestrianStatusStream
        .listen(onPedestrianStatusChanged)
        .onError(onPedestrianStatusError);

    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(onStepCount);

    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          accentColor: Colors.white,
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            splashColor: Colors.red.withOpacity(0.25),
          )),
      home: Scaffold(
        backgroundColor: Colors.transparent,
        body: new Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(height: 40),
            ps.totalStatus(),
            SizedBox(height: 30),
            ps.dailyStatus(),
            SizedBox(height: 10),
            ps.monthlyStatus(),
            SizedBox(height: 30),
            Center(
              child: Text(
                'Pedestrian status:',
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
            ),
            Icon(
              _status == 'walking'
                  ? Icons.directions_walk
                  : _status == 'stopped'
                      ? Icons.accessibility_new
                      : Icons.error,
              size: 80,
              color: Colors.white,
            ),
            Center(
              child: Text(
                _status,
                style: _status == 'walking' || _status == 'stopped'
                    ? TextStyle(fontSize: 20, color: Colors.white)
                    : TextStyle(fontSize: 20, color: Colors.red),
              ),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          heroTag: "btnPedo",
          onPressed: () {
            firestore
                .collection(id)
                .doc(getdate(DateTime.now()))
                .set({'time': DateTime.now(), 'step': _steps - _psteps});
            loadtotalstep().then((result) {
              // If we need to rebuild the widget with the resulting data,
              // make sure to use setState
              setState(() {
                _totalsteps = result;
              });
            });
            firestore
                .collection(id)
                .doc('total_steps')
                .set({'total_steps': _totalsteps + _steps - _psteps});
          },
          tooltip: 'Increment',
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
