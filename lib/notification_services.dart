// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:flutter/material.dart';
//
// class NotificationService {
//   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
//   final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();
//
//   Future<void> initNotifications() async {
//     await _firebaseMessaging.requestPermission();
//
//     // Initialize local notifications
//     const AndroidInitializationSettings androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
//     const InitializationSettings initSettings = InitializationSettings(android: androidSettings);
//
//     await _localNotifications.initialize(initSettings);
//
//     // Get the FCM token
//     _firebaseMessaging.getToken().then((token) {
//       print("FCM Token: $token");
//     });
//
//     // Listen for foreground notifications
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       if (message.notification != null) {
//         _showNotification(message.notification!.title!, message.notification!.body!);
//       }
//     });
//
//     // Handle background & terminated state notifications
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       print("Notification Clicked: ${message.data}");
//     });
//   }
//
//   Future<void> _showNotification(String title, String body) async {
//     const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
//       'channel_id',
//       'channel_name',
//       importance: Importance.high,
//       priority: Priority.high,
//     );
//
//     const NotificationDetails notificationDetails = NotificationDetails(android: androidDetails);
//
//     await _localNotifications.show(0, title, body, notificationDetails);
//   }
// }


import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationServies{
  NotificationServies._();
  static final NotificationServies instance = NotificationServies._();

  final _messaging = FirebaseMessaging.instance;
  final _localNotifications = FlutterLocalNotificationsPlugin();
  bool _isFlutterLocalNotificationInitialized = false;

  Future<void>_requestPermission()async{
    final setting = await _messaging.requestPermission(
      alert:true,
      badge:true,
      sound:true,
      provisional:false,
      announcement:false,
      carPlay:false,
      criticalAlert:false,

    );
    print('permission status ${setting.authorizationStatus}');
  }
Future<void>setupFlutterNotifications()async{
    if(_isFlutterLocalNotificationInitialized){
      return;
    }
    const channel = AndroidNotificationChannel(
        "high_importance_channel",
        "High Importance Notifications",
        description:"This channel is used for important notifications",
        importance: Importance.high);
     await _localNotifications.resolvePlatformSpecificImplementation<
     AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);
}

}