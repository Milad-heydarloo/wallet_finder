import 'package:flame/game.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(GameWidget(game: BilliardPhysicsGame()));
}

class BilliardPhysicsGame extends Forge2DGame {
  @override
  void onTap() {
    add(Ball(Vector2(5, 5))); // افزودن توپ به صفحه
  }

  @override
  void onLoad() {
    add(Ground());
    add(Ball(Vector2(5, 10)));
  }
}

class Ball extends BodyComponent {
  final Vector2 position;

  Ball(this.position);

  @override
  Body createBody() {
    final shape = CircleShape()..radius = 1.0;
    final bodyDef = BodyDef()
      ..position = position
      ..type = BodyType.dynamic;

    final fixtureDef = FixtureDef(shape)
      ..restitution = 0.8 // خاصیت برگشتی توپ
      ..friction = 0.5;

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}

class Ground extends BodyComponent {
  @override
  Body createBody() {
    final shape = EdgeShape()
      ..set(Vector2(-10, 0), Vector2(10, 0));
    final bodyDef = BodyDef();
    return world.createBody(bodyDef)..createFixtureFromShape(shape);
  }
}
