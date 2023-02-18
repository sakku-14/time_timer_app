import 'package:flutter/material.dart';
import 'package:time_timer_app/View/time_page_app_bar.dart';
import 'package:time_timer_app/View/time_page_bottom_navigation_bar.dart';
import 'package:time_timer_app/View/timer_body.dart';

class TimePageView extends StatefulWidget {
  const TimePageView({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<TimePageView> createState() => _TimePageViewState();
}

class _TimePageViewState extends State<TimePageView> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TimePageAppBar(
        title: widget.title,
      ),
      body: const TimerBody(),
      bottomNavigationBar: const TimePageBottomNavigationBar(),
    );
  }
}

class PlusFloatingActionButton extends StatelessWidget {
  const PlusFloatingActionButton({Key? key, required this.incrementCounter})
      : super(key: key);
  final Function incrementCounter;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => incrementCounter(),
      tooltip: 'Increment',
      child: const Icon(Icons.add),
    );
  }
}

class DefaultTextWidget extends StatelessWidget {
  const DefaultTextWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Text(
      'You have pushed the button this many times:',
    );
  }
}

class CountWidget extends StatelessWidget {
  const CountWidget({
    super.key,
    required int counter,
  }) : _counter = counter;

  final int _counter;

  @override
  Widget build(BuildContext context) {
    return Text(
      '$_counter',
      style: Theme.of(context).textTheme.headlineMedium,
    );
  }
}
