import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  // 定数
  static const String HourProperty = 'Hour';
  static const String MinuteProperty = 'Minute';
  static const String SecondProperty = 'Second';
  static const String IsPauseProperty = 'IsPause';
  static const String SoundOnProperty = 'SoundOn';
  static const String VibrationOnProperty = 'VibrationOn';
  static const String DisplayTimeOnProperty = 'DisplayTimeOn';

  // フィールド
  late DateTime leftTime = DateTime(0);
  late bool isPause = true;
  late bool soundOn = true;
  late bool vibrationOn = true;
  late bool displayTimeOn = true;

  @override
  void initState() {
    super.initState();

    // 前回設定値の取得
    Future(() async {
      final prefs = await SharedPreferences.getInstance();
      final int? hour = prefs.getInt(HourProperty);
      final int? minute = prefs.getInt(MinuteProperty);
      final int? second = prefs.getInt(SecondProperty);
      if (hour != null && minute != null && second != null) {
        leftTime = DateTime(0, 0, 0, hour, minute, second);
      } else {
        leftTime = DateTime(0, 0, 0, 0, 0, 0);
      }
      isPause = prefs.getBool(IsPauseProperty) ?? true;
      soundOn = prefs.getBool(SoundOnProperty) ?? true;
      vibrationOn = prefs.getBool(VibrationOnProperty) ?? true;
      displayTimeOn = prefs.getBool(DisplayTimeOnProperty) ?? true;
    });
  }

  // 状態変化メソッド
  // ナビゲーションバー
  // Startボタン
  void pushStart() {
    isPause = false;
    Timer.periodic(
      const Duration(seconds: 1),
      durationCallback,
    );
  }

  void durationCallback(Timer timer) {
    if (isPause) {
      timer.cancel();
      return;
    }
    setState(() {
      leftTime = leftTime.subtract(const Duration(seconds: 1));
    });
  }

  // Pauseボタン
  void pushPause() {
    setState(() {
      isPause = true;
      // TODO:23.02.18:デバッグ用にリセット機能追加
      leftTime = DateTime(0, 0, 0, 1, 0, 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TimePageAppBar(
        title: widget.title,
      ),
      body: TimerBody(
        leftTime: leftTime,
        soundOn: soundOn,
        vibrationOn: vibrationOn,
        displayTimeOn: displayTimeOn,
      ),
      bottomNavigationBar: TimePageBottomNavigationBar(
        pushStart: pushStart,
        pushPause: pushPause,
      ),
    );
  }
}
