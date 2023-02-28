import 'package:flutter/material.dart';
import 'package:time_timer_app/View/timer_dial.dart';
import 'package:time_timer_app/View/timer_option.dart';

class TimerBody extends StatelessWidget {
  const TimerBody(
      {Key? key,
      required this.leftTime,
      required this.soundOn,
      required this.vibrationOn,
      required this.displayTimeOn,
      required this.changeSoundOn,
      required this.changeVibrationOn,
      required this.changeDisplayTimeOn})
      : super(key: key);
  final Future<DateTime> leftTime;
  final Future<bool> soundOn;
  final Future<bool> vibrationOn;
  final Future<bool> displayTimeOn;
  final Function changeSoundOn;
  final Function changeVibrationOn;
  final Function changeDisplayTimeOn;

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
              soundOn: soundOn,
              vibrationOn: vibrationOn,
              displayTimeOn: displayTimeOn,
              changeSoundOn: changeSoundOn,
              changeVibrationOn: changeVibrationOn,
              changeDisplayTimeOn: changeDisplayTimeOn,
            ),
          )
        ],
      ),
    );
  }
}
