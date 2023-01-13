import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flutter/material.dart';
import 'package:game_of_life/game.dart';

class Live extends PositionComponent with HasGameRef<LiveGame>, TapCallbacks {
  bool isAlive = false;

  @override
  void onTapUp(TapUpEvent event) {
    if (!game.isPlaying) toggleLive();
    super.onTapUp(event);
  }

  void toggleLive() {
    isAlive = !isAlive;
  }

  @override
  void render(Canvas canvas) {
    final stroke = Paint()
      ..color = Colors.grey
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    canvas.drawRect(
      size.toRect(),
      stroke,
    );

    if (isAlive) {
      final fill = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill;

      canvas.drawRect(
        size.toRect(),
        fill,
      );
    }

    super.render(canvas);
  }
}
