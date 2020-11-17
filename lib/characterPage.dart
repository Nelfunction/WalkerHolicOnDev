import 'package:flutter/material.dart';

import 'characterOne.dart';

class CharacterPage extends StatefulWidget {
  @override
  _CharacterPageState createState() => _CharacterPageState();
}

class _CharacterPageState extends State<CharacterPage> {
  // 개같이 대충 코딩한 부분임.
  // input이 입력받은 데이터임.
  List<List<String>> input = [
    ["", "BlackWhite", "Black", "Flame"],
    ["Q", "Q", "Q", "Q"],
    ["Q", "Q", "Q", "Q"],
    ["Q", "Q", "Q", "Q"],
    ["Q", "Q", "Q", "Q"],
    ["Q", "Q", "Q", "Q"],
    ["Q", "Q", "Q", "Q"]
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
          child: Container(
        child: Column(
          children: [
            SizedBox(height: 70),
            Text(
              'Characters',
              style: TextStyle(fontSize: 36, color: Colors.white),
            ),
            Expanded(
              child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.all(10),
                  shrinkWrap: true,
                  itemCount: input.length,
                  itemBuilder: (BuildContext context, int index) {
                    return CharacterRow(
                      input: input[index],
                    );
                  }),
            )
          ],
        ),
      )),
    );
  }
}

// ignore: must_be_immutable
class CharacterRow extends StatefulWidget {

  final List<String> input;

  String char1 , char2, char3, char4;

  CharacterRow({this.input}) {
    this.char1 = input[0];
    this.char2 = input[1];
    this.char3 = input[2];
    this.char4 = input[3];
  }

  _CharacterRowState createState() => _CharacterRowState();
}

class _CharacterRowState extends State<CharacterRow> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CharacterContainer(nameChar: widget.char1),
          CharacterContainer(nameChar: widget.char2),
          CharacterContainer(nameChar: widget.char3),
          CharacterContainer(nameChar: widget.char4),
        ],
      ),
    );
  }
}

class CharacterContainer extends StatelessWidget {
  final String nameChar;
  const CharacterContainer({this.nameChar = ""});

  @override
  Widget build(BuildContext context) {
    String nameText;
    if (nameChar == "Q") {
      nameText = "???";
    } else {
      nameText = nameChar + ' Cat';
    }

    return Column(
      children: [
        InkWell(
          onTap: () {
            Navigator.of(context).push(CustomPageRoute(CharacterOne(nameChar: nameChar,)));
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
              child: Image.asset("assets/images/kittenIcon" + nameChar + ".png"),
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

class CustomPageRoute<T> extends PageRoute<T> {
  CustomPageRoute(this.child);
  @override
  // TODO: implement barrierColor
  Color get barrierColor => Colors.black.withOpacity(0.01);

  @override
  String get barrierLabel => null;
  
  @override
  // TODO: implement opaque
  bool get opaque => false;

  final Widget child;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => Duration(milliseconds: 500);
}