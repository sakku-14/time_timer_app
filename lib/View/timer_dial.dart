import 'package:flutter/material.dart';

class TimerDial extends StatelessWidget {
  const TimerDial({Key? key, required this.leftTime}) : super(key: key);
  final Future<DateTime> leftTime;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DateTime>(
        future: leftTime,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return const CircularProgressIndicator();
            case ConnectionState.active:
            case ConnectionState.done:
              return Text(snapshot!.data.toString());
          }
        });
  }
}
