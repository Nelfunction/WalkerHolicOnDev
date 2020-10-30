import 'package:flutter/material.dart';
import 'dart:async';

import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:foreground_service/foreground_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 아마 죽었을 때, 다시 Foreground Service 살리는 놈 같음.
void maybeStartFGS() async {
  ///if the app was killed+relaunched, this function will be executed again
  ///but if the foreground service stayed alive,
  ///this does not need to be re-done
  if (!(await ForegroundService.foregroundServiceIsStarted())) {
    await ForegroundService.setServiceIntervalSeconds(10);

    //necessity of editMode is dubious (see function comments)
    await ForegroundService.notification.startEditMode();

    await ForegroundService.notification
        .setTitle("Pedometer: ${DateTime.now()}");
    await ForegroundService.notification
        .setText("Example Text: ${DateTime.now()}");

    await ForegroundService.notification.finishEditMode();

    await ForegroundService.startForegroundService(foregroundServiceFunction);
    await ForegroundService.getWakeLock();
  }

  ///this exists solely in the main app/isolate,
  ///so needs to be redone after every app kill+relaunch
  ///

  await ForegroundService.setupIsolateCommunication((data) {
    debugPrint("main received: $data");
  });
}

int tempSteps = 0;

/// 진짜 ForegroundService의 몸체.
Future<void> foregroundServiceFunction() async {
  debugPrint("Foreground Service Started!");

  /// if (date == 23:59) {
  /// sp 23:59의 pedo_step 저장.

  SharedPreferences sp;
  sp = await SharedPreferences.getInstance();

  Stream<StepCount> _stepCountStream;
  String _steps = '?';

  void onStepCount(StepCount event) {
    print(event);
    tempSteps = event.steps;
    ForegroundService.notification.setText("Steps : " + tempSteps.toString());
  }

  void onStepCountError(error) {
    print('onStepCountError: $error');
    _steps = 'Step Count not available';
  }

  _stepCountStream = Pedometer.stepCountStream;
  _stepCountStream.listen(onStepCount).onError(onStepCountError);

  if (DateTime.now().hour == 23 && DateTime.now().minute == 59) {
    String sp_key =
        "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}";
    sp.setInt(sp_key, tempSteps);
    debugPrint("WRITE SP!");
  }
  sp.setInt("2020-10-27", 200);

  debugPrint("TEMPSTEPS : " + tempSteps.toString());

  /// 데이터 전송?
  if (!ForegroundService.isIsolateCommunicationSetup) {
    ForegroundService.setupIsolateCommunication((data) {
      debugPrint("bg isolate received: $data");
    });
  }
  //ForegroundService.sendToPort("Steps from Foreground : " + _steps);
}
