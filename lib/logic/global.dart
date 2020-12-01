import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flame/spritesheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pedometer/pedometer.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:ui';
import 'dart:math';

import 'format.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;

Stream<StepCount> stepCountStream;
Stream<PedestrianStatus> pedestrianStatusStream;
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
int psteps = 0; // 전날 기기의 stepcount
int steps = 53; // 현재 기기의 stepcount
int datastep = 0; // 오늘 이미 파이어베이스에 저장된 스탭수
int tempstep = 0; //현재 기기의 stepcount를 고정하여 저장

int recentweekstepmax = 10000; // 최근 7일의 걸음수의 평균
int recentmonthstepmax = 100000; // 최근 7일의 걸음수의 평균

void initStepCount(StepCount event) {
  //스텝을 최초에 불러옴
  /// Handle step count changed
  steps = event.steps;
}

Future<void> initstep() async {
  //스텝을 최초에 불러옴
  Stream<StepCount> initstepCountStream;
  initstepCountStream = await Pedometer.stepCountStream;

  /// Listen to streams and handle errors
  initstepCountStream.listen(initStepCount);
}

//gamecard 전역변수
var gamecards = <Gamecard>[];

// 게임 캐릭터 전역변수

List<List<String>> globalCharacterList = [
  ["", "BlackWhite", "Black", "Flame"],
  ["Q", "Q", "Q", "Q"],
  ["Q", "Q", "Q", "Q"],
];

List<List<bool>> globalCharacterListBool = [
  [true, false, false, false],
  [false, false, false, false],
  [false, false, false, false]
];

List<String> globalCharacters = ["", "BlackWhite", "Black", "Flame"];

// 랜덤박스 에니메이션

final kittenRandomSprite = SpriteSheet(
  imageName: 'kittenRandomSprite.png',
  textureWidth: 110,
  textureHeight: 110,
  columns: 8,
  rows: 1,
);

// 랜덤박스 개수
int randomBoxNumber = 1;

var randomAnimation;

//친구 요청 리스트
var friend_requests = <String>[];

//출석 체크 전역 변수
String lastday = '';
int days = 1;

/// 개인기록
PersonalStatus status = PersonalStatus(
  DateTime.now(),
  todayCount: -1,
  totalCount: -1,
  recentWeek: [2000, 7012, 0, 3000, 4010, 10000, 1997],
  recentMonth: [222222, 272222, 75000, 111111],
  currentDate: DateTime.now(),
);

//출석체크 함수
Future<void> attendance() async {
  await firestore
      .collection(userid)
      .doc('attendance')
      .get()
      .then((DocumentSnapshot documentSnapshot) {
    if (documentSnapshot.exists) {
      lastday = documentSnapshot.get('lastday');
      days = documentSnapshot.get('days');

      if (getdate(DateTime.now()).toString() == lastday) {
        // 오늘 이미 출석체크를 했다면

      } else //오늘 이미 출석체크한게 아니면
      {
        if (getmonth(DateTime.now()).toString() ==
            documentSnapshot.get('month')) {
          // 아직 한달이 안지났다면
          days = days + 1;
          lastday = getdate(DateTime.now()).toString();
          firestore.collection(userid).doc('attendance').set({
            "days": days,
            "lastday": lastday,
            "month": getmonth(DateTime.now()).toString()
          });

          if ((days - 4) % 8 == 0) {
            //선물을 주는 날이 되었다면?
            randomBoxNumber++;
            //가챠박스 1 증가
          }
        } else {
          //한달이 지났다면
          days = 1;
          lastday = getdate(DateTime.now()).toString();
          firestore.collection(userid).doc('attendance').set({
            "days": days,
            "lastday": lastday,
            "month": getmonth(DateTime.now()).toString()
          });
        }
      }
    } else {
      firestore.collection(userid).doc('attendance').set({
        "days": 1,
        "lastday": getdate(DateTime.now()).toString(),
        "month": getmonth(DateTime.now()).toString()
      });
    }
  });
}

//최근 7일(오늘포함)하여 steps를 불러오는 함수
Future<void> loadrecentweeks() async {
  recentweekstepmax = 1;

  int daystep = 0;
  for (int i = 0; i < 7; i++) {
    var tempdate = getdate(new DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day - 6 + i));

    await firestore
        .collection(userid)
        .doc(tempdate.toString())
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        daystep = documentSnapshot.get('steps');
      } else {
        daystep = 0;
      }
    });

    status.recentWeek[i] = daystep;
    recentweekstepmax = max(recentweekstepmax, daystep) + 1;
  }
}

//최근 네달(요번 달 포함)하여 steps를 불러오는 함수
Future<void> loadrecentmonths() async {
  recentmonthstepmax = 1;
  int monthstep = 0;
  int daystep = 0;
  int month = DateTime.now().month;
  int tempnum = DateTime.now().day;

  for (int i = 0; i < tempnum; i++) {
    var tempdate = getdate(new DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day - i));

    await firestore
        .collection(userid)
        .doc(tempdate.toString())
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        daystep = documentSnapshot.get('steps');
      } else {
        daystep = 0;
      }
    });
    monthstep += daystep;
  }
  status.recentMonth[3] = monthstep;
  recentmonthstepmax = max(recentmonthstepmax, monthstep) + 1;
  bool load = false;

  monthstep = 0;
  int tempnum2 = DateTime.now().subtract(Duration(days: tempnum)).day;
  await firestore
      .collection(userid)
      .doc(getmonth(DateTime.now().subtract(Duration(days: tempnum))))
      .get()
      .then((DocumentSnapshot documentSnapshot) {
    if (documentSnapshot.exists) {
      monthstep = documentSnapshot.get('steps');
      load = false;
    } else {
      monthstep = 0;
      load = true;
    }
  });

  if (load) {
    for (int i = 0; i < tempnum2; i++) {
      var tempdate = getdate(new DateTime(DateTime.now().year,
          DateTime.now().month, DateTime.now().day - tempnum - i));

      await firestore
          .collection(userid)
          .doc(tempdate.toString())
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          daystep = documentSnapshot.get('steps');
        } else {
          daystep = 0;
        }
      });
      monthstep += daystep;
    }
  }
  status.recentMonth[2] = monthstep;
  recentmonthstepmax = max(recentmonthstepmax, monthstep) + 1;

  await firestore
      .collection(userid)
      .doc(getmonth(DateTime.now().subtract(Duration(days: tempnum))))
      .set({'steps': monthstep});

  debugPrint(
      "11111111 ${getmonth(DateTime.now().subtract(Duration(days: tempnum)))}");

  int tempnum3 =
      DateTime.now().subtract(Duration(days: tempnum + tempnum2)).day;
  monthstep = 0;

  await firestore
      .collection(userid)
      .doc(
          getmonth(DateTime.now().subtract(Duration(days: tempnum + tempnum2))))
      .get()
      .then((DocumentSnapshot documentSnapshot) {
    if (documentSnapshot.exists) {
      monthstep = documentSnapshot.get('steps');
      load = false;
    } else {
      monthstep = 0;
      load = true;
    }
  });

  if (load) {
    for (int i = 0; i < tempnum3; i++) {
      var tempdate = getdate(new DateTime(DateTime.now().year,
          DateTime.now().month, DateTime.now().day - tempnum - tempnum2 - i));

      await firestore
          .collection(userid)
          .doc(tempdate.toString())
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          daystep = documentSnapshot.get('steps');
        } else {
          daystep = 0;
        }
      });
      monthstep += daystep;
    }
  }
  status.recentMonth[1] = monthstep;
  recentmonthstepmax = max(recentmonthstepmax, monthstep) + 1;

  await firestore
      .collection(userid)
      .doc(
          getmonth(DateTime.now().subtract(Duration(days: tempnum + tempnum2))))
      .set({'steps': monthstep});

  debugPrint(
      "22222222 ${getmonth(DateTime.now().subtract(Duration(days: tempnum - tempnum2)))}");

  int tempnum4 = DateTime.now()
      .subtract(Duration(days: tempnum + tempnum2 + tempnum3))
      .day;

  await firestore
      .collection(userid)
      .doc(getmonth(DateTime.now()
          .subtract(Duration(days: tempnum + tempnum2 + tempnum3))))
      .get()
      .then((DocumentSnapshot documentSnapshot) {
    if (documentSnapshot.exists) {
      monthstep = documentSnapshot.get('steps');
      load = false;
    } else {
      monthstep = 0;
      load = true;
    }
  });

  if (load) {
    for (int i = 0; i < tempnum4; i++) {
      var tempdate = getdate(new DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day - tempnum - tempnum2 - tempnum3 - i));

      await firestore
          .collection(userid)
          .doc(tempdate.toString())
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          daystep = documentSnapshot.get('steps');
        } else {
          daystep = 0;
        }
      });
      monthstep += daystep;
    }
  }
  status.recentMonth[0] = monthstep;
  recentmonthstepmax = max(recentmonthstepmax, monthstep) + 1;

  await firestore
      .collection(userid)
      .doc(getmonth(DateTime.now()
          .subtract(Duration(days: tempnum + tempnum2 + tempnum3))))
      .set({'steps': monthstep});
  debugPrint(
      "333333333 ${getmonth(DateTime.now().subtract(Duration(days: tempnum + tempnum2 + tempnum3)))}");
}

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
          .collection(friendname)
          .doc('friend_list')
          .update({userid: userid});
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
  status.totalCount = totalsteps - steps + psteps;
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

//년-월을 반환하는 함수
String getmonth(DateTime date) {
  var dateYMD = "${date.year}-${date.month}";
  return dateYMD;
}

//데이터를 파이어베이스로 전송하는 함수, 앱 실행시, 23:59분마다 실행할 예정, 새로고침버튼도 고려중
senddata() async {
  debugPrint('steps: $steps');
  debugPrint('psteps: $psteps');

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

  debugPrint('AAAAAAAAAAAAAA');
  await firestore
      .collection(userid)
      .doc(getdate(DateTime.now()).toString())
      .get()
      .then((DocumentSnapshot documentSnapshot) {
    if (documentSnapshot.exists) {
      datastep = documentSnapshot.get('steps');
    } else {
      datastep = 0;
    }
  });
  debugPrint('datasteps: $datastep');
  debugPrint('BBBBBBBBBBBBBBBB');

  await firestore
      .collection(userid)
      .doc(getdate(DateTime.now()).toString())
      .set({'time': DateTime.now(), 'steps': steps - psteps});

  debugPrint('CCCCCCCCCCCCCCCCCCCCCC');
  await firestore
      .collection(userid)
      .doc('total_steps')
      .set({'total_steps': totalsteps + steps - psteps - datastep});
  debugPrint('DDDDDDDD');
  tempstep = steps;
}

//cloud firestore에서 나의 steps을 불러온뒤 gamecards에 넣는 함수
Future<void> loadmydata() async {
  int gamecardstep = steps - psteps;
  int character = 1;
  String myCharacter_str = "kitten.png";
  SpriteSheet myCharacter = new SpriteSheet(
      imageName: myCharacter_str,
      textureWidth: 160,
      textureHeight: 160,
      columns: 4,
      rows: 1);

  var myAnimation = myCharacter.createAnimation(0, stepTime: 1);

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

  int backgroundCode = 2;
  await firestore
      .collection(userid)
      .doc('Character+Background')
      .get()
      .then((DocumentSnapshot documentSnapshot) {
    if (documentSnapshot.exists) {
      backgroundCode = documentSnapshot.get('background');
    } else {
      backgroundCode = 2;
    }
  });

  debugPrint("##### Load My Data! #####");
  gamecards.add(Gamecard(
      userid, gamecardstep, myAnimation, backgroundCode)); //gamecards에 추가
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
    } else {}
  });

  int length = min(10, list.length);

  for (int i = 0; i < length; i++) {
    String key = list[i];
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
        myAnimation = myCharacter.createAnimation(0, stepTime: 0.1);
      } else {
        myAnimation = myCharacter.createAnimation(0, stepTime: 0.1);
      }
    });

    int backgroundCode;
    await firestore
        .collection(key)
        .doc('Character+Background')
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        backgroundCode = documentSnapshot.get('background');
      } else {
        backgroundCode = 2;
      }
    });

    gamecards.add(Gamecard(key, gamecardstep, myAnimation, backgroundCode));
  }
}
