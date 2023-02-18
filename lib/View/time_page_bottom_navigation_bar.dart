import 'package:flutter/material.dart';

class TimePageBottomNavigationBar extends StatelessWidget {
  const TimePageBottomNavigationBar(
      {Key? key, required this.pushPause, required this.pushStart})
      : super(key: key);
  final Function pushStart;
  final Function pushPause;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.play_arrow_rounded),
          label: 'Start',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.pause_rounded),
          label: 'Pause',
        ),
      ],
      onTap: (int index) {
        if (index == 0) {
          pushStart();
        } else if (index == 1) {
          pushPause();
        }
      },
    );
  }
}
