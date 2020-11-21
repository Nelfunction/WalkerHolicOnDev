import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flame/spritesheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pedometer/pedometer.dart';
import 'package:hive/hive.dart';
import 'package:flutter/material.dart';

import 'dart:async';
import 'dart:ui';
import 'format.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;

Stream<StepCount> stepCountStream;
Stream<PedestrianStatus> pedestrianStatusStream;
var myColor = StreamController.broadcast();
StreamController<int> visualize = StreamController();
StreamController<int> textColor = StreamController();
SharedPreferences prefs;

Color currentColor = Colors.white;

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

//친구 요청 리스트
var friend_requests = <String>[];

//친구 요청 리스트 불러오는 함수
Future<void> loadfriend_request_list() async {
  Map<String, dynamic> result;
  await firestore
      .collection(userid)
      .doc('friend_request_list')
      .get()
      .then((DocumentSnapshot documentSnapshot) {
    if (documentSnapshot.exists) {
      result = documentSnapshot.data();

      result.forEach((key, value) {
        friend_requests.add(key);
      });
    } else {}
  });
}

//친구 요청 accept 를 실행하는 함수
acceptfriendrequest(String friendname) async {
  await firestore
      .collection(userid)
      .doc('friend_list')
      .get()
      .then((DocumentSnapshot documentSnapshot) {
    if (documentSnapshot.exists) {
      firestore
          .collection(userid)
            .doc('friend_list')
            .update({friendname: friendname});
    } else {
      firestore
          .collection(userid)
          .doc('friend_list')
          .set({friendname: friendname});
    }
  });

  await firestore
      .collection(friendname)
      .doc('friend_list')
      .get()
      .then((DocumentSnapshot documentSnapshot) {
    if (documentSnapshot.exists) {
      firestore
        .collection(friendname).doc('friend_list').update({userid: userid});
    } else {
      firestore.collection(friendname).doc('friend_list').set({userid: userid});
    }
  });

  await firestore
      .collection(userid)
      .doc('friend_request_list')
      .update({friendname: FieldValue.delete()});

  await firestore
      .collection(friendname)
      .doc('friend_request_list')
      .update({userid: FieldValue.delete()});
}

//친구 요청 deny 를 실행하는 함수
denyfriendrequest(String friendname) async {
  await firestore
      .collection(userid)
      .doc('friend_request_list')
      .update({friendname: FieldValue.delete()});
}

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
      existed = true;
    } else {
      existed = false;
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
      firestore
          .collection(friendname)
          .doc('friend_request_list')
          .update({userid: userid});
    } else {
      firestore
          .collection(friendname)
          .doc('friend_request_list')
          .set({userid: userid});
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

//cloud firestore에서 나의 steps을 불러온뒤 gamecards에 넣는 함수
Future<void> loadmydata() async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  int gamecardstep = steps;
  int character = 1;
  String myCharacter_str = "kitten.png";
  SpriteSheet myCharacter = new SpriteSheet(
      imageName: myCharacter_str,
      textureWidth: 160,
      textureHeight: 160,
      columns: 4,
      rows: 1);

  var myAnimation = myCharacter.createAnimation(0, stepTime: 0.1);

  // Character+Background를 불러옴
  await firestore
      .collection(userid)
      .doc('Character+Background')
      .get()
      .then((DocumentSnapshot documentSnapshot) {
    if (documentSnapshot.exists) {
      myCharacter_str = documentSnapshot.get('character');
      myCharacter = SpriteSheet(
        imageName: myCharacter_str,
        textureWidth: 160,
        textureHeight: 160,
        columns: 4,
        rows: 1,
      );
      myAnimation = myCharacter.createAnimation(0, stepTime: 0.1);
    } else {
      myAnimation = myCharacter.createAnimation(0, stepTime: 0.1);
    }
  });

  debugPrint("##### Load My Data! #####");
  gamecards.add(Gamecard(userid, gamecardstep, myAnimation)); //gamecards에 추가
}

//cloud firestore 친구 목록에서부터 친구들의 오늘의 steps을 gamecards에 넣는 함수
Future<void> loadfrienddata() async {
  int gamecardstep = steps;
  String myCharacter_str = "kitten.png";
  SpriteSheet myCharacter = new SpriteSheet(
      imageName: myCharacter_str,
      textureWidth: 160,
      textureHeight: 160,
      columns: 4,
      rows: 1);
  var myAnimation = myCharacter.createAnimation(0, stepTime: 0.1);

  Map<String, dynamic> result;
  var list = [];

  await firestore
      .collection(userid)
      .doc('friend_list')
      .get()
      .then((DocumentSnapshot documentSnapshot) {
    if (documentSnapshot.exists) {
      result = documentSnapshot.data();
      result.forEach((k, v) => list.add(k));

    }
    else {
    }
  });

  for(int i=0;i<list.length;i++)
    {

      String key=list[i];
      await firestore
          .collection(key)
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
          .collection(key)
          .doc('Character+Background')
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          myCharacter_str = documentSnapshot.get('character');
          myCharacter = SpriteSheet(
            imageName: myCharacter_str,
            textureWidth: 160,
            textureHeight: 160,
            columns: 4,
            rows: 1,
          );
          myAnimation = myCharacter.createAnimation(0,stepTime: 0.1);
        } else {
          myAnimation = myCharacter.createAnimation(0,stepTime: 0.1);
        }
      });

      gamecards.add(Gamecard(key, gamecardstep, myAnimation));


    }



}
