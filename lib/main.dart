import 'package:flutter/material.dart';
import 'package:time_timer_app/View/time_page_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TimeTimerApp',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const TimePageView(title: 'TimeTimerApp'),
    );
  }
}
