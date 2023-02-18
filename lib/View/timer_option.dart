import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimerOption extends StatelessWidget {
  const TimerOption({Key? key, required this.leftTime}) : super(key: key);
  final DateTime leftTime;

  String getDisplayTime(DateTime leftTime) {
    var dateFormat = DateFormat('HH:mm:ss');
    return dateFormat.format(leftTime);
  }

  @override
  Widget build(BuildContext context) {
    return Text(getDisplayTime(leftTime));
  }
}
