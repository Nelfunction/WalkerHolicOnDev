import 'package:flutter/material.dart';
import 'dart:async';
import 'package:pedometer/pedometer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:provider/provider.dart';
import 'bloc/provider.dart';
import 'logic/format.dart';
import 'logic/global.dart';

class MyPedo extends StatefulWidget {
  @override
  _MyPedoState createState() => _MyPedoState();
}

class _MyPedoState extends State<MyPedo> {
  String _status = 'stopped';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  void onStepCount(StepCount event) {
    print(event);
    setState(() {
      steps = event.steps;
      status.todayCount = steps - psteps;

      gamecards[0].cardSteps = status.todayCount;
      status.totalCount = totalsteps + status.todayCount - tempstep;
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
    pedestrianStatusStream
        .listen(onPedestrianStatusChanged)
        .onError(onPedestrianStatusError);

    stepCountStream.listen(onStepCount);
    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    final property = Provider.of<Property>(context);
    return MaterialApp(
      theme: ThemeData(
        textTheme: TextTheme(
          bodyText1: TextStyle(),
          bodyText2: TextStyle(),
        ).apply(bodyColor: property.textColor),
        iconTheme: IconThemeData(color: property.textColor),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          //foregroundColor: Colors.white,
          backgroundColor: Colors.white54,
          //focusColor: Colors.white,
          //hoverColor: Colors.white,
          //splashColor: Colors.white,
        ),
      ),
      home: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            SizedBox(height: 50),
            status.totalStatus(),
            Expanded(
              child: ListView(
                physics: BouncingScrollPhysics(),
                children: <Widget>[
                  if (property.visualize[0]) status.dailyStatus(),
                  if (property.visualize[1]) status.weeklyStatus(),
                  if (property.visualize[2]) status.monthlyStatus(),
                  if (property.visualize[3]) friendStatus(context),
                  if (property.visualize[4]) ...[
                    Center(
                      child: Text('Pedestrian status:',
                          style: TextStyle(fontSize: 30)),
                    ),
                    Icon(
                      _status == 'walking'
                          ? Icons.directions_walk
                          : _status == 'stopped'
                              ? Icons.accessibility_new
                              : Icons.error,
                      size: 100,
                    ),
                    Center(
                      child: Text(
                        _status,
                        style: _status == 'walking' || _status == 'stopped'
                            ? TextStyle(fontSize: 40)
                            : TextStyle(fontSize: 40),
                      ),
                    )
                  ],
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          heroTag: "btnPedo",
          onPressed: () {
            debugPrint('steps: $steps');
            debugPrint('psteps: $psteps');
            firestore
                .collection(userid)
                .doc(getdate(DateTime.now()))
                .set({'time': DateTime.now(), 'steps': steps - psteps});
            firestore
                .collection(userid)
                .doc('total_steps')
                .update({'total_steps': status.totalCount});
          },
          tooltip: 'Increment',
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
