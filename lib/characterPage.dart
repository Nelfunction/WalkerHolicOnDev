import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'backgroundOne.dart';
import 'characterOne.dart';
import 'logic/global.dart';

class CharacterPage extends StatefulWidget {
  @override
  _CharacterPageState createState() => _CharacterPageState();
}

class _CharacterPageState extends State<CharacterPage> {
  // 개같이 대충 코딩한 부분임.
  // input이 입력받은 데이터임.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 50,
              ),
              Text(
                'Characters',
                style: TextStyle(fontSize: 34, color: Colors.white),
              ),
              ListView.builder(
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.all(10),
                  shrinkWrap: true,
                  itemCount: globalCharacterList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return CharacterRow(
                        globalCharacterList: globalCharacterList[index],
                        index: index);
                  }),
              Text(
                'Backgrounds',
                style: TextStyle(fontSize: 34, color: Colors.white),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BackgroundContainer(
                      nameChar: "pixel_background1",
                      name: "City",
                    ),
                    BackgroundContainer(
                      nameChar: "pixel_background2",
                      name: "Field",
                    ),
                    BackgroundContainer(
                      nameChar: "pixel_background3",
                      name: "Night",
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class CharacterRow extends StatefulWidget {
  int index;
  final List<String> globalCharacterList;

  List<dynamic> temp = globalCharacterListBool;
  List<String> characters = ["Q", "Q", "Q", "Q"];

  CharacterRow({this.globalCharacterList, this.index}) {
    for (int i = 0; i < 4; i++) {
      if (temp[index][i] == true) {
        this.characters[i] = globalCharacterList[i];
      } else {
        this.characters[i] = "Q";
      }
    }
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
          CharacterContainer(nameChar: widget.characters[0]),
          CharacterContainer(nameChar: widget.characters[1]),
          CharacterContainer(nameChar: widget.characters[2]),
          CharacterContainer(nameChar: widget.characters[3]),
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
            Navigator.of(context).push(CustomPageRoute(CharacterOne(
              nameChar: nameChar,
            )));
          },
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white, width: 4),
                color: Colors.white.withAlpha(100)),
            margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
            padding: EdgeInsets.all(10),
            child: SizedBox(
              width: 40,
              height: 40,
              child:
                  Image.asset("assets/images/kittenIcon" + nameChar + ".png"),
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

// ignore: must_be_immutable

class BackgroundContainer extends StatelessWidget {
  final String nameChar;
  final String name;
  const BackgroundContainer({this.nameChar, this.name});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            Navigator.of(context).push(CustomPageRoute(BackgroundOne(
              nameChar: nameChar,
              name: name,
            ))); // 배경 설정하기!
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white, width: 4),
              color: Colors.white.withAlpha(100),
            ),
            margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
            padding: EdgeInsets.all(1),
            child: SizedBox(
              width: 90,
              height: 140,
              child: Image.asset(
                "assets/images/" + nameChar + ".jpg",
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Text(
          name,
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
