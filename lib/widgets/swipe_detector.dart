import 'package:flutter/material.dart';

class SwipeDetector extends StatefulWidget {
  final Widget child;
  final Function onSwipeLeft;
  final Function onSwipeRight;

  SwipeDetector({
    required this.child,
    required this.onSwipeLeft,
    required this.onSwipeRight,
  });

  @override
  _SwipeDetectorState createState() => _SwipeDetectorState();
}

class _SwipeDetectorState extends State<SwipeDetector> {
  Offset? _initialPosition;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragStart: (details) {
        _initialPosition = details.globalPosition;
      },
      onHorizontalDragUpdate: (details) {
        if (_initialPosition != null) {
          final dx = details.globalPosition.dx - _initialPosition!.dx;

          if (dx > 0) {
            // Right swipe
            widget.onSwipeRight();
          } else {
            // Left swipe
            widget.onSwipeLeft();
          }

          _initialPosition = null;
        }
      },
      child: widget.child,
    );
  }
}
