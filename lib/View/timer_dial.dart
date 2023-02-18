import 'package:flutter/material.dart';

class TimerDial extends StatelessWidget {
  const TimerDial({Key? key, required this.leftTime}) : super(key: key);
  final DateTime leftTime;

  @override
  Widget build(BuildContext context) {
    return Text(leftTime.toString());
  }
}
