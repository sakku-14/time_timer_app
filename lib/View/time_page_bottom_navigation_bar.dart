import 'package:flutter/material.dart';

class TimePageBottomNavigationBar extends StatelessWidget {
  const TimePageBottomNavigationBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.play_arrow),
          label: 'Start',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.pause),
          label: 'Pause',
        ),
      ],
    );
  }
}
