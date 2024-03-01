import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationApi {
  final FlutterLocalNotificationsPlugin notificationPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> showNotification(
    String? title,
    String? body,
    String? payload,
  ) async {
    BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
      body.toString(),
      htmlFormatBigText: true,
      contentTitle: title.toString(),
      htmlFormatContentTitle: true,
    );

    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      styleInformation: bigTextStyleInformation,
      'Med Pro',
      'Med.pro',
      importance: Importance.max,
      priority: Priority.max,
      icon: "logo",
      channelShowBadge: true,
      largeIcon: const DrawableResourceAndroidBitmap("logo"),
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );

    await notificationPlugin.show(
      0,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }
}
