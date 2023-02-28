import 'package:flutter/material.dart';

class TimerOptionIconButton extends StatelessWidget {
  const TimerOptionIconButton(
      {Key? key,
      required this.stateFlag,
      required this.stateTrueIcon,
      required this.stateFalseIcon,
      required this.onPressedFunction})
      : super(key: key);
  final Future<bool> stateFlag;
  final Icon stateTrueIcon;
  final Icon stateFalseIcon;
  final Function onPressedFunction;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: stateFlag,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return const CircularProgressIndicator();
          case ConnectionState.active:
          case ConnectionState.done:
            if (snapshot.hasData) {
              return IconButton(
                onPressed: () => onPressedFunction(),
                icon: snapshot!.data! ? stateTrueIcon : stateFalseIcon,
              );
            } else {
              return Container();
            }
        }
      },
    );
  }
}
