//login 전역변수
import 'package:walkerholic_sprite/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
final gamecards = <gamecard>[];

//totalstep을 파이어베이스에서 로드하느 ㄴ함수
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
void senddata(){
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


  await firestore.collection(userid).doc('character').get().then((DocumentSnapshot documentSnapshot){
    if (documentSnapshot.exists) {
      character = documentSnapshot.get('character');
    } else {
      character = 1;
    }
  });

  gamecards.add(gamecard(userid, gamecardstep, character)); //gamecards에 추가


}

//cloud firestore 친구 목록에서부터 친구들의 오늘의 steps을 gamecards에 넣는 함수
Future<void> loadfrienddata() async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  int gamecardstep = steps;
  int character = 1;
  int friendnum;


  await firestore.collection(userid).doc('friend_list').get().then((DocumentSnapshot documentSnapshot){
    if (documentSnapshot.exists) {
      friendnum = documentSnapshot.get('num');
    } else {
      friendnum=0;
    }
  });

  for (int i = 1; i <= friendnum; i++) //친구의 숫자만큼 gamecards에 추가
      {
    String temp = 'name' + i.toString();
    String friendname = 'temp';

    await firestore.collection(userid).doc('friend_list').get().then((DocumentSnapshot documentSnapshot){
      if (documentSnapshot.exists) {
        friendname = documentSnapshot.get(temp);
      } else {
        friendname = 'null';
      }
    });

    await firestore.collection(friendname).doc(getdate(DateTime.now())).get().then((DocumentSnapshot documentSnapshot){
      if (documentSnapshot.exists) {
        gamecardstep = documentSnapshot.get('steps');
      } else {
        gamecardstep = 0;
      }
    });

    await firestore.collection(friendname).doc('character').get().then((DocumentSnapshot documentSnapshot){
      if (documentSnapshot.exists) {
        character = documentSnapshot.get('character');
      } else {
        character = 1;
      }
    });


    gamecards.add(gamecard(friendname, gamecardstep, character));
  }
}
