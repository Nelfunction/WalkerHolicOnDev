import 'dart:ui';
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';
import 'package:flame/spritesheet.dart';
import 'package:flame/position.dart';
import 'package:flutter/cupertino.dart';
import 'package:flame/text_config.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyGame extends BaseGame {
  Size screenSize;

  Position character_p;

  Position _size = Position(150, 150);
  int background_code;

  String nowCharacter;

  var choosenAnimation;

  // 고양이가 점프할 높이
  int jumpHeightMax = 200;
  int nowJump = 0;
  bool goUp = true;
  double accelator = 15;

  bool isJump = false;

  MyGame(var character, int background_code, {double input = 200}) {
    _size.x = input;
    _size.y = input;
    choosenAnimation = character;
    this.background_code = background_code;
  }

  void resize(Size size) {
    screenSize = size;
    super.resize(size);
    character_p = new Position(((screenSize.width - _size.x) / 2),
        ((screenSize.height - _size.y - 70)));
  }

  // Create Animation with SpriteSheet.
  static final myBackground1 = SpriteSheet(
    imageName: 'pixel_background1.jpg',
    textureWidth: 2584,
    textureHeight: 1080,
    columns: 1,
    rows: 1,
  );

  static var character1 = SpriteSheet(
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

  static final nightsky = SpriteSheet(
    imageName: 'nightsky.png',
    textureWidth: 270,
    textureHeight: 320,
    columns: 1,
    rows: 1,
  );

  static final bridge = SpriteSheet(
    imageName: 'bridge.png',
    textureWidth: 630,
    textureHeight: 320,
    columns: 1,
    rows: 1,
  );

  static final river = SpriteSheet(
    imageName: 'river.png',
    textureWidth: 630,
    textureHeight: 320,
    columns: 1,
    rows: 1,
  );

  static final light = SpriteSheet(
    imageName: 'light.png',
    textureWidth: 630,
    textureHeight: 320,
    columns: 3,
    rows: 1,
  );

  final kitten_ani1 = character1.createAnimation(0, stepTime: 0.1);
  final kitten_ani2 = character2.createAnimation(0, stepTime: 0.1);

  final background1 = myBackground1.createAnimation(0, stepTime: 0.05);

  final sky_sprite = sky.createAnimation(0, stepTime: 0.05);
  final way_sprite = way.createAnimation(0, stepTime: 0.05);
  final cloud_sprite = cloud.createAnimation(0, stepTime: 0.05);
  final mountain_sprite = mountain.createAnimation(0, stepTime: 0.05);

  final nightsky_sprite = nightsky.createAnimation(0, stepTime: 0.05);
  final bridge_sprite = bridge.createAnimation(0, stepTime: 0.05);
  final river_sprite = river.createAnimation(0, stepTime: 0.05);
  final light_sprite = light.createAnimation(0, stepTime: 0.4);

  final TextConfig config = TextConfig(
      fontSize: 30.0, fontFamily: 'Awesome Font', color: Colors.white);
  final TextConfig config2 = TextConfig(
      fontSize: 25.0, fontFamily: 'Awesome Font', color: Colors.white);

  Position position_skel = Position(0, 220);
  Position background_p = Position(0, 0);

  Position sky_p = Position(0, 0);
  Position way_p = Position(0, 0);
  Position mountain_p = Position(0, 0);
  Position cloud_p = Position(0, 0);

  @override
  void render(Canvas canvas) {
    debugPrint("==================== $background_code");
    if (background_code == 1) {
      background1.getSprite().renderPosition(canvas, background_p,
          size: Position(2584 / (1080 / screenSize.height), screenSize.height));
    } else if (background_code == 2) {
      sky_sprite.getSprite().renderPosition(canvas, sky_p,
          size: Position(270 / (320 / screenSize.height), screenSize.height));
      cloud_sprite.getSprite().renderPosition(canvas, cloud_p,
          size: Position(630 / (320 / screenSize.height), screenSize.height));
      mountain_sprite.getSprite().renderPosition(canvas, mountain_p,
          size: Position(630 / (320 / screenSize.height), screenSize.height));
      way_sprite.getSprite().renderPosition(canvas, way_p,
          size: Position(630 / (320 / screenSize.height), screenSize.height));
    } else if (background_code == 3) {
      nightsky_sprite.getSprite().renderPosition(canvas, sky_p,
          size: Position(270 / (320 / screenSize.height), screenSize.height));
      river_sprite.getSprite().renderPosition(canvas, cloud_p,
          size: Position(630 / (320 / screenSize.height), screenSize.height));
      light_sprite.getSprite().renderPosition(canvas, mountain_p,
          size: Position(630 / (320 / screenSize.height), screenSize.height));
      bridge_sprite.getSprite().renderPosition(canvas, way_p,
          size: Position(630 / (320 / screenSize.height), screenSize.height));
    }

    // 캐릭터 렌더링하는 부분
    choosenAnimation
        .getSprite()
        .renderPosition(canvas, character_p, size: _size);
  }

  @override
  void update(double t) {
    if (background_code == 1) {
      background_p.x -= 5;
      if (background_p.x < -(1920 / (1080 / screenSize.height))) {
        background_p.x = 0;
      }
    } else if (background_code == 2) {
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
    } else if (background_code == 3) {
      cloud_p.x -= 2;
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
      light_sprite.update(t);
    }
    choosenAnimation.update(t);

    if (isJump) {
      if (goUp) {
        // 위로 올라가야 함.
        character_p.y -= accelator;
        accelator += 0.7;

        if (character_p.y <= screenSize.height - _size.y - 70 - jumpHeightMax) {
          goUp = false;
        }
      } else {
        character_p.y += accelator;
        accelator -= 0.7;

        if (character_p.y >= screenSize.height - _size.y - 70) {
          character_p.y = screenSize.height - _size.y - 70;
          goUp = true;
          isJump = false;
        }
      }
    }
  }
}
