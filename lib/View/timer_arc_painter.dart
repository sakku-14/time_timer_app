import 'dart:math';

import 'package:flutter/material.dart';

class TimerArcPainter extends CustomPainter {
  TimerArcPainter(this.globalKey, this.minutes);
  late GlobalKey globalKey;
  late int minutes;

  @override
  void paint(Canvas canvas, Size size) {
    var arcPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill
      ..strokeWidth = 5;

    var minSize = globalKey.currentContext!.size!.width >
            globalKey.currentContext!.size!.height
        ? globalKey.currentContext!.size!.height
        : globalKey.currentContext!.size!.width;
    minSize = minSize * 0.8;

    final fin = minutes * 2 * pi / 60;
    const start = -1 * pi / 2;
    canvas.drawArc(
        Rect.fromCircle(center: const Offset(0, 0), radius: minSize / 2),
        start,
        -fin,
        true,
        arcPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
