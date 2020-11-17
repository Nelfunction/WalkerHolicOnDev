import 'package:flame/spritesheet.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

/// Class for cardview at HOME.
class Gamecard {
  String name;
  int cardSteps;
  int character;

  var myCharacter;

  Gamecard(String name, int steps, int character, var myCharacter) {
    this.name = name;
    this.cardSteps = steps;
    this.character = character;
    this.myCharacter = myCharacter;
  }
}

/// Class for background Color Theme.
/// Contains 3 presets and widget-build option.
class ColorTheme {
  // Numbers for Alignment. Range: -1 ~ 1
  double beginX, beginY, endX, endY;
  // List for Colors.
  List<Color> colors;
  // Gradient blend points.
  List<double> stops;

  ColorTheme(
      this.beginX, this.beginY, this.endX, this.endY, this.colors, this.stops);

  Widget buildContainer() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(beginX, beginY),
          end: Alignment(endX, endY),
          colors: colors,
          stops: stops,
        ),
      ),
    );
  }

  static List<ColorTheme> colorPreset = [
    ColorTheme(
      -1.1,
      -0.3,
      1.4,
      0.6,
      [Color(0xffffade1), Color(0xf03be8bf)],
      [0.0, 1.0],
    ),
    ColorTheme(
      -1,
      1,
      1.18,
      -0.68,
      [Color(0xff9dffff), Color(0xffbe8fff)],
      [0.2, 1.0],
    ),
    ColorTheme(
      -1,
      1,
      1,
      -1,
      [Color(0xff4158d0), Color(0xffc850c0), Color(0xffffcc70)],
      [0.0, 0.46, 1.0],
    ),
  ];
} // class ColorTheme

/// Class for personal data description.
/// Contains chart-build option.
class PersonalStatus {
  final months = [
    'JAN',
    'FEB',
    'MAR',
    'APR',
    'MAY',
    'JUN',
    'JUL',
    'AUG',
    'SEP',
    'OCT',
    'NOV',
    'DEC'
  ];
  final dailyMax = 10000;
  final DateTime startDate;

  DateTime currentDate;
  List<int> recentMonth;
  int totalCount, todayCount;

  PersonalStatus(
    this.startDate, {
    Key key,
    this.todayCount,
    this.totalCount,
    this.currentDate,
    this.recentMonth,
  });

  Widget totalStatus() {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Total',
                style: TextStyle(fontSize: 36, color: Colors.white),
              ),
              Text(
                totalCount.toString(),
                style: TextStyle(fontSize: 36, color: Colors.white),
              )
            ]));
  }

  Widget dailyStatus() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
              margin: EdgeInsets.symmetric(horizontal: 40),
              height: 10,
              child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  child: LinearProgressIndicator(
                    value: todayCount.toDouble() / dailyMax.toDouble(),
                    valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
                    backgroundColor: Colors.white24,
                  ))),
          Container(
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 40),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Today',
                      style: TextStyle(fontSize: 22, color: Colors.white),
                    ),
                    Text(
                      todayCount.toString() + '/' + dailyMax.toString(),
                      style: TextStyle(fontSize: 22, color: Colors.white),
                    )
                  ]))
        ]);
  }

  Widget monthlyStatus() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          RotatedBox(
            quarterTurns: -1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int i in recentMonth)
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 30),
                    child: LinearPercentIndicator(
                      width: 120,
                      //animateFromLastPercent: true,
                      restartAnimation: true,
                      backgroundColor: Colors.transparent,
                      animation: true,
                      lineHeight: 12.0,
                      animationDuration: 2000,
                      percent: i.toDouble() / (dailyMax.toDouble() * 30),
                      linearStrokeCap: LinearStrokeCap.round,
                      progressColor: Colors.white,
                    ),
                  )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 80),
            height: 5,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(recentMonth.length, (index) {
              return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: Text(
                    months[currentDate.month - 3 + index],
                    style: TextStyle(fontSize: 12, color: Colors.white),
                  ));
            }),
          ),
          Container(
              width: 240,
              //margin: EdgeInsets.symmetric(vertical: 10, horizontal: 80),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'This Month:',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    Text(
                      'DISPLEASED',
                      style: TextStyle(fontSize: 18, color: Colors.red),
                    )
                  ]))
        ]);
  }
} // class PersonalStatus

class PersonalOptions {
  //배경색
  int colornum;
  //UI(아이콘, 글자) 색
  //UI 크기
}

Widget flatbutton(
    {Key key,
    String text = 'FlatButton',
    @required VoidCallback onPressed,
    @required BuildContext context}) {
  return FlatButton(
    onPressed: onPressed,
    child: Container(
        margin: EdgeInsets.symmetric(horizontal: 5),
        width: MediaQuery.of(context).size.width,
        height: 50,
        child: Row(children: [
          Text(text,
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Colors.black54,
                fontSize: 22.0,
              ))
        ])),
  );
}
