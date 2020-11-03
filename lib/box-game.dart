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
  MyGame(double input) {
    _size.x = input;
    _size.y = input;
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

  static final myBackground = SpriteSheet(
    imageName: 'pixel_background2.jpg',
    textureWidth: 2584,
    textureHeight: 1080,
    columns: 1,
    rows: 1,
  );

  static final myKitten = SpriteSheet(
    imageName: 'kitten.png',
    textureWidth: 160,
    textureHeight: 160,
    columns: 4,
    rows: 1,
  );

  static final sky = SpriteSheet(
    imageName: 'sky.png',
    textureWidth: 270,
    textureHeight: 320,
    columns: 1,
    rows: 1,
  );

  static final way = SpriteSheet(
    imageName: 'way.png',
    textureWidth: 630,
    textureHeight: 320,
    columns: 1,
    rows: 1,
  );

  static final mountain = SpriteSheet(
    imageName: 'mountain.png',
    textureWidth: 630,
    textureHeight: 320,
    columns: 1,
    rows: 1,
  );

  static final cloud = SpriteSheet(
    imageName: 'cloud.png',
    textureWidth: 630,
    textureHeight: 320,
    columns: 1,
    rows: 1,
  );

  final animation = spriteSheet.createAnimation(0, stepTime: 0.05);
  final kitten_ani = myKitten.createAnimation(0, stepTime: 0.1);
  final background = myBackground.createAnimation(0, stepTime: 0.05);

  final sky_sprite = sky.createAnimation(0, stepTime: 0.05);
  final way_sprite = way.createAnimation(0, stepTime: 0.05);
  final cloud_sprite = cloud.createAnimation(0, stepTime: 0.05);
  final mountain_sprite = mountain.createAnimation(0, stepTime: 0.05);

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

  Position sky_p = Position(0, 0);
  Position way_p = Position(0, 0);
  Position mountain_p = Position(0, 0);
  Position cloud_p = Position(0, 0);

  @override
  void render(Canvas canvas) {
    sky_sprite.getSprite().renderPosition(canvas, sky_p,
        size: Position(270 / (320 / screenSize.height), screenSize.height));

    cloud_sprite.getSprite().renderPosition(canvas, cloud_p,
        size: Position(630 / (320 / screenSize.height), screenSize.height));
    mountain_sprite.getSprite().renderPosition(canvas, mountain_p,
        size: Position(630 / (320 / screenSize.height), screenSize.height));
    way_sprite.getSprite().renderPosition(canvas, way_p,
        size: Position(630 / (320 / screenSize.height), screenSize.height));

    /*
    background.getSprite().renderPosition(canvas, background_p,
        size: Position(2584 / (1080 / screenSize.height), screenSize.height));*/
    kitten_ani.getSprite().renderPosition(
        canvas,
        Position((screenSize.width - _size.x) / 2,
            (screenSize.height - _size.y - 70)),
        size: _size);
  }

  @override
  void update(double t) {
    kitten_ani.update(t);
    cloud_p.x -= 1;
    mountain_p.x -= 2;
    way_p.x -= 5;
    if (cloud_p.x < -(360 / (320 / screenSize.height))) {
      cloud_p.x = 0;
    }
    if (mountain_p.x < -(360 / (320 / screenSize.height))) {
      mountain_p.x = 0;
    }
    if (way_p.x < -(360 / (320 / screenSize.height))) {
      way_p.x = 0;
    }
    //print(background_p.x.toString() +"\n");
  }
}
