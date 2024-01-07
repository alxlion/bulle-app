import 'package:bulle/config/app_colors.dart';
import 'package:fast_noise/fast_noise.dart';
import 'package:flutter/material.dart';

class BlobPainter extends CustomPainter {
  final ValueNoise _noise = ValueNoise();
  final double _noiseStep = 0.1;

  final List points;
  final double amplitude;

  BlobPainter({required this.points, this.amplitude = 1});

  @override
  void paint(Canvas canvas, Size size) {
    for (var point in points) {
      var nX = _noise.getNoise2(point['noiseOffsetX'], point['noiseOffsetX']);
      var nY = _noise.getNoise2(point['noiseOffsetY'], point['noiseOffsetY']);

      var x = map(nX, -1, 1, point['originX'] - (amplitude * 10), point['originX'] + (amplitude * 10));
      var y = map(nY, -1, 1, point['originY'] - (amplitude * 10), point['originY'] + (amplitude * 10));

      point['x'] = x;
      point['y'] = y;

      point['noiseOffsetX'] += _noiseStep;
      point['noiseOffsetY'] += _noiseStep;
    }

    var offsetPoints = points.map((point) => Offset(point['x'], point['y'])).toList();

    Iterable<Offset> firsts = List.from(offsetPoints.getRange(0, 2));
    Iterable<Offset> lasts = List.from(offsetPoints.getRange(offsetPoints.length - 2, offsetPoints.length));

    offsetPoints.insert(0, lasts.last);
    offsetPoints.insert(0, lasts.first);

    offsetPoints.add(firsts.first);
    offsetPoints.add(firsts.last);

    final spline = CatmullRomSpline(offsetPoints, tension: 0);

    final path = Path();
    path.moveTo(offsetPoints[0].dx, offsetPoints[0].dy);

    for (double t = 0.0; t <= 1.0; t += 0.01) {
      path.lineTo(spline.transform(t).dx, spline.transform(t).dy);
    }

    final paint = Paint()
      ..color = AppColors.primaryColor
      ..style = PaintingStyle.fill
      ..strokeWidth = 2.0;

    canvas.drawPath(path, paint);
  }

  double map(n, start1, end1, start2, end2) {
    return ((n - start1) / (end1 - start1)) * (end2 - start2) + start2;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
