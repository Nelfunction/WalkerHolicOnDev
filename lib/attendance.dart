import 'package:flutter/material.dart';

import 'logic/format.dart';
import 'logic/global.dart';

class AttendancePage extends StatefulWidget {
  int presetNum;

  AttendancePage(int pressNum) {
    this.presetNum = pressNum;
  }

  @override
  _AttendancePageState createState() => _AttendancePageState(presetNum);
}

class _AttendancePageState extends State<AttendancePage> {
  int presetNumState;

  _AttendancePageState(int presetNumState) {
    this.presetNumState = presetNumState;
  }
  List<List<String>> input = [
    ["1", "2", "3", "4"],
    ["5", "6", "7", "8"],
    ["9", "10", "11", "12"],
    ["13", "14", "15", "16"],
    ["17", "18", "19", "20"],
    ["21", "22", "23", "24"],
    ["25", "26", "27", "28"]
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Attendance',
      home: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            ColorTheme.colorPreset[presetNumState].buildContainer(),
            Center(
                child: Container(
              child: Column(
                children: [
                  SizedBox(height: 70),
                  Text(
                    getmonth(DateTime.now()).toString() + ' Attendance',
                    style: TextStyle(fontSize: 30, color: Colors.white),
                  ),
                  Expanded(
                    child: ListView.builder(
                        physics: BouncingScrollPhysics(),
                        padding: EdgeInsets.all(10),
                        shrinkWrap: true,
                        itemCount: input.length,
                        itemBuilder: (BuildContext context, int index) {
                          return AttendanceRow(
                            input: input[index],
                          );
                        }),
                  )
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class AttendanceRow extends StatefulWidget {
  final List<String> input;

  String char1, char2, char3, char4;

  AttendanceRow({this.input}) {
    this.char1 = input[0];
    this.char2 = input[1];
    this.char3 = input[2];
    this.char4 = input[3];
  }

  _AttendanceRowState createState() => _AttendanceRowState();
}

class _AttendanceRowState extends State<AttendanceRow> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AttendanceContainer(nameChar: widget.char1),
          AttendanceContainer(nameChar: widget.char2),
          AttendanceContainer(nameChar: widget.char3),
          AttendanceContainer(nameChar: widget.char4),
        ],
      ),
    );
  }
}

class AttendanceContainer extends StatelessWidget {
  final String nameChar;
  const AttendanceContainer({this.nameChar = ""});

  @override
  Widget build(BuildContext context) {
    String nameText = "Day " + nameChar;
    if ((int.parse(nameChar)) <= days) {
      //이미 출석체크한 날이면
      return Column(
        children: [
          InkWell(
            onTap: () {
              //일단 자동으로 선물을 주는걸로 생각해 따로 터치기능은 구현하지 않음
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white, width: 4),
                color: Color.fromARGB(100, 255, 255, 255),
              ),
              margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
              padding: EdgeInsets.all(10),
              child: SizedBox(
                width: 40,
                height: 40,
                child: Image.asset("assets/images/check.png"),
              ),
            ),
          ),
          Text(
            nameText,
            style: TextStyle(fontSize: 10, color: Colors.white),
          )
        ],
      );
    }
    if ((int.parse(nameChar) - 4) % 8 == 0) {
      //선물을 받을 날이면
      return Column(
        children: [
          InkWell(
            onTap: () {
              //일단 자동으로 선물을 주는걸로 생각해 따로 터치기능은 구현하지 않음
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white, width: 4),
                color: Color.fromARGB(100, 255, 255, 255),
              ),
              margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
              padding: EdgeInsets.all(10),
              child: SizedBox(
                width: 40,
                height: 40,
                child: Image.asset("assets/images/box.png"),
              ),
            ),
          ),
          Text(
            nameText,
            style: TextStyle(fontSize: 10, color: Colors.white),
          )
        ],
      );
    } else {
      //그외 빈공간
      return Column(
        children: [
          InkWell(
            onTap: () {
              //일단 자동으로 선물을 주는걸로 생각해 따로 터치기능은 구현하지 않음
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white, width: 4),
                color: Color.fromARGB(100, 255, 255, 255),
              ),
              margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
              padding: EdgeInsets.all(10),
              child: SizedBox(
                width: 40,
                height: 40,
              ),
            ),
          ),
          Text(
            nameText,
            style: TextStyle(fontSize: 10, color: Colors.white),
          )
        ],
      );
    }
  }
}
