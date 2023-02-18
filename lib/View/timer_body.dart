import 'package:flutter/material.dart';
import 'package:time_timer_app/View/timer_dial.dart';
import 'package:time_timer_app/View/timer_option.dart';

class TimerBody extends StatelessWidget {
  const TimerBody(
      {Key? key,
      required this.leftTime,
      required this.soundOn,
      required this.vibrationOn,
      required this.displayTimeOn})
      : super(key: key);
  final DateTime leftTime;
  final bool soundOn;
  final bool vibrationOn;
  final bool displayTimeOn;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            flex: 7,
            child: Center(
              child: TimerDial(
                leftTime: leftTime,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: TimerOption(
              leftTime: leftTime,
            ),
          )
        ],
      ),
    );
  }
}
