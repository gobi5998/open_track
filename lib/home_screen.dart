import 'package:flutter/material.dart';
import 'loginpage.dart';
import 'package:open_track/menu_bar/drawer_menu.dart';
import 'package:open_track/menu_bar/notifications_page.dart';

class AttendanceList extends StatefulWidget {
  const AttendanceList({super.key});

  @override
  State<AttendanceList> createState() => _AttendanceListState();
}

class _AttendanceListState extends State<AttendanceList> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<AttendanceData> attendanceList = [
    AttendanceData(
      name: "Arun Kumar",
      role: "Software Engineer",
      inTime: "10:00 AM",
      outTime: "07:00 PM",
    ),
    AttendanceData(
      name: "Arun Kumar",
      role: "Software Engineer",
      inTime: "10:00 AM",
      outTime: "02:00 PM",
    ),
    AttendanceData(
      name: "Arun Kumar",
      role: "Software Engineer",
      inTime: "--",
      outTime: "--",
    ),
    AttendanceData(
      name: "Arun Kumar",
      role: "Software Engineer",
      inTime: "--",
      outTime: null,
      isLeave: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
        title: const Text('Attendance List',
        style:TextStyle(fontFamily:'Poppins', color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            color: Colors.white,
            onPressed: () {
               Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NotificationsPage()),
                );
            },
          ),
        ],
      ),
      drawer:  CustomDrawer(
        userName: "Gobi",
        userRole: "Software Engineer",
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: Row(
                children: [
                  const SizedBox(width: 40), // Increased width for index numbers
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16), // Added left padding
                      child: const Text(
                        'Profile',
                        style: TextStyle(fontWeight: FontWeight.bold,
                        fontFamily:'Poppins'),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'In Time',
                      style: TextStyle(fontWeight: FontWeight.bold,
                      fontFamily:'Poppins'),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Out Time',
                      style: TextStyle(fontWeight: FontWeight.bold,
                      fontFamily:'Poppins',),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: attendanceList.length,
                itemBuilder: (context, index) {
                  return AttendanceListItem(
                    data: attendanceList[index],
                    index: index + 1,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}   
class AttendanceListItem extends StatelessWidget {
  final AttendanceData data;
  final int index;

  const AttendanceListItem({
    Key? key,
    required this.data,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
             // Increased width to match header
            // child: Text(
            //   '${index.toString().padLeft(2, '0')}.',
            //   style: TextStyle(fontWeight: FontWeight.bold),
            // ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: AssetImage('assets/images/main_profile.png'),
                ),
                const SizedBox(width: 8),
                Expanded(  // Wrapped in Expanded to handle overflow
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.name,
                        style: const TextStyle(fontWeight: FontWeight.bold,
                        fontFamily:'Poppins'),
                        overflow: TextOverflow.ellipsis, // Handle text overflow
                      ),
                      Text(
                        data.role,
                        style: TextStyle(
                          fontFamily:'Poppins',
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),

                        overflow: TextOverflow.ellipsis, // Handle text overflow
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Text(
              data.inTime,
              style: TextStyle(
                color: data.inTime == "--" ? Colors.red : Colors.green,
                 fontFamily:'Poppins'
              ),
            ),
          ),
          Expanded(
            child: data.isLeave
                ? Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Leave',
                      style: TextStyle(color: Colors.white, fontSize: 12,
                      fontFamily:'Poppins'),
                    ),
                  )
                : Text(
                    data.outTime ?? "--",
                    style: TextStyle(
                      color: data.outTime == "--" ? Colors.red : Colors.red,
                       fontFamily:'Poppins',
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class AttendanceData {
  final String name;
  final String role;
  final String inTime;
  final String? outTime;
  final bool isLeave;

  AttendanceData({
    required this.name,
    required this.role,
    required this.inTime,
    this.outTime,
    this.isLeave = false,
  });
}
