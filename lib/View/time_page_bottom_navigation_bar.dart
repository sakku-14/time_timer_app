import 'package:flutter/material.dart';

class TimePageBottomNavigationBar extends StatelessWidget {
  const TimePageBottomNavigationBar(
      {Key? key,
      required this.pushPause,
      required this.pushStart,
      required this.currentIndex})
      : super(key: key);
  final Function pushStart;
  final Function pushPause;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      selectedItemColor: Colors.red,
      currentIndex: currentIndex,
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
