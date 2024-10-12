import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:todo_sensor/screen/todo_home_page.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzData;

class NotificationServices {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  static GlobalKey<NavigatorState> globalKey = GlobalKey<NavigatorState>();
  static NotificationDetails notificationDetails = const NotificationDetails(
    android: AndroidNotificationDetails(
      "channelId",
      "channelName",
      priority: Priority.high,
      importance: Importance.high,
      icon: "@mipmap/ic_launcher",
    ),
  );

  static Future<void> init() async {
    await configureLocalTimeZone();
    AndroidInitializationSettings androidInitializationSettings =
    const AndroidInitializationSettings("@mipmap/ic_launcher");
    InitializationSettings initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
      onDidReceiveBackgroundNotificationResponse:
      onDidReceiveBackgroundNotificationResponse,
    );
  }


  // Request notification permission
  static void askForNotificationPermission() {
    Permission.notification.request().then((permissionStatus) {
      if (permissionStatus != PermissionStatus.granted) {
        AppSettings.openAppSettings(type: AppSettingsType.notification);
      }
      return;
    });
  }

  // static Future<void> scheduleNotificationAtMidnight({
  //   required String title,
  //   required String body,
  //   required String payload,
  // }) async {
  //   tz.TZDateTime nextInstanceOfTenAM() {
  //     final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
  //     tz.TZDateTime scheduledDate =
  //     tz.TZDateTime(tz.local, now.year, now.month, now.day, 13,13);
  //     if (scheduledDate.isBefore(now)) {
  //       scheduledDate = scheduledDate.add(const Duration(days: 1));
  //     }
  //     return scheduledDate;
  //   }
  //
  //   await flutterLocalNotificationsPlugin.zonedSchedule(
  //     1,
  //     title,
  //     body,
  //     nextInstanceOfTenAM(),
  //     const NotificationDetails(
  //       android: AndroidNotificationDetails(
  //         'daily notification channel id',
  //         'daily notification channel name',
  //         channelDescription: 'daily notification description',
  //       ),
  //     ),
  //     androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
  //     uiLocalNotificationDateInterpretation:
  //     UILocalNotificationDateInterpretation.absoluteTime,
  //     matchDateTimeComponents: DateTimeComponents.time,
  //   );
  // }

  static Future<void> scheduleNotificationAtSpecificTime({
    required String title,
    required String body,
    required String payload,
    required String date,
  }) async {
    tz.TZDateTime nextInstanceOfSpecificTime() {
      DateTime parsedDate = DateTime.parse(date); // Format: "yyyy-MM-dd"

      tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local, parsedDate.year, parsedDate.month, parsedDate.day, 13,32);

      final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
      if (scheduledDate.isBefore(now)) {
        // If it's in the past, add a day to schedule for the next occurrence
        scheduledDate = scheduledDate.add(const Duration(days: 1));
      }

      return scheduledDate;
    }

    // Schedule the notification using the calculated scheduled date
    await flutterLocalNotificationsPlugin.zonedSchedule(
      1, // Notification ID
      title,
      body,
      nextInstanceOfSpecificTime(),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily notification channel id',
          'daily notification channel name',
          channelDescription: 'daily notification description',
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  static Future<void> cancelScheduledNotification() async {
    await flutterLocalNotificationsPlugin.cancel(1); // Cancel notification with ID 1
  }

  static void onDidReceiveNotificationResponse(NotificationResponse response) {
    debugPrint("onDidReceiveNotificationResponse");
    globalKey.currentState?.pushReplacement(
      MaterialPageRoute(
        builder: (context) => const TodoHomePage(),
      ),
    );
  }

  static void onDidReceiveBackgroundNotificationResponse(
      NotificationResponse response) {
    debugPrint("onDidReceiveBackgroundNotificationResponse");
    globalKey.currentState?.pushReplacement(
      MaterialPageRoute(
        builder: (context) => const TodoHomePage(),
      ),
    );
  }


  // Configure local timezone
  static Future<void> configureLocalTimeZone() async {
    tzData.initializeTimeZones();
    final String timeZoneName = await FlutterTimezone.getLocalTimezone(); // Get the local timezone
    tz.setLocalLocation(tz.getLocation(timeZoneName)); // Set the local timezone
  }
}

