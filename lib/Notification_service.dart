import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as  tz;
import 'package:timezone/data/latest.dart' as tz;
class NotificationService {

   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  init()async{
    const AndroidInitializationSettings androidInitializationSettings =
    AndroidInitializationSettings("@mipmap/ic_launcher");
    const IOSInitializationSettings iosInitializationSettings = IOSInitializationSettings(
      requestSoundPermission: true,
      requestAlertPermission: true
    );
    const InitializationSettings initializationSettings =
        InitializationSettings(android: androidInitializationSettings ,
        iOS: iosInitializationSettings
        );
    tz.initializeTimeZones();
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }
  requestIOSPermissions(){
    flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()?.requestPermissions(
      alert: true,
      badge: true,
      sound: true
    );
  }
  showNotification(int id , String title , String body)async{
    const AndroidNotificationDetails androidNotificationDetails= AndroidNotificationDetails("your channel id", "your channel name",
    channelDescription: "your channel description",
      importance: Importance.max,
      priority: Priority.high,
      ticker: "ticker"
    );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin.show(id, title, body, platformChannelSpecifics);
  }
  scheduleNotification(int id , String title , String body , time)async{

  try{
    const AndroidNotificationDetails androidNotificationDetails= AndroidNotificationDetails("your channel id", "your channel name",
        channelDescription: "your channel description",
        importance: Importance.max,
        priority: Priority.high,
        ticker: "ticker"
    );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidNotificationDetails);

    await flutterLocalNotificationsPlugin.zonedSchedule(id, title, body, tz.TZDateTime.from(time,
        tz.local),
        platformChannelSpecifics,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true);
  }catch(e){
    print(e);
  }
  }
}