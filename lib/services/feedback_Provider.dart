import 'package:flutter/material.dart';

enum SwipingDirection { left, right, none }

class FeedbackPositionProvider extends ChangeNotifier {
  double _dx = 0.0; // Tracks the swipe distance
  SwipingDirection _swipingDirection = SwipingDirection.none;

  SwipingDirection get swipingDirection => _swipingDirection;

  void resetPosition() {
    _dx = 0.0;
    _swipingDirection = SwipingDirection.none;
    notifyListeners();
  }

  void updatePosition(double deltaX) {
    _dx += deltaX;

    if (_dx > 0) {
      _swipingDirection = SwipingDirection.right;
    } else if (_dx < 0) {
      _swipingDirection = SwipingDirection.left;
    } else {
      _swipingDirection = SwipingDirection.none;
    }

    notifyListeners();
  }
}
