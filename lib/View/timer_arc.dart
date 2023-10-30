import 'package:flutter/material.dart';
import 'package:time_timer_app/View/timer_arc_painter.dart';

class TimerArc extends StatelessWidget {
  const TimerArc({Key? key, required this.globalKey, required this.minutes})
      : super(key: key);
  final GlobalKey<State<StatefulWidget>> globalKey;
  final int minutes;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      child: Center(
        child: Image.asset('images/Timer.png'),
      ),
      foregroundPainter: TimerArcPainter(globalKey, minutes),
    );
  }
}
