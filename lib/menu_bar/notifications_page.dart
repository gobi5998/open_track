import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminNotificationsPage extends StatefulWidget {
  const AdminNotificationsPage({super.key});

  @override
  State<AdminNotificationsPage> createState() => _AdminNotificationsPageState();
}

class _AdminNotificationsPageState extends State<AdminNotificationsPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String adminId = "admin"; // Replace with actual Admin ID

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Admin Notifications")),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('users').doc(adminId).collection('notifications').orderBy('timestamp', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No new notifications"));
          }

          return ListView(
            children: snapshot.data!.docs.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              return ListTile(
                title: Text(data['title']),
                subtitle: Text(data['message']),
                trailing: Text(data['status']),
                onTap: () async {
                  await doc.reference.update({'status': 'read'});
                },
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
