import 'package:cliary_test/resources/cliary_colors.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationHelper {
  NotificationHelper() :
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin(),
    initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('ic_stat_cliary_icon_outline'),
    ) {

    /*await*/
    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: _selectNotification,
    );

    tz.initializeTimeZones();
  }

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  InitializationSettings initializationSettings;

  void sendSimpleNotification() {
    final AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'cliary_channel_id',
      'Cliary',
      enableLights: true,
      ledOnMs: 1000,
      ledOffMs: 500,
      timeoutAfter: 15 * 60 * 1000,
      color: CliaryColors.cliaryMainBlue.withOpacity(0.8),
      ledColor: CliaryColors.cliaryMainBlue.withOpacity(0.8),
      importance: Importance.max,
      priority: Priority.max,
    );

    final NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    flutterLocalNotificationsPlugin.show(
      12345,
      "Dodaj wizytę Margot Robbie",
      "Naciśnij powiadomienie, aby dodać wizytę z Margot Robbie",
      platformChannelSpecifics,
      payload: 'data',
    );
  }

  void scheduleNotification(int id, String serviceName, String clientName, DateTime start, DateTime end, int? cost, int offset) /*async*/ {
    final timeStr = '${start.hour}:${start.minute < 10 ? '0${start.minute}' : start.minute} - ${end.hour}:${end.minute < 10 ? '0${end.minute}' : end.minute}';
    final lines = [clientName, timeStr, if (cost != null) '$cost PLN'];
    final InboxStyleInformation inboxStyleInformation = InboxStyleInformation(
      lines,
      contentTitle: serviceName,
      summaryText: 'Nadchodzące wydarzenie',
    );

    final AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'cliary_channel_id',
      'Cliary',
      enableLights: true,
      ledOnMs: 1000,
      ledOffMs: 500,
      timeoutAfter: 15 * 60 * 1000,
      color: CliaryColors.cliaryMainBlue.withOpacity(0.8),
      ledColor: CliaryColors.cliaryMainBlue.withOpacity(0.8),
      importance: Importance.max,
      priority: Priority.max,
      styleInformation: inboxStyleInformation,
    );

    final NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    /*await*/ flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      '$serviceName za $offset minut!',
      clientName,
      tz.TZDateTime.from(start, tz.local).subtract(Duration(minutes: offset)),
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      payload: '$id $serviceName $clientName $start $end $cost',
    );
  }

  void cancelNotification(int id) {
    flutterLocalNotificationsPlugin.cancel(id);
  }

  void _selectNotification(String? payload) async {
    print(payload);
  }
}