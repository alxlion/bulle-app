import 'package:bulle/components/bubble/blob_painter.dart';
import 'package:bulle/components/bubble/participants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'dart:math' as math;

class BubbleAnimation extends StatefulWidget {
  const BubbleAnimation(
      {required this.width,
      required this.height,
      required this.radius,
      required this.amplitude,
      this.participants = const [],
      super.key});

  final double width;
  final double height;
  final double radius;
  final double amplitude;
  final List participants;

  @override
  State<BubbleAnimation> createState() => BubbleAnimationState();
}

class BubbleAnimationState extends State<BubbleAnimation> with SingleTickerProviderStateMixin {
  late final Ticker _ticker;

  late final Offset _center;

  late List _points;
  final int _nbPoints = 7;

  @override
  void initState() {
    super.initState();

    _center = Offset(widget.width / 2, widget.height / 2);

    _ticker = createTicker((elapsed) {
      setState(() {});
    });

    _ticker.start();

    initPoints();
  }

  void initPoints() {
    _points = List.generate(_nbPoints, (i) {
      final theta = i * 2 * math.pi / _nbPoints;
      final originX = _center.dx + widget.radius * math.cos(theta);
      final originY = _center.dy + widget.radius * math.sin(theta);
      return {
        'id': i,
        'x': originX,
        'y': originY,
        'originX': originX,
        'originY': originY,
        'noiseOffsetX': math.Random().nextDouble() * widget.radius,
        'noiseOffsetY': math.Random().nextDouble() * widget.radius,
      };
    });
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        CustomPaint(
          painter: BlobPainter(points: _points, amplitude: widget.amplitude),
          child: SizedBox(width: widget.width, height: widget.height),
        ),
        widget.participants.isNotEmpty ? Participants(participants: widget.participants) : Container(),
      ],
    );
  }
}
