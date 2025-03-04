import 'package:flutter/material.dart';
import 'employeescreen.dart';
import 'timesheet_screen.dart';
import 'settings_page.dart';
import 'my_leave_page.dart';
import 'leave_page.dart';

class CustomDrawer extends StatelessWidget {
  final String userName;
  final String userRole;

  const CustomDrawer({
    Key? key,
    required this.userName,
    required this.userRole,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 50, bottom: 20),
            width: double.infinity,
            color: Colors.blue,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('assets/images/my_profile.png'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        userName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontFamily:'Poppins',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        userRole,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily:'Poppins',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          ListTile(
             leading: const Icon(Icons.people),
             title: const Text('Employee',
              style:TextStyle(fontFamily: 'Poppins')),
             onTap: () {
             Navigator.pop(context); 
             Navigator.push(
             context,
             MaterialPageRoute(builder: (context) =>  EmployeeScreen()),
              );
             },
            ),
          ListTile(
            leading: const Icon(Icons.calendar_today),
            title: const Text('Timesheet',
             style:TextStyle(fontFamily: 'Poppins')),
            onTap: () {
              Navigator.pop(context); // Close drawer
             Navigator.push(
             context,
             MaterialPageRoute(builder: (context) =>  TimeSheetScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.event_note),
            title: const Text('Leave',
             style:TextStyle(fontFamily: 'Poppins')),
            onTap: () {
              Navigator.pop(context); // Close drawer
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LeavePage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.calendar_month),
            title: const Text('My Leave', 
            style:TextStyle(fontFamily: 'Poppins')),
            onTap: () {
              Navigator.pop(context); // Close drawer
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MyLeavePage()),
              );
            },
          ),
         ListTile(
            leading: const Icon(Icons.settings),
            title: const Text(
           'Settings',
            style: TextStyle(fontFamily: 'Poppins'),
             ),
            onTap: () {
            Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SettingsPage()),
            );
           },
         ),
        ],
      ),
    );
  }
} 