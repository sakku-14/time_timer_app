import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  // 今すぐ通知する
  static Future<void> notifyNow() async {
    final flnp = FlutterLocalNotificationsPlugin();
    flnp.show(
      0,
      '完了通知',
      'タイマーが終了しました',
      const NotificationDetails(
        iOS: DarwinNotificationDetails(categoryIdentifier: 'plainCategory'),
      ),
    );
  }

  // 指定時間後に通知するよう通知予約する
  static Future<void> scheduleNotifications(DateTime dateTime,
      {DateTimeComponents? dateTimeComponents}) async {
    // 日時をTimeZoneを考慮した日時に変換する
    final scheduleTime = tz.TZDateTime.from(dateTime, tz.local);

    // 通知をスケジュールする
    final flnp = FlutterLocalNotificationsPlugin();
    await flnp.zonedSchedule(
      1,
      '完了通知',
      'タイマーが終了しました',
      scheduleTime,
      const NotificationDetails(
        iOS: DarwinNotificationDetails(categoryIdentifier: 'plainCategory'),
      ),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
      matchDateTimeComponents: dateTimeComponents,
    );
  }

  // 通知キャンセル
  static Future<void> cancelNotificationsSchedule() async {
    final flnp = FlutterLocalNotificationsPlugin();
    await flnp.cancelAll();
  }
}
