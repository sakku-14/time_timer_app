import 'package:flutter/material.dart';

class TimerOptionIconButton extends StatelessWidget {
  const TimerOptionIconButton(
      {Key? key,
      required this.stateFlag,
      required this.stateTrueIcon,
      required this.stateFalseIcon,
      required this.onPressedFunction})
      : super(key: key);
  final bool stateFlag;
  final Icon stateTrueIcon;
  final Icon stateFalseIcon;
  final Function onPressedFunction;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => onPressedFunction(),
      icon: stateFlag ? stateTrueIcon : stateFalseIcon,
    );
  }
}
