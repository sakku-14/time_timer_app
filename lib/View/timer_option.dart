import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimerOption extends StatelessWidget {
  const TimerOption(
      {Key? key,
      required this.leftTime,
      required this.soundOn,
      required this.vibrationOn,
      required this.displayTimeOn,
      required this.changeSoundOn,
      required this.changeVibrationOn,
      required this.changeDisplayTimeOn})
      : super(key: key);
  final DateTime leftTime;
  final bool soundOn;
  final bool vibrationOn;
  final bool displayTimeOn;
  final Function changeSoundOn;
  final Function changeVibrationOn;
  final Function changeDisplayTimeOn;

  String getDisplayTime(DateTime leftTime) {
    var dateFormat = DateFormat('HH:mm:ss');
    return dateFormat.format(leftTime);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.cyan.shade50,
      child: Column(
        children: [
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () => changeSoundOn(),
                  icon: soundOn
                      ? const Icon(Icons.notifications_rounded)
                      : const Icon(Icons.notifications_off_rounded),
                ),
                IconButton(
                  onPressed: () => changeVibrationOn(),
                  icon: vibrationOn
                      ? const Icon(Icons.edgesensor_high_rounded)
                      : const Icon(Icons.edgesensor_low_rounded),
                ),
                IconButton(
                  onPressed: () => changeDisplayTimeOn(),
                  icon: displayTimeOn
                      ? const Icon(Icons.access_time_rounded)
                      : const Icon(Icons.history_toggle_off_rounded),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 8,
            child: Center(
              child:
                  displayTimeOn ? Text(getDisplayTime(leftTime)) : Container(),
            ),
          ),
        ],
      ),
    );
  }
}
