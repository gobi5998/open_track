import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final List<NotificationItem> _notifications = [
    NotificationItem(
      name: "Arun Kumar",
      role: "Medical leave",
      time: "7s ago",
      isToday: true,
    ),
    NotificationItem(
      name: "Arun Kumar",
      role: "Medical leave",
      time: "2h ago",
      isToday: true,
    ),
    NotificationItem(
      name: "Arun Kumar",
      role: "Medical leave",
      time: "5h ago",
      isToday: false,
    ),
    NotificationItem(
      name: "Arun Kumar",
      role: "Medical leave",
      time: "2d ago",
      isToday: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20, color: Colors.blue),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Notifications',
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
            fontFamily: 'Poppins',
          ),
        ),
        actions: [
         
          
        ],
      ),
      body: ListView(
        children: [
          if (_notifications.any((n) => n.isToday)) ...[
            const Padding(
              padding: EdgeInsets.only(left: 16, top: 16, bottom: 8),
              child: Text(
                'Today',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 13,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Container(
              color: Colors.white,
              child: Column(
                children: _notifications
                    .where((n) => n.isToday)
                    .map((notification) => _buildNotificationItem(notification))
                    .toList(),
              ),
            ),
          ],
          if (_notifications.any((n) => !n.isToday)) ...[
            const Padding(
              padding: EdgeInsets.only(left: 16, top: 16, bottom: 8),
              child: Text(
                'Yesterday',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 13,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Container(
              color: Colors.white,
              child: Column(
                children: _notifications
                    .where((n) => !n.isToday)
                    .map((notification) => _buildNotificationItem(notification))
                    .toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildNotificationItem(NotificationItem notification) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey[200]!,
            width: 0.5,
          ),
        ),
      ),
      child: ListTile(
        leading: CircleAvatar(
          radius: 20,
          backgroundImage: const AssetImage('assets/images/main_profile.png'),
        ),
        title: Text(
          notification.name,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          notification.role,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        trailing: Text(
          notification.time,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 12,
            color: Colors.grey[500],
          ),
        ),
      ),
    );
  }
}

class NotificationItem {
  final String name;
  final String role;
  final String time;
  final bool isToday;

  NotificationItem({
    required this.name,
    required this.role,
    required this.time,
    required this.isToday,
  });
}