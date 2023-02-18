import 'package:flutter/material.dart';
import 'package:time_timer_app/View/timer_dial.dart';
import 'package:time_timer_app/View/timer_option.dart';

class TimerBody extends StatelessWidget {
  const TimerBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            flex: 7,
            child: TimerDial(),
          ),
          Expanded(
            flex: 3,
            child: TimerOption(),
          )
        ],
      ),
    );
  }
}
