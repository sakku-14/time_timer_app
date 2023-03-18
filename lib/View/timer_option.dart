import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:time_timer_app/View/timer_option_icon_button.dart';

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
  final Future<bool> soundOn;
  final Future<bool> vibrationOn;
  final Future<bool> displayTimeOn;
  final Function changeSoundOn;
  final Function changeVibrationOn;
  final Function changeDisplayTimeOn;

  String get getDisplayTime {
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
                TimerOptionIconButton(
                    stateFlag: soundOn,
                    stateTrueIcon: const Icon(Icons.notifications_rounded),
                    stateFalseIcon: const Icon(Icons.notifications_off_rounded),
                    onPressedFunction: changeSoundOn),
                TimerOptionIconButton(
                    stateFlag: vibrationOn,
                    stateTrueIcon: const Icon(Icons.edgesensor_high_rounded),
                    stateFalseIcon: const Icon(Icons.edgesensor_low_rounded),
                    onPressedFunction: changeVibrationOn),
                TimerOptionIconButton(
                    stateFlag: displayTimeOn,
                    stateTrueIcon: const Icon(Icons.access_time_rounded),
                    stateFalseIcon:
                        const Icon(Icons.history_toggle_off_rounded),
                    onPressedFunction: changeDisplayTimeOn),
              ],
            ),
          ),
          Expanded(
            flex: 8,
            child: FutureBuilder<bool>(
              future: displayTimeOn,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return const CircularProgressIndicator();
                  case ConnectionState.active:
                  case ConnectionState.done:
                    if (snapshot.hasData) {
                      return Center(
                        child: snapshot!.data!
                            ? Text(getDisplayTime)
                            : Container(),
                      );
                    } else {
                      return Container();
                    }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
