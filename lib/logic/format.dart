import 'dart:math';

import 'package:flame/spritesheet.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:intl/intl.dart';

import 'global.dart';

/// Class for cardview at HOME.
class Gamecard {
  String name;
  int cardSteps;

  var myCharacter;

  int background;

  Gamecard(String name, int steps, var myCharacter, int background) {
    this.name = name;
    this.cardSteps = steps;
    this.myCharacter = myCharacter;
    this.background = background;
  }
}

/// Class for background Color Theme.
/// Contains 3 presets and widget-build option.
class ColorTheme {
  // Numbers for Alignment. Range: -1 ~ 1
  List<double> align;
  // List for Colors.
  List<Color> colors;
  // Gradient blend points.
  List<double> stops;
  Color textColor;

  ColorTheme({
    this.align = const [-1.0, -1.0, 1.0, 1.0],
    this.colors,
    this.stops = const [0.0, 1.0],
    this.textColor,
  });

  Widget buildContainer() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(align[0], align[1]),
          end: Alignment(align[2], align[3]),
          colors: colors,
          stops: stops,
        ),
      ),
    );
  }

  static List<ColorTheme> colorPreset = [
    ColorTheme(
      align: [-1.1, -0.3, 1.4, 0.6],
      colors: [Color(0xffffade1), Color(0xf03be8bf)],
      stops: [0.0, 1.0],
    ),
    ColorTheme(
      align: [-1, 1, 1.18, -0.68],
      colors: [Color(0xff9dffff), Color(0xffbe8fff)],
      stops: [0.2, 1.0],
    ),
    ColorTheme(
      align: [-1, 1, 1, -1],
      colors: [Color(0xff4158d0), Color(0xffc850c0), Color(0xffffcc70)],
      stops: [0.0, 0.46, 1.0],
    ),
    ColorTheme(
      align: [0, 1, 0, -1],
      colors: [Color(0xff08aeea), Color(0xff2af598)],
      stops: [0.0, 1.0],
    ),
    ColorTheme(
      align: [-1, 1, 1, -1],
      colors: [Color(0xfffbda61), Color(0xffff5acd)],
      stops: [0.0, 1.0],
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
  List<int> recentWeek;
  List<int> recentMonth;
  int totalCount, todayCount;

  PersonalStatus(
    this.startDate, {
    Key key,
    this.todayCount,
    this.totalCount,
    this.currentDate,
    this.recentWeek,
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
                style: TextStyle(fontSize: 36),
              ),
              Text(
                totalCount.toString(),
                style: TextStyle(fontSize: 36),
              )
            ]));
  }

  Widget dailyStatus() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
                margin: EdgeInsets.symmetric(horizontal: 40),
                height: 10,
                child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    child: LinearProgressIndicator(
                      value: todayCount.toDouble() / dailyMax.toDouble(),
                      valueColor:
                          new AlwaysStoppedAnimation<Color>(Colors.white),
                      backgroundColor: Colors.white24,
                    ))),
            Container(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 40),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Today',
                        style: TextStyle(
                          fontSize: 22,
                        ),
                      ),
                      Text(
                        todayCount.toString() + '/' + dailyMax.toString(),
                        style: TextStyle(
                          fontSize: 22,
                        ),
                      )
                    ]))
          ]),
    );
  }

  Widget weeklyStatus() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            RotatedBox(
              quarterTurns: -1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(recentWeek.length, (index) {
                  return Container(
                    height: 30,
                    child: LinearPercentIndicator(
                      width: 120,
                      backgroundColor: Colors.transparent,
                      animation: true,
                      lineHeight: 10.0,
                      animationDuration: 2000,
                      percent: recentWeek[index].toDouble() /
                          recentweekstepmax.toDouble(),
                      linearStrokeCap: LinearStrokeCap.round,
                      progressColor: Colors.white,
                    ),
                  );
                }),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              height: 5,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(recentWeek.length, (index) {
                return Container(
                  width: 30,
                  child: Text(
                    DateFormat('MM/dd').format(DateTime(currentDate.year,
                        currentDate.month, currentDate.day - 6 + index)),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 10,
                    ),
                  ),
                );
              }),
            ),
            Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Recent 7 days :',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        recentWeek.reduce((a, b) => a + b).toString(),
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      )
                    ]))
          ]),
    );
  }

  Widget monthlyStatus() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 30),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            RotatedBox(
              quarterTurns: -1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(recentMonth.length, (index) {
                  return Container(
                    height: 30,
                    child: LinearPercentIndicator(
                      width: 120,
                      //animateFromLastPercent: true,
                      restartAnimation: true,
                      backgroundColor: Colors.transparent,
                      animation: true,
                      lineHeight: 12.0,
                      animationDuration: 2000,
                      percent: recentMonth[index].toDouble() /
                          recentmonthstepmax.toDouble(),
                      linearStrokeCap: LinearStrokeCap.round,
                      progressColor: Colors.white,
                    ),
                  );
                }),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 40),
              height: 5,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(recentMonth.length, (index) {
                return Container(
                  width: 30,
                  child: Text(
                    months[(currentDate.month - 4 + index) % 12],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                );
              }),
            ),
            Container(
                margin: EdgeInsets.symmetric(horizontal: 40),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'This Month:',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        (recentMonth[3] > recentmonthstepmax * 0.6)
                            ? 'SATISFIED'
                            : 'DISPLEASED',
                        style: TextStyle(
                            fontSize: 18,
                            color: (recentMonth[3] > recentmonthstepmax * 0.6)
                                ? Colors.green
                                : Colors.red),
                      )
                    ]))
          ]),
    );
  }
} // class PersonalStatus

/// 옵션
class PersonalOptions {
  bool usePreset;
  int presetNum;
  ColorTheme colorTheme;
  Color textColor;

  /// daily, weekly, monthly
  List<bool> showList;

  PersonalOptions({
    Key key,
    this.usePreset,
    this.presetNum,
    this.colorTheme,
    this.textColor,
    this.showList,
  });
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

Widget friendStatus(BuildContext context) {
  double max = gamecards
      .reduce((a, b) => a.cardSteps > b.cardSteps ? a : b)
      .cardSteps
      .toDouble();
  int mine = gamecards[0].cardSteps;
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 30, vertical: 40),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: List.generate(gamecards.length, (index) {
            return Container(
              alignment: Alignment.topRight,
              height: 30,
              width: 80,
              child: Text(
                gamecards[index].name,
                style: TextStyle(fontSize: 12),
              ),
            );
          }),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          width: 5,
          //height: 50,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: List.generate(gamecards.length, (index) {
            return Container(
              alignment: Alignment.topCenter,
              height: 30,
              child: Stack(children: <Widget>[
                LinearPercentIndicator(
                  width: MediaQuery.of(context).size.width - 200,
                  //animateFromLastPercent: true,
                  restartAnimation: true,
                  backgroundColor: Colors.transparent,
                  animation: true,
                  lineHeight: 12.0,
                  animationDuration: 2000,
                  percent:
                      (gamecards[index].cardSteps.toDouble() + 1) / (max + 2),
                  linearStrokeCap: LinearStrokeCap.round,
                  progressColor: (mine > gamecards[index].cardSteps)
                      ? Colors.red
                      : (mine == gamecards[index].cardSteps)
                          ? Colors.white
                          : Colors.green,
                ),
                Container(
                  alignment: Alignment.topLeft,
                  margin: EdgeInsets.fromLTRB(
                      (MediaQuery.of(context).size.width - 220) *
                              (gamecards[index].cardSteps + 1) /
                              (max + 2) +
                          20,
                      0,
                      0,
                      0),
                  height: 30,
                  //width: 40,
                  child: Text(
                    gamecards[index].cardSteps.toString(),
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ]),
            );
          }),
        ),
      ],
    ),
  );
}
