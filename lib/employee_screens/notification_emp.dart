// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
//
// class PushNotificationService {
//   static const String _serverKey = 'YOUR_FCM_SERVER_KEY'; // Get this from Firebase Console
//
//   static Future<void> sendNotification({
//     required String token,
//     required String title,
//     required String body,
//   }) async {
//     try {
//       final response = await http.post(
//         Uri.parse('https://fcm.googleapis.com/fcm/send'),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'key=$_serverKey',
//         },
//         body: jsonEncode({
//           'to': token,
//           'notification': {
//             'title': title,
//             'body': body,
//           },
//         }),
//       );
//
//       print("FCM Response: ${response.body}");
//     } catch (e) {
//       print("Error sending FCM: $e");
//     }
//   }
//
//   static Future<void> notifyAdminOnLeaveRequest(String employeeName) async {
//     final adminDoc = await FirebaseFirestore.instance.collection('users').doc('admin').get();
//     if (adminDoc.exists) {
//       final adminToken = adminDoc['fcmToken'];
//       if (adminToken != null) {
//         await sendNotification(
//           token: adminToken,
//           title: "New Leave Request",
//           body: "$employeeName has applied for leave.",
//         );
//       }
//     }
//   }
//
//   static Future<void> notifyEmployeeOnLeaveStatus(String userId, String newStatus) async {
//     final userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
//     if (userDoc.exists) {
//       final userToken = userDoc['fcmToken'];
//       if (userToken != null) {
//         await sendNotification(
//           token: userToken,
//           title: "Leave Status Update",
//           body: "Your leave request has been $newStatus.",
//         );
//       }
//     }
//   }
// }


import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as http;
import 'package:googleapis/servicecontrol/v1.dart' as service_control;

class PushNotificationService{
  static Future<void> getAccessToken() async
  {
    final serviceAccount=
    {
      "type": "service_account",
      "project_id": "open-track-8d67b",
      "private_key_id": "ea921f762a665a47c36a7df159aed2b318a7bf7e",
      "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCfJKqg/gKtpJT6\nvc3+W01PnkgIKLoDeyL3T7XWWf3H5wtnBONmWEwie8l4dev2XPCD5CS4sv871xxe\nNP24lP2Ih/I1ae02yc0k5JdjSCfYYCYgueQ1Yu6ASwnNVLUGkfLWRPY+ZYB3AXAn\nwRZz1Mlv6EI69HyON1R5gIWFYs6WQgmeS0/N4WeFAURqNU7y9k7k2wBcYnt1lEiB\nZIA4ZFY7g58M7s4weLFA6M1CPajRCc1R9IQhF2I9ciabaayO2ACqbQ1F14d0t3fY\nCg83YJbru6gbe2bDhiIknWP//TmxgHYUtSNrvj5z1lujN0noiPQD9ligigdJR8ki\n0CrA/K+LAgMBAAECggEABcQGJeJ+DSBeMoVrIY1LKLUE9PZGG+IQ7Pb82ESIuzeF\nxEo7GquHgbpTnQa1lOMJO/RF5lEtbYyIURRWhZSGE6dMWh7ygrPQqbiSrRkaa5IQ\npq4aycwlgvD1CR+Q66lLcyyqxwK5ovKUckRFx7H+ZMV8XMwcBupa0sE2xvc0hTaA\nuypGowm1kZTRIG+Uwtnipp1ITLuLonyGtnk77SPJLRMy7CZ21Q0EcT4XcijHXOS7\nyaKP/HQf/dgmsbZsxNpzJWGGsbj8IwKVgUy52MJS8zN9h7SXyF6ZoRZY9o8UqHqV\n+lEOeFQu8mCOCJya/iDDgiecggKTYWT8pD73dTdqrQKBgQDYuedcGXFqTAi/C0r8\nBf5hWYTnW5XHlapmHp7lCXM+qLEBR+zkZIIxHdlN80SP0YRjntZlBkoxyKPQD0vE\n1fabHVV04GjsBXEchcwGUqSYL6GhydL1+AsNVq57Eq2eoBeui7X3TNjJAEL0cK2H\n7l9LdWMH1hgeYdjM5/ixn+/W9wKBgQC7+3HQ26bPBwinNcjcg4Nv61Y2+YVLRUMt\na689KZHoyjTR8HztuXVgz96yF+JYiCUmBcmm0Jx94+uTi21YL/6xbkehubzfqNfo\niEy64iPrmDFm7ppFGNQMbzNKXi9Tt274u/j+8I3nzA03W0WkVQ4RBENT39yTp15U\nYZov4i0jDQKBgBxEgyy8FNLsf+eLLYiZr4g7CN60T2Ds4IDZVZhCF0oA7rVgEEHp\n6iFF52YHaNXpWf80ZHpgy6SaquMkW5mc3sF0ngTUkFrYitxRhz774IQJEmfrzxxN\n8gMXX0KmOQcLkostpdpPp6bv5cvENp4YNU2+TeBjyFmOIZz4VLO2TK4ZAoGBALYD\nYNC53WnXhalhinr5W+qiE3hnYYjgJ4tzGNo/xeeA4mPkVxJW4DA9FYObXK4cJNwL\n/pRmqR+77/2MovMghZuHDBSroxVshqHAV4scK2uSkUL5BKaiw67GfQMk7u5ATlLI\nru8qPDyUdreCyIu1T0lqt0YfG5RcGhnZ51E1zj6BAoGABxBlImQ9M31gNB0qpfAD\nZ5ZBgjnpf1Fs7XR60qiy1fQ0s4daMS8147bSDya+STNNpmIlI5pi+tBFPFHcD7c3\ngrxXI3GUS/o6R5JE+mrNPOLvcQy0Cp2rbgqHy6BzgLE88FlszRQ3mCLw1sGAGnih\nNLHwk79fl0gFGhS2IumNnF4=\n-----END PRIVATE KEY-----\n",
      "client_email": "firebase-adminsdk-fbsvc@open-track-8d67b.iam.gserviceaccount.com",
      "client_id": "117794513114900148934",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-fbsvc%40open-track-8d67b.iam.gserviceaccount.com",
      "universe_domain": "googleapis.com"
    };
      List<String> scope =
          [
            "http//www.googleapis.com/auth/firebase.messaging",
            "http//www.googleapis.com/auth/firebase.database",
            "https://www.googleapis.com/auth/userinfo.email"
          ];
      http.Client client= await auth.clientViaServiceAccount(serviceAccount, scope);

  }
  static sendNotificationToSelectedDriver(String deviceToken, BuildContext context, String tripID)async
  {

  }
}