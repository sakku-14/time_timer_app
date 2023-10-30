import 'package:flutter/material.dart';
import 'package:time_timer_app/View/timer_arc.dart';
import 'package:time_timer_app/View/timer_drag_area.dart';

class TimerDial extends StatelessWidget {
  TimerDial({
    Key? key,
    required this.leftTime,
    required this.setMinutes,
    required this.minuteForArc,
  }) : super(key: key);
  final DateTime leftTime;
  final int minuteForArc;
  final Function setMinutes;

  final GlobalKey globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Stack(
      key: globalKey,
      children: [
        Center(
          child: TimerArc(
            globalKey: globalKey,
            minutes: minuteForArc,
          ),
        ),
        Center(
          child: TimerDragArea(
            globalKey: globalKey,
            setMinutes: setMinutes,
          ),
        ),
      ],
    );
  }
}
