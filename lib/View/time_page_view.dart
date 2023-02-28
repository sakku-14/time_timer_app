import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:time_timer_app/Infrastructure/notification_service.dart';
import 'package:time_timer_app/View/time_page_app_bar.dart';
import 'package:time_timer_app/View/time_page_bottom_navigation_bar.dart';
import 'package:time_timer_app/View/timer_body.dart';
import 'package:vibration/vibration.dart';

class TimePageView extends StatefulWidget {
  const TimePageView({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<TimePageView> createState() => _TimePageViewState();
}

class _TimePageViewState extends State<TimePageView>
    with WidgetsBindingObserver {
  //#region フィールド
  //#region 定数
  static const String leftTimeProperty = 'LeftTime';
  static const String detachedTimeProperty = 'DetachedTime';
  static const String isPauseProperty = 'IsPause';
  static const String soundOnProperty = 'SoundOn';
  static const String vibrationOnProperty = 'VibrationOn';
  static const String displayTimeOnProperty = 'DisplayTimeOn';
  static const String dateTimeFormatString = 'yyyy-MM-dd hh:mm:ss';
  //#endregion

  //#region 変数
  late Future<DateTime> leftTime;
  late Future<bool> isPause;
  late Future<bool> soundOn;
  late Future<bool> vibrationOn;
  late Future<bool> displayTimeOn;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  //#endregion
  //#endregion

  //#region アプリライフサイクルメソッド
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // アプリ起動時処理実行
    onInitState();
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (kDebugMode) {
      print("state = $state");
    }
    switch (state) {
      case AppLifecycleState.resumed: // アプリ復帰
        break;
      case AppLifecycleState.inactive: // AppLifecycleState切り替わる時に呼ばれる
        break;
      case AppLifecycleState.paused: // バックグラウンド起動へ移行直前
        // Timer.periodic使用してるから、バックグラウンドでも状態更新してくれる為、状態保存する必要なさそう
        break;
      case AppLifecycleState.detached: // アプリ終了時
        onDetached();
        break;
    }
  }

  // アプリ起動時処理
  Future<void> onInitState() async {
    NotificationService.cancelNotificationsSchedule();
    // 前回設定値の取得
    setState(() {
      leftTime = _prefs.then((value) {
        final dateTimeFormat = DateFormat(dateTimeFormatString);
        return dateTimeFormat.parse(value.getString(leftTimeProperty) ??
            dateTimeFormat.format(DateTime(0)));
      });
      isPause = _prefs.then((value) => value.getBool(isPauseProperty) ?? true);
      soundOn = _prefs.then((value) => value.getBool(soundOnProperty) ?? true);
      vibrationOn =
          _prefs.then((value) => value.getBool(vibrationOnProperty) ?? true);
      displayTimeOn =
          _prefs.then((value) => value.getBool(displayTimeOnProperty) ?? true);
    });
    // 前回タイマー起動中ならタイマー起動させる
    if (!await isPause) startTimer();
  }

  // アプリ終了時処理
  Future<void> onDetached() async {
    // 現在設定値の保存
    final dateTimeFormat = DateFormat(dateTimeFormatString);
    final prefs = await _prefs;
    prefs.setString(leftTimeProperty, dateTimeFormat.format(await leftTime));
    prefs.setBool(isPauseProperty, await isPause);
    prefs.setBool(soundOnProperty, await soundOn);
    prefs.setBool(vibrationOnProperty, await vibrationOn);
    prefs.setBool(displayTimeOnProperty, await displayTimeOn);
    if (!await isPause) {
      prefs.setString(
          detachedTimeProperty, dateTimeFormat.format(DateTime.now()));
    }
  }

  //#endregion

  Future<String> getStringFromPrefs(String key) async {
    return _prefs.then((value) {
      return value.getString(key) ?? '';
    });
  }

  Future<bool> getBoolFromPrefs(String key) async {
    return _prefs.then((value) {
      return value.getBool(key) ?? true;
    });
  }

  Future<String> setStringFromPrefs(String key, String newValue) async {
    final prefs = await _prefs;
    return prefs.setString(key, newValue).then((value) => newValue);
  }

  Future<bool> setBoolFromPrefs(String key, bool newValue) async {
    final prefs = await _prefs;
    return prefs.setBool(key, newValue).then((value) => newValue);
  }

  Future<DateTime> setDateTimeFromPrefs(String key, DateTime newValue) async {
    final prefs = await _prefs;
    final dateTimeFormat = DateFormat(dateTimeFormatString);
    return prefs
        .setString(key, dateTimeFormat.format(newValue))
        .then((value) => newValue);
  }

  //#region 状態変化メソッド
  // ナビゲーションバー
  // Startボタン
  Future<void> pushStart() async {
    // タイマー起動中ORすでにタイマー終了してるなら早期リターン
    if (await isPause == false || await isFinishedTimer()) return;
    final newIsPause = !(await getBoolFromPrefs(isPauseProperty));
    isPause = setBoolFromPrefs(isPauseProperty, newIsPause);
    Timer.periodic(
      const Duration(seconds: 1),
      durationCallback,
    );
  }

  void startTimer() {
    Timer.periodic(
      const Duration(seconds: 1),
      durationCallback,
    );
  }

  Future<void> durationCallback(Timer timer) async {
    if (await isPause || await finishTimer()) {
      isPause = setBoolFromPrefs(isPauseProperty, true);
      timer.cancel();
      return;
    }
    final newLeftTime = (await leftTime).subtract(const Duration(seconds: 1));
    setState(() {
      leftTime = setDateTimeFromPrefs(leftTimeProperty, newLeftTime);
    });
  }

  Future<bool> finishTimer() async {
    if (await isFinishedTimer()) {
      NotificationService.notifyNow();
      if (await vibrationOn) {
        Future(() async {
          if (await Vibration.hasVibrator() ?? false) {
            Vibration.vibrate();
            await Future.delayed(const Duration(milliseconds: 500));
            Vibration.vibrate();
            await Future.delayed(const Duration(milliseconds: 500));
            Vibration.vibrate();
          }
        });
      }
      return true;
    }
    return false;
  }

  Future<bool> isFinishedTimer() async {
    final leftTimeValue = await leftTime;
    if (leftTimeValue.hour == 0 &&
        leftTimeValue.minute == 0 &&
        leftTimeValue.second == 0) {
      return true;
    }
    return false;
  }

  // Pauseボタン
  Future<void> pushPause() async {
    setState(() {
      isPause = setBoolFromPrefs(isPauseProperty, true);
      // TODO:23.02.18:デバッグ用にリセット機能追加
      leftTime =
          setDateTimeFromPrefs(leftTimeProperty, DateTime(0, 0, 0, 0, 0, 20));
    });
  }

  // タイマーボディ
  // タイマーオプション
  // 通知ON／OFF
  Future<void> changeSoundOn() async {
    final newSoundOn = !(await getBoolFromPrefs(soundOnProperty));
    setState(() {
      soundOn = setBoolFromPrefs(soundOnProperty, newSoundOn);
    });
  }

  // 振動ON／OFF
  Future<void> changeVibrationOn() async {
    final newVibrationOn = !(await getBoolFromPrefs(vibrationOnProperty));
    setState(() {
      vibrationOn = setBoolFromPrefs(vibrationOnProperty, newVibrationOn);
    });
  }

  // 時間表示ON／OFF
  Future<void> changeDisplayTimeOn() async {
    final newDisplayTimeOn = !(await getBoolFromPrefs(displayTimeOnProperty));
    setState(() {
      displayTimeOn = setBoolFromPrefs(displayTimeOnProperty, newDisplayTimeOn);
    });
  }
  //#endregion 状態変化メソッド

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
        changeSoundOn: changeSoundOn,
        changeVibrationOn: changeVibrationOn,
        changeDisplayTimeOn: changeDisplayTimeOn,
      ),
      bottomNavigationBar: TimePageBottomNavigationBar(
        pushStart: pushStart,
        pushPause: pushPause,
      ),
    );
  }
}
