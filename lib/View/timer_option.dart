import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:time_timer_app/View/timer_option_icon_button.dart';

class TimerOption extends StatelessWidget {
  const TimerOption(
      {Key? key,
      required this.leftTime,
      required this.notificationOn,
      required this.vibrationOn,
      required this.displayTimeOn,
      required this.changeNotificationOn,
      required this.changeVibrationOn,
      required this.changeDisplayTimeOn})
      : super(key: key);
  final DateTime leftTime;
  final bool notificationOn;
  final bool vibrationOn;
  final bool displayTimeOn;
  final Function changeNotificationOn;
  final Function changeVibrationOn;
  final Function changeDisplayTimeOn;

  String get getDisplayTime {
    var dateFormat = DateFormat('HH:mm:ss');
    return dateFormat.format(leftTime);
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;
    final iconButtonFlex = isLandscape ? 5 : 2;

    return Container(
      color: Colors.grey.shade300,
      child: Column(
        children: [
          Expanded(
            flex: iconButtonFlex,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TimerOptionIconButton(
                    stateFlag: notificationOn,
                    stateTrueIcon: const Icon(Icons.notifications_rounded),
                    stateFalseIcon: const Icon(Icons.notifications_off_rounded),
                    onPressedFunction: changeNotificationOn),
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
              flex: 10 - iconButtonFlex,
              child: Center(
                child: displayTimeOn
                    ? SizedBox.expand(
                        child: Center(
                          child: Text(
                            getDisplayTime,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: isLandscape ? 30 : 50),
                          ),
                        ),
                      )
                    : Container(),
              )),
        ],
      ),
    );
  }
}
