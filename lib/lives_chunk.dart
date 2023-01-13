import 'package:collection/collection.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:game_of_life/live.dart';

class LivesChunk extends PositionComponent {
  @override
  void onMount() {
    for (int k = 0; k < 3; k++) {
      for (int l = 0; l < 3; l++) {
        add(
          Live()
            ..size = Vector2(
              width / 3,
              height / 3,
            )
            ..position = Vector2(
              k.toDouble() * width / 3,
              l.toDouble() * height / 3,
            ),
        );
      }
    }
    super.onMount();
  }

  @override
  void render(Canvas canvas) {
    final stroke = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    canvas.drawRect(
      size.toRect(),
      stroke,
    );

    super.render(canvas);
  }

  void checkForLives(List<LivesChunk> brothers) {
    final livesChildren = children.query<Live>();

    final allPositionComponents = <Live>[
      ...livesChildren,
      // ...brothers.expand((element) => element.children.query<Live>()),
    ];

    for (var i = 0; i < allPositionComponents.length; i++) {
      List<Live?> neighbors = [];

      final current = allPositionComponents[i];

      final left = allPositionComponents.firstWhereOrNull((element) => element.x == current.x - current.size.x && element.y == current.y);

      final right = allPositionComponents.firstWhereOrNull((element) => element.x == current.x + current.size.x && element.y == current.y);

      final top = allPositionComponents.firstWhereOrNull((element) => element.x == current.x && element.y == current.y - current.size.y);

      final bottom = allPositionComponents.firstWhereOrNull((element) => element.x == current.x && element.y == current.y + current.size.y);

      final topLeft = allPositionComponents.firstWhereOrNull((element) => element.x == current.x - current.size.x && element.y == current.y - current.size.y);

      final topRight = allPositionComponents.firstWhereOrNull((element) => element.x == current.x + current.size.x && element.y == current.y - current.size.y);

      final bottomLeft = allPositionComponents.firstWhereOrNull((element) => element.x == current.x - current.size.x && element.y == current.y + current.size.y);

      final bottomRight = allPositionComponents.firstWhereOrNull((element) => element.x == current.x + current.size.x && element.y == current.y + current.size.y);

      neighbors.add(left);
      neighbors.add(right);

      neighbors.add(top);
      neighbors.add(bottom);
      neighbors.add(topLeft);
      neighbors.add(topRight);

      neighbors.add(bottomLeft);
      neighbors.add(bottomRight);

      final aliveNeighbors = neighbors.where((element) => element != null).where((element) => (element as Live).isAlive).toList();

      if (current.isAlive) {
        if (aliveNeighbors.length < 2 || aliveNeighbors.length > 3) {
          current.toggleLive();
        }
      } else {
        if (aliveNeighbors.length == 3) {
          current.toggleLive();
        }
      }
    }
  }
}
