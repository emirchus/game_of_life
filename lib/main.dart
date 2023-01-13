import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:game_of_life/game.dart';

void main() {
  final Game game = LiveGame();

  runApp(
    GameWidget(game: game),
  );
}
