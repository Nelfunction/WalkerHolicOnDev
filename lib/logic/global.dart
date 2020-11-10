import 'package:cloud_firestore/cloud_firestore.dart';
import 'format.dart';

class Global {}

//login 전역변수
String name;
String email = 'temp';
String userid = 'temp';
String imageUrl;
String id = 'temp';

//pedo 전역변수
int psteps = 10;
int datastep = 50;
int totalsteps = 1000;
int steps = 100;

//gamecard 전역변수
final gamecards = <Gamecard>[];

String getdate(DateTime date) {
  var dateYMD = "${date.year}-${date.month}-${date.day}";
  return dateYMD;
}

//cloud firestore 친구 목록에서부터 친구들의 오늘의 steps을 gamecards에 넣는 함수
Future<void> loadfrienddata() async {
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
