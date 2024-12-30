import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/direction_enum.dart';
import '../model/o_player_model.dart';
import '../model/player_model.dart';
import '../model/x_player_model.dart';
import 'dart:convert';

class GameScreenViewmodel with ChangeNotifier {
  String gameID = "10";
  Player xPlayer = XPlayer();
  Player oPlayer = OPlayer();
  bool isFirstPlayer = true;
  Map<int, Widget> widgets = {};
  Map<int, bool> isPositionFill = {};
  Curve curve = Curves.linear;
  Size moveTo = const Size(0, 0);
  Size lineTo = const Size(0, 0);
  Direction direction = Direction.drawColumn;
  final double verticalDistance = 0.165;
  final double horizontalDistance = 0.19;
  bool canTappable = true;
  Map<int, AnimationController> controllers = {};

  void setPlayerName(Player player, String newName) {
    player.userName = newName;
    notifyListeners();
  }

  void setGameID(String id) {
    gameID = id;
    notifyListeners();
  }

  Future<void> saveGame() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    Map<String, String> game = {};

    game["x"] = const JsonEncoder().convert(xPlayer.toJson());
    game["o"] = const JsonEncoder().convert(oPlayer.toJson());
    var stringGame = const JsonEncoder().convert(game);
    await prefs.setString('game$gameID', stringGame);
  }

  Future<void> loadGame(String id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? stringGame = prefs.getString('game$id');
    Map<String, dynamic> yeniGame = const JsonDecoder().convert(stringGame!);
    xPlayer = XPlayer.fromJson(const JsonDecoder().convert(yeniGame["x"]));
    oPlayer = OPlayer.fromJson(const JsonDecoder().convert(yeniGame["o"]));
    final move = xPlayer.markList.length + oPlayer.markList.length;
    if (move % 2 == 0) {
      isFirstPlayer = true;
    } else {
      isFirstPlayer = false;
    }
    notifyListeners();
  }

  void nextPlayer() {
    isFirstPlayer = !isFirstPlayer;
    notifyListeners();
  }

  void positionFilled(int index) {
    isPositionFill[index] = true;
    notifyListeners();
  }

  void positionEmptied(int index) {
    isPositionFill[index] = false;
    notifyListeners();
  }

  void setCanTappable() {
    canTappable = !canTappable;
    notifyListeners();
  }

  void playerMoved(int index, AnimationController controller) {
    Player player = isFirstPlayer ? xPlayer : oPlayer;
    player.markList.add(index);
    widgets[index] =
        Lottie.asset(player.markPath, controller: controller, repeat: false);
    isPositionFill[index] = true;

    controller.forward();
    notifyListeners();
  }

  void roundIsDone(Player player) {
    xPlayer.markList.removeRange(0, xPlayer.markList.length);
    oPlayer.markList.removeRange(0, oPlayer.markList.length);
    isFirstPlayer = true;
    setCanTappable();
    player.counter++;
    notifyListeners();
  }

  void deleteFirstMove(Player player, AnimationController controller) {
    isPositionFill[player.markList[0]] = false;
    controller.reverse();
    player.markList.removeAt(0);
    notifyListeners();
  }

  void createGame(Map<int, AnimationController> controllers) {
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (xPlayer.markList.contains(3 * i + j)) {
          controllers[3 * i + j]!.forward();
          isPositionFill[3 * i + j] = true;
          widgets[3 * i + j] = Lottie.asset(xPlayer.markPath,
              controller: controllers[3 * i + j], repeat: false);
        } else if (oPlayer.markList.contains(3 * i + j)) {
          controllers[3 * i + j]!.forward();
          isPositionFill[3 * i + j] = true;
          widgets[3 * i + j] = Lottie.asset(oPlayer.markPath,
              controller: controllers[3 * i + j], repeat: false);
        } else {
          isPositionFill[3 * i + j] = false;
          widgets[3 * i + j] = const SizedBox(
            width: 100,
            height: 100,
          );
        }
      }
    }
    notifyListeners();
  }

  void clearGame() {
    canTappable = true;
    moveTo = const Size(0, 0);
    lineTo = const Size(0, 0);
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        isPositionFill[3 * i + j] = false;
        widgets[3 * i + j] = const SizedBox(
          width: 100,
          height: 100,
        );
      }
    }
    notifyListeners();
  }

  void setDirection(Size lineToSize, Size moveToSize, Direction newDirection) {
    lineTo = lineToSize;
    moveTo = moveToSize;
    direction = newDirection;
    notifyListeners();
  }

  bool checkXOX(List<dynamic> markList, int index) {
    // for xox should be have min 3 mark
    if (markList.length < 3) return false;
    // if tapped to left side check right of item
    if ([0, 3, 6].contains(index)) {
      if (markList.contains(index + 1) && markList.contains(index + 2)) {
        setDirection(Size(0.02, index / 9 + verticalDistance),
            Size(1, index / 9 + verticalDistance), Direction.drawRowFromLeft);

        return true;
      }
    }
    // if tapped to mid side check left and right of item
    else if ([1, 4, 7].contains(index)) {
      if (markList.contains(index - 1) && markList.contains(index + 1)) {
        setDirection(Size(1, (index - 1) / 9 + verticalDistance),
            Size(0.02, (index - 1) / 9 + verticalDistance), Direction.drawRow);
        return true;
      }
    }
    // if tapped to right side check left of item
    else if ([2, 5, 8].contains(index)) {
      if (markList.contains(index - 1) && markList.contains(index - 2)) {
        setDirection(Size(1, (index - 2) / 9 + verticalDistance),
            Size(0.02, (index - 2) / 9 + verticalDistance), Direction.drawRow);
        return true;
      }
    }
    // if tapped to top side check bottom of item
    if ([0, 1, 2].contains(index)) {
      if (markList.contains(index + 3) && markList.contains(index + 6)) {
        setDirection(
            Size((0.33 * (index % 3)) + horizontalDistance, 0),
            Size((0.33 * (index % 3)) + horizontalDistance, 0.98),
            Direction.drawColumnFromTop);

        return true;
      }
    }
    // if tapped to mid side check top and bottom of item
    else if ([3, 4, 5].contains(index)) {
      if (markList.contains(index + 3) && markList.contains(index - 3)) {
        setDirection(
            Size((0.33 * (index % 3)) + horizontalDistance, 0.98),
            Size((0.33 * (index % 3)) + horizontalDistance, 0),
            Direction.drawColumn);

        return true;
      }
    }
    // if tapped to bot side check top of item
    else if ([6, 7, 8].contains(index)) {
      if (markList.contains(index - 3) && markList.contains(index - 6)) {
        setDirection(
            Size((0.33 * (index % 6)) + horizontalDistance, 0.98),
            Size((0.33 * (index % 6)) + horizontalDistance, 0),
            Direction.drawColumn);

        return true;
      }
    }

    // cross check
    if (markList.toSet().containsAll([0, 4, 8])) {
      setDirection(
          const Size(1, 0.98), const Size(0.02, 0), Direction.drawCrossFromTop);

      return true;
    } else if (markList.toSet().containsAll([2, 4, 6])) {
      setDirection(
          const Size(1, 1), const Size(0.02, 0.98), Direction.drawCrossFromBot);
      return true;
    }

    return false;
  }
}
