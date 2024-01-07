import 'package:flutter/material.dart';
import 'dart:math' as math;

class CircleLayoutDelegate extends MultiChildLayoutDelegate {
  CircleLayoutDelegate({required this.itemCount, required this.wrapRadius, required this.shapeRadius});

  final int itemCount;

  final double wrapRadius;
  final double shapeRadius;

  Offset _center = Offset.zero;

  @override
  void performLayout(Size size) {
    _center = Offset(size.width / 2, size.height / 2);

    layoutChild(
      0,
      BoxConstraints(maxHeight: shapeRadius * 2, maxWidth: shapeRadius * 2),
    );
    positionChild(0, Offset(_center.dx - (shapeRadius / 2), _center.dy - (shapeRadius / 2)));

    for (int i = 0; i < itemCount - 1; i++) {
      final theta = i * 2 * math.pi / (itemCount - 1);
      final x = _center.dx + wrapRadius * math.cos(theta) - (shapeRadius / 2);
      final y = _center.dy + wrapRadius * math.sin(theta) - (shapeRadius / 2);

      layoutChild(
        i + 1,
        BoxConstraints(maxHeight: shapeRadius * 2, maxWidth: shapeRadius * 2),
      );

      positionChild(i + 1, Offset(x, y));
    }
  }

  @override
  bool shouldRelayout(CircleLayoutDelegate oldDelegate) {
    return itemCount != oldDelegate.itemCount;
  }
}
