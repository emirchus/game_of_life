import 'package:collection/collection.dart';
import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:game_of_life/live.dart';
import 'package:game_of_life/lives_chunk.dart';

class LiveGame extends FlameGame with HasTappableComponents, KeyboardEvents {
  TextPaint textPaint = TextPaint(
    style: const TextStyle(
      fontSize: 24.0,
    ),
  );

  FpsTextComponent fpsTextComponent = FpsTextComponent(position: Vector2(10, 10), anchor: Anchor.topLeft);

  bool isPlaying = false;

  void buildGrid() {
    removeWhere((component) => component is LivesChunk);
    final Size size = this.size.toSize();

    const int quantity = 20;

    final double width = size.width / quantity;
    final double height = size.height / quantity;

    // Chunk of 9 grids (3x3)
    const int chunkQuantity = 3;

    const int chunkCount = (chunkQuantity * quantity) ~/ chunkQuantity;

    for (int i = 0; i < chunkCount; i++) {
      for (int j = 0; j < chunkCount; j++) {
        add(
          LivesChunk()
            ..size = Vector2(width * chunkQuantity, height * chunkQuantity)
            ..position = Vector2(i.toDouble() * width * chunkQuantity, j.toDouble() * height * chunkQuantity),
        );
      }
    }
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    buildGrid();

    add(fpsTextComponent);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    textPaint.render(canvas, "Game is: ${isPlaying ? "ON" : "OFF"}", Vector2(size.x - 20, 10), anchor: Anchor.topRight);
  }

  @override
  void update(double dt) {
    if (isPlaying) {
      playGame();
    }

    super.update(dt);
  }

  void playGame() {
    final allPositionComponents = children.query<LivesChunk>();

    for (final chunk in allPositionComponents) {
      List<LivesChunk?> neighbors = [];

      final x = chunk.position.x / chunk.size.x;
      final y = chunk.position.y / chunk.size.y;

      final left = x - 1;

      if (left >= 0) {
        neighbors.add(allPositionComponents.firstWhereOrNull((element) => element.position.x == left * chunk.size.x && element.position.y == y * chunk.size.y));
      }

      final right = x + 1;
      if (right < 3) {
        neighbors.add(allPositionComponents.firstWhereOrNull((element) => element.position.x == right * chunk.size.x && element.position.y == y * chunk.size.y));
      }

      final top = y - 1;
      if (top >= 0) {
        neighbors.add(allPositionComponents.firstWhereOrNull((element) => element.position.x == x * chunk.size.x && element.position.y == top * chunk.size.y));
      }

      final bottom = y + 1;
      if (bottom < 3) {
        neighbors.add(allPositionComponents.firstWhereOrNull((element) => element.position.x == x * chunk.size.x && element.position.y == bottom * chunk.size.y));
      }

      chunk.checkForLives(neighbors.whereType<LivesChunk>().toList());
    }
  }

  @override
  KeyEventResult onKeyEvent(
    RawKeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    final isKeyDown = event is RawKeyDownEvent;

    final isSpace = keysPressed.contains(LogicalKeyboardKey.space);

    final isR = keysPressed.contains(LogicalKeyboardKey.keyR);

    if (isSpace && isKeyDown) {
      isPlaying = !isPlaying;
      return KeyEventResult.handled;
    }

    if (isR && isKeyDown) {
      isPlaying = false;
      buildGrid();
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }
}
