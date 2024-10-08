import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';

class TimeMachine extends FlameGame {
  late SpriteComponent player;

  @override
  Future<void> onLoad() async {
    // This is where you load your assets and initialize the game
    await super.onLoad();

    // Create a SpriteComponent to display the image
    player = PlayerOnRocket();

    // Add the player component to the game
    add(player);
  }

  @override
  void update(double dt) {
    super.update(dt);
  }

  @override
  void render(Canvas canvas) {
    // Render your game objects on the canvas
    final paint = Paint()..color = const Color(0xFF0A0513); // #5B54CC color
    canvas.drawRect(
      Rect.fromLTWH(0, 0, canvasSize.x, canvasSize.y),
      paint,
    );

    super.render(canvas);
    // canvas.drawRect(
    //     Rect.fromLTWH(100, 100, 100, 100), Paint()..color = Colors.blue);
  }
}

class PlayerOnRocket extends SpriteComponent {
  double rotationSpeed =
      .3; // Speed of rotation (positive for clockwise, negative for counterclockwise)
  double maxAngle = 0.2; // Maximum angle to rotate before changing direction
  double currentRotationDirection =
      1; // 1 for clockwise, -1 for counterclockwise

  PlayerOnRocket() : super(size: Vector2(100, 100), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    // Load the image from assets and create a sprite
    sprite = await Sprite.load('machine.png');
    position = Vector2(200, 400); // Set position on the screen

    // // Create a SpriteComponent to display the image
    // player = SpriteComponent()
    //   ..sprite = playerSprite
    //   ..size = Vector2(100, 100) // Adjust size as needed
    //   ..position = Vector2(50, 50) // Set position of the player
    //   ..anchor = Anchor.center
    //   ..angle = 0;
  }

  @override
  void update(double dt) {
    super.update(dt);
    // Update the angle based on the current direction of rotation
    angle += currentRotationDirection * rotationSpeed * dt;

    // If the player has rotated beyond the maximum angle, reverse the direction
    if (angle > maxAngle || angle < -maxAngle) {
      currentRotationDirection *= -1; // Reverse the rotation direction
    }
  }

  @override
  void render(Canvas canvas) {
    // Render your game objects on the canvas
    super.render(canvas);
    // canvas.drawRect(
    //     Rect.fromLTWH(100, 100, 100, 100), Paint()..color = Colors.blue);
  }
}
