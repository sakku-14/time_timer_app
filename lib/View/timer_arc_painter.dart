import 'dart:math';

import 'package:flutter/material.dart';

class TimerArcPainter extends CustomPainter {
  TimerArcPainter(this.globalKey, this.minutes);
  late GlobalKey globalKey;
  late int minutes;

  @override
  void paint(Canvas canvas, Size size) {
    var minSize = globalKey.currentContext!.size!.width >
            globalKey.currentContext!.size!.height
        ? globalKey.currentContext!.size!.height
        : globalKey.currentContext!.size!.width;
    minSize = minSize * 0.9;
    final xCenter = globalKey.currentContext!.size!.width / 2;
    final yCenter = globalKey.currentContext!.size!.height / 2;

    var arcPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill
      ..strokeWidth = 5;

    final fin = minutes * 2 * pi / 60;
    const start = -1 * pi / 2;
    canvas.drawArc(
        Rect.fromCircle(center: Offset(xCenter, yCenter), radius: minSize / 2),
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
