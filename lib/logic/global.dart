import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pedometer/pedometer.dart';
import 'package:hive/hive.dart';

import 'dart:async';
import 'format.dart';

class Global {}

FirebaseFirestore firestore = FirebaseFirestore.instance;

Stream<StepCount> stepCountStream;
Stream<PedestrianStatus> pedestrianStatusStream;
var myColor = StreamController.broadcast();
SharedPreferences prefs;

//login 전역변수
String name;
String email = 'temp';
String userid = 'temp';
String imageUrl;
String id = 'temp';

/// pedo 전역변수
int totalsteps = 1000; // 앱을 시작한 순간 서버에 기록되어 있는 총 걸음 수
int psteps = 10; // 전날 기기의 stepcount
int steps = 100; // 현재 기기의 stepcount

//gamecard 전역변수
var gamecards = <Gamecard>[];

/// 개인기록
PersonalStatus status = PersonalStatus(
  DateTime.now(),
  todayCount: -1,
  totalCount: -1,
  recentWeek: [2000, 7012, 4942, 3000, 4010, 10000, 1997],
  recentMonth: [222222, 272222, 75000, 111111],
  currentDate: DateTime.now(),
);

/// 설정값
PersonalOptions options = PersonalOptions(
  showList: [true, true, true, true],
);

initPermission() async {
  if (await Permission.activityRecognition.request().isGranted) {
    debugPrint("PERMISSION OK");
  } else {
    debugPrint("ERROR : PERMISSION");
  }

  stepCountStream = Pedometer.stepCountStream;
  pedestrianStatusStream = Pedometer.pedestrianStatusStream;
}

/// Firebase 데이터 가져오기
getServerdata() async {
  await firestore
      .collection(userid)
      .doc('total_steps')
      .get()
      .then((DocumentSnapshot documentSnapshot) {
    if (documentSnapshot.exists) {
      totalsteps = documentSnapshot.get('total_steps');
    } else {
      totalsteps = 0;
    }
  });
  status.totalCount = totalsteps;
}

///입력한 친구 이름이 파이어베이스에 있을 시
Future<bool> is_name_existed(String friendname) async {
  bool existed;
  await firestore
      .collection(friendname)
      .doc('total_steps')
      .get()
      .then((DocumentSnapshot documentSnapshot) {
    if (documentSnapshot.exists) {
      existed= true;
    } else {
      existed= false;
    }
  });
  return existed;
}

//친구 "요청" 목록에 추가하는 함수
sendfriendrequest(String friendname) async {

  await firestore
      .collection(friendname)
      .doc('friend_request_list')
      .get()
      .then((DocumentSnapshot documentSnapshot) {
    if (documentSnapshot.exists) {
      int num = documentSnapshot.get('num');
      num++;
      firestore
          .collection(friendname)
          .doc('friend_request_list')
          .update({'num': num, 'name'+num.toString(): userid});

    } else {
      firestore
          .collection(friendname)
          .doc('friend_request_list')
          .set({'num': 1, 'name1': userid});
    }
  });


}



/// 로컬 데이터 가져오기
getLocaldata() async {
  prefs = await SharedPreferences.getInstance();

  //배경 스트림 갱신
  myColor.add(ColorTheme.colorPreset[prefs.getInt('myColor') ?? 0]);

  //SP에서 어제 페도미터 값 가져오기
  DateTime datetime = new DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day - 1);
  String sp_key = "${datetime.year}-${datetime.month}-${datetime.day}";
  int psteps = prefs.getInt(sp_key);
  if (psteps == null) {
    psteps = 0;
  }
  status.todayCount = steps - psteps;
}

String getdate(DateTime date) {
  var dateYMD = "${date.year}-${date.month}-${date.day}";
  return dateYMD;
}

//totalstep을 파이어베이스에서 로드하는 함수
Future<int> loadtotalstep() async {
  int result;
  await FirebaseFirestore.instance
      .collection(userid)
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

//데이터를 파이어베이스로 전송하는 함수, 앱 실행시, 23:59분마다 실행할 예정, 새로고침버튼도 고려중
senddata() {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  debugPrint('steps: $steps');
  debugPrint('psteps: $psteps');
  firestore
      .collection(userid)
      .doc(getdate(DateTime.now()))
      .set({'time': DateTime.now(), 'steps': steps - psteps});
  loadtotalstep().then((result) {
    // If we need to rebuild the widget with the resulting data,
    // make sure to use setState
    totalsteps = result;
  });

  firestore
      .collection(userid)
      .doc('total_steps')
      .set({'total_steps': totalsteps + steps - psteps});
}

//cloud firestore 친구 목록에서부터 친구들의 오늘의 steps을 gamecards에 넣는 함수
Future<void> loadmydata() async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  int gamecardstep = steps;
  int character = 1;

  await firestore
      .collection(userid)
      .doc('character')
      .get()
      .then((DocumentSnapshot documentSnapshot) {
    if (documentSnapshot.exists) {
      character = documentSnapshot.get('character');
    } else {
      character = 1;
    }
  });

  gamecards.add(Gamecard(userid, gamecardstep, character)); //gamecards에 추가
}

//cloud firestore 친구 목록에서부터 친구들의 오늘의 steps을 gamecards에 넣는 함수
Future<void> loadfrienddata() async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  int gamecardstep = steps;
  int character = 1;
  int friendnum;

  await firestore
      .collection(userid)
      .doc('friend_list')
      .get()
      .then((DocumentSnapshot documentSnapshot) {
    if (documentSnapshot.exists) {
      friendnum = documentSnapshot.get('num');
    } else {
      friendnum = 0;
    }
  });

  for (int i = 1; i <= friendnum; i++) //친구의 숫자만큼 gamecards에 추가
  {
    String temp = 'name' + i.toString();
    String friendname = 'temp';

    await firestore
        .collection(userid)
        .doc('friend_list')
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        friendname = documentSnapshot.get(temp);
      } else {
        friendname = 'null';
      }
    });

    await firestore
        .collection(friendname)
        .doc(getdate(DateTime.now()))
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        gamecardstep = documentSnapshot.get('steps');
      } else {
        gamecardstep = 0;
      }
    });

    await firestore
        .collection(friendname)
        .doc('character')
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        character = documentSnapshot.get('character');
      } else {
        character = 1;
      }
    });

    gamecards.add(Gamecard(friendname, gamecardstep, character));
  }
}
