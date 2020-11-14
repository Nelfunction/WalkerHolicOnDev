import 'package:flutter/material.dart';
import 'box-game.dart';
import '../logic/format.dart';

class FullGame extends StatefulWidget {
  final Gamecard gamecard;
  FullGame(this.gamecard);

  @override
  _FullGameState createState() => _FullGameState(gamecard);
}

class _FullGameState extends State<FullGame> {
  final Gamecard gamecard;
  _FullGameState(this.gamecard);

  TextStyle inGameStyle = new TextStyle(
      color: Colors.white,
      fontSize: 24,
      fontWeight: FontWeight.w600,
      shadows: [
        Shadow(
            // bottomLeft
            offset: Offset(-1.5, -1.5),
            color: Colors.black),
        Shadow(
            // bottomRight
            offset: Offset(1.5, -1.5),
            color: Colors.black),
        Shadow(
            // topRight
            offset: Offset(1.5, 1.5),
            color: Colors.black),
        Shadow(
            // topLeft
            offset: Offset(-1.5, 1.5),
            color: Colors.black),
      ]);

  @override
  Widget build(BuildContext context) {
    MyGame game = MyGame(gamecard.character, input: 200);

    return Scaffold(
        body: InkWell(
      onTap: () {
        return Navigator.of(context).pop();
      },
      child: Stack(
        children: [
          WillPopScope(
              child: game.widget,
              onWillPop: () async {
                return false;
              }),
          Positioned(
            child: Text(
              gamecard.name,
              style: inGameStyle,
            ),
            left: 20,
            top: 40,
          ),
          Positioned(
            child: Text(
              (gamecard.cardSteps).toString() + " Steps",
              style: inGameStyle,
            ),
            left: 20,
            top: 70,
          ),
        ],
      ),
    ));
  }
}

Route createRoute(Widget a) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => a,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(0.0, 1.0);
      var end = Offset.zero;
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
