import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:time_timer_app/Infrastructure/notification_service.dart';
import 'package:time_timer_app/View/time_page_app_bar.dart';
import 'package:time_timer_app/View/time_page_bottom_navigation_bar.dart';
import 'package:time_timer_app/View/timer_arc.dart';
import 'package:time_timer_app/View/timer_drag_area.dart';
import 'package:time_timer_app/View/timer_option.dart';
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
  late DateTime localLeftTime = DateTime(0);
  var minuteForArc = 0;
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
        final leftTime = dateTimeFormat.parse(
            value.getString(leftTimeProperty) ??
                dateTimeFormat.format(DateTime(0)));
        localLeftTime = leftTime;
        minuteForArc =
            leftTime.second == 0 ? leftTime.minute : leftTime.minute + 1;
        return leftTime;
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
    prefs.setString(leftTimeProperty, dateTimeFormat.format(localLeftTime));
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
  //region ナビゲーションバー
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
    final newLeftTime = localLeftTime.subtract(const Duration(seconds: 1));
    setState(() {
      localLeftTime = newLeftTime;
      minuteForArc =
          newLeftTime.second == 0 ? newLeftTime.minute : newLeftTime.minute + 1;
    });
  }

  Future<bool> finishTimer() async {
    if (await isFinishedTimer()) {
      if (await soundOn) {
        NotificationService.notifyNow();
      }
      if (await vibrationOn) {
        Future(() async {
          if (await Vibration.hasVibrator() ?? false) {
            Vibration.vibrate(
                pattern: [2000, 500, 2000, 500, 2000, 500],
                intensities: [255, 0, 255, 0, 255, 0]);
          }
        });
      }
      return true;
    }
    return false;
  }

  Future<bool> isFinishedTimer() async {
    if (localLeftTime.hour == 0 &&
        localLeftTime.minute == 0 &&
        localLeftTime.second == 0) {
      return true;
    }
    return false;
  }

  // Pauseボタン
  Future<void> pushPause() async {
    setState(() {
      isPause = setBoolFromPrefs(isPauseProperty, true);
      setDateTimeFromPrefs(leftTimeProperty, localLeftTime);
    });
  }
  // endregion

  // region タイマーボディ
  // region タイマー
  void setMinutes(DragUpdateDetails dragUpdateDetails, double x, double y,
      double centerX, double centerY, bool isBeginDrag) {
    // 時間設定時はタイマーを停止する
    pushPause();
    var setMinutes = 0;
    final width = (x - centerX).abs();
    final height = (y - centerY).abs();
    final hypotenuse = sqrt(pow(width, 2) + pow(height, 2));

    if (x < centerX && y > 0 && y < centerY) {
      setMinutes = ((acos(height / hypotenuse) / (2 * pi)) * 60).floor(); // 左上
    } else if (x < centerX && y >= centerY) {
      setMinutes =
          ((acos(width / hypotenuse) / (2 * pi)) * 60 + 15).floor(); // 左下
    } else if (x >= centerX && y >= centerY) {
      setMinutes =
          ((acos(height / hypotenuse) / (2 * pi)) * 60 + 30).floor(); // 右下
    } else if (x >= centerX && y > 0 && y < centerY) {
      setMinutes =
          ((acos(width / hypotenuse) / (2 * pi)) * 60 + 45).floor(); // 右上
    }

    // 0と60の境目をドラッグした際の挙動制御
    if (dragUpdateDetails.delta.dx > 0 && x > centerX && y < centerY) {
      if (x - dragUpdateDetails.delta.dx <= centerX) {
        setMinutes = 0;
      }
    }
    if (dragUpdateDetails.delta.dx < 0 && x < centerX && y < centerY) {
      if (x - dragUpdateDetails.delta.dx >= centerX) {
        setMinutes = 60;
      }
    }

    // 設定時間が最大・最小の時の挙動制御
    if (isBeginDrag == false && minuteForArc == 60 && setMinutes < 50) {
      return;
    }
    if (isBeginDrag == false && minuteForArc == 0 && setMinutes > 10) {
      return;
    }

    setState(() {
      localLeftTime = DateTime(0, 0, 0, 0, setMinutes, 0);
      minuteForArc = setMinutes;
    });
  }

  // endregion
  // region タイマーオプション
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

  // endregion
  // endregion
  //#endregion 状態変化メソッド
  final globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TimePageAppBar(
        title: widget.title,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 7,
              child: Center(
                child: Stack(
                  key: globalKey,
                  children: [
                    Center(
                      child: TimerArc(
                        globalKey: globalKey,
                        minutes: minuteForArc,
                      ),
                    ),
                    Center(
                      child: TimerDragArea(
                        globalKey: globalKey,
                        setMinutes: setMinutes,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: TimerOption(
                leftTime: localLeftTime,
                soundOn: soundOn,
                vibrationOn: vibrationOn,
                displayTimeOn: displayTimeOn,
                changeSoundOn: changeSoundOn,
                changeVibrationOn: changeVibrationOn,
                changeDisplayTimeOn: changeDisplayTimeOn,
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: TimePageBottomNavigationBar(
        pushStart: pushStart,
        pushPause: pushPause,
      ),
    );
  }
}
