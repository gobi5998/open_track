import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:open_track/menu_bar/leave_page.dart';
import 'package:open_track/menu_bar/settings_page.dart';
import 'package:open_track/menu_bar/timesheet_screen.dart';
import '../loginpage.dart';

class EmployeeDrawer extends StatelessWidget {
  const EmployeeDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Drawer(

      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(user?.displayName ?? "User Name"),
            accountEmail: Text(user?.email ?? "user@example.com"),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(user?.photoURL ??
                  "https://via.placeholder.com/150"), // Placeholder image
            ),
            decoration: const BoxDecoration(color: Colors.blue),
          ),
          ListTile(
            leading: const Icon(Icons.calendar_today),
            title: const Text('Timesheet'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => TimeSheetScreen(userId: 'userId',)));
            },
          ),
          ListTile(
            leading: const Icon(Icons.event_note),
            title: const Text('My Leave'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => LeavePage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsPage()));

            },
          ),
          const Spacer(),
          // ListTile(
          //   leading: const Icon(Icons.logout, color: Colors.red),
          //   title: const Text('Logout', style: TextStyle(color: Colors.red)),
          //   onTap: () async {
          //     await FirebaseAuth.instance.signOut();
          //
          //     // Ensure navigation happens AFTER sign out
          //     WidgetsBinding.instance.addPostFrameCallback((_) {
          //       Navigator.pushAndRemoveUntil(
          //         context,
          //         MaterialPageRoute(builder: (context) => const Login()), // Replace with your LoginPage widget
          //             (Route<dynamic> route) => false, // Removes all previous routes
          //       );
          //     });
          //   },
          // ),
        ],
      ),
    );
  }
}