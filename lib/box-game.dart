import 'dart:ui';
import 'package:flame/game.dart';
import 'package:flame/spritesheet.dart';
import 'package:flame/position.dart';
import 'package:flutter/cupertino.dart';
import 'package:flame/text_config.dart';
import 'package:flutter/material.dart';

var player;

class MyGame extends BaseGame {
  Size screenSize;

  Position _size = Position(150, 150);
  int characternum=1;

  MyGame(double input,int character) {
    _size.x = input;
    _size.y = input;
    characternum=character;
  }

  void resize(Size size) {
    screenSize = size;
    super.resize(size);
  }

  // Create Animation with SpriteSheet.
  static final spriteSheet = SpriteSheet(
    imageName: 'Skeleton_Walk.png',
    textureWidth: 22,
    textureHeight: 33,
    columns: 13,
    rows: 1,
  );

  static final myBackground1 = SpriteSheet(
    imageName: 'pixel_background1.jpg',
    textureWidth: 2584,
    textureHeight: 1080,
    columns: 1,
    rows: 1,
  );


  static final myBackground2 = SpriteSheet(
    imageName: 'pixel_background2.jpg',
    textureWidth: 2584,
    textureHeight: 1080,
    columns: 1,
    rows: 1,
  );

  static final character1 = SpriteSheet(
    imageName: 'character1.png',
    textureWidth: 160,
    textureHeight: 160,
    columns: 4,
    rows: 1,
  );

  static final character2 = SpriteSheet(
    imageName: 'character2.png',
    textureWidth: 160,
    textureHeight: 160,
    columns: 4,
    rows: 1,
  );



  final animation = spriteSheet.createAnimation(0, stepTime: 0.05);
  final kitten_ani1 = character1.createAnimation(0, stepTime: 0.1);
  final background1 = myBackground1.createAnimation(0, stepTime: 0.05);

  final kitten_ani2 = character2.createAnimation(0, stepTime: 0.1);
  final background2 = myBackground2.createAnimation(0, stepTime: 0.05);


  final TextConfig config = TextConfig(
      fontSize: 30.0, fontFamily: 'Awesome Font', color: Colors.white);
  final TextConfig config2 = TextConfig(
      fontSize: 25.0, fontFamily: 'Awesome Font', color: Colors.white);

  // Control Render Animations
  void changePosition(double x, double y) {}

  List<Position> positions = [
    Position(50, 220),
    Position(20, 50),
    Position(40, 70)
  ];
  Position position_skel = Position(0, 220);

  Position background_p = Position(0, 0);

  @override
  void render(Canvas canvas) {
    debugPrint('$characternum');
    if(characternum==1)
      {
        background1.getSprite().renderPosition(canvas, background_p,
            size: Position(2584 / (1080 / screenSize.height), screenSize.height));
        kitten_ani1.getSprite().renderPosition(
            canvas,
            Position((screenSize.width - _size.x) / 2,
                (screenSize.height - _size.y - 70)),
            size: _size);

      }
    else if(characternum==2)
      {
        background2.getSprite().renderPosition(canvas, background_p,
            size: Position(2584 / (1080 / screenSize.height), screenSize.height));
        kitten_ani2.getSprite().renderPosition(
            canvas,
            Position((screenSize.width - _size.x) / 2,
                (screenSize.height - _size.y - 70)),
            size: _size);

      }

  }

  @override
  void update(double t) {

    if(characternum==1)
    {
      kitten_ani1.update(t);
    }
    else if(characternum==2)
    {
      kitten_ani2.update(t);
    }
    background_p.x -= 5;
    if (background_p.x < -(1920 / (1080 / screenSize.height))) {
      background_p.x = 0;
    }
    //print(background_p.x.toString() +"\n");
  }
}
