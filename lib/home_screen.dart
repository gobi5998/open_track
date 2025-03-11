// import 'package:flutter/material.dart';
// import 'loginpage.dart';
// import 'package:open_track/menu_bar/drawer_menu.dart';
// import 'package:open_track/menu_bar/notifications_page.dart';
//
// class AttendanceList extends StatefulWidget {
//   const AttendanceList({super.key});
//
//   @override
//   State<AttendanceList> createState() => _AttendanceListState();
// }
//
// class _AttendanceListState extends State<AttendanceList> {
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//
//   final List<AttendanceData> attendanceList = [
//     AttendanceData(
//       name: "Arun Kumar",
//       role: "Software Engineer",
//       inTime: "10:00 AM",
//       outTime: "07:00 PM",
//     ),
//     AttendanceData(
//       name: "Arun Kumar",
//       role: "Software Engineer",
//       inTime: "10:00 AM",
//       outTime: "02:00 PM",
//     ),
//     AttendanceData(
//       name: "Arun Kumar",
//       role: "Software Engineer",
//       inTime: "--",
//       outTime: "--",
//     ),
//     AttendanceData(
//       name: "Arun Kumar",
//       role: "Software Engineer",
//       inTime: "--",
//       outTime: null,
//       isLeave: true,
//     ),
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: _scaffoldKey,
//       backgroundColor: Colors.grey[100],
//       appBar: AppBar(
//         backgroundColor: Colors.blue,
//         leading: IconButton(
//           icon: const Icon(Icons.menu, color: Colors.white),
//           onPressed: () {
//             _scaffoldKey.currentState?.openDrawer();
//           },
//         ),
//         title: const Text('Attendance List',
//         style:TextStyle(fontFamily:'Poppins', color: Colors.white)),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.notifications),
//             color: Colors.white,
//             onPressed: () {
//                Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => const NotificationsPage()),
//                 );
//             },
//           ),
//         ],
//       ),
//       drawer:  CustomDrawer(
//         userName: "Gobi",
//         userRole: "Software Engineer",
//       ),
//       body: Container(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             Container(
//               padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
//               child: Row(
//                 children: [
//                   const SizedBox(width: 40), // Increased width for index numbers
//                   Expanded(
//                     flex: 2,
//                     child: Padding(
//                       padding: const EdgeInsets.only(left: 16), // Added left padding
//                       child: const Text(
//                         'Profile',
//                         style: TextStyle(fontWeight: FontWeight.bold,
//                         fontFamily:'Poppins'),
//                       ),
//                     ),
//                   ),
//                   Expanded(
//                     child: Text(
//                       'In Time',
//                       style: TextStyle(fontWeight: FontWeight.bold,
//                       fontFamily:'Poppins'),
//                     ),
//                   ),
//                   Expanded(
//                     child: Text(
//                       'Out Time',
//                       style: TextStyle(fontWeight: FontWeight.bold,
//                       fontFamily:'Poppins',),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: attendanceList.length,
//                 itemBuilder: (context, index) {
//                   return AttendanceListItem(
//                     data: attendanceList[index],
//                     index: index + 1,
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// class AttendanceListItem extends StatelessWidget {
//   final AttendanceData data;
//   final int index;
//
//   const AttendanceListItem({
//     Key? key,
//     required this.data,
//     required this.index,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       decoration: BoxDecoration(
//         border: Border(
//           bottom: BorderSide(color: Colors.grey.shade300),
//         ),
//       ),
//       child: Row(
//         children: [
//           SizedBox(
//              // Increased width to match header
//             // child: Text(
//             //   '${index.toString().padLeft(2, '0')}.',
//             //   style: TextStyle(fontWeight: FontWeight.bold),
//             // ),
//           ),
//           Expanded(
//             flex: 2,
//             child: Row(
//               children: [
//                 CircleAvatar(
//                   radius: 20,
//                   backgroundImage: AssetImage('assets/images/main_profile.png'),
//                 ),
//                 const SizedBox(width: 8),
//                 Expanded(  // Wrapped in Expanded to handle overflow
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         data.name,
//                         style: const TextStyle(fontWeight: FontWeight.bold,
//                         fontFamily:'Poppins'),
//                         overflow: TextOverflow.ellipsis, // Handle text overflow
//                       ),
//                       Text(
//                         data.role,
//                         style: TextStyle(
//                           fontFamily:'Poppins',
//                           color: Colors.grey[600],
//                           fontSize: 12,
//                         ),
//
//                         overflow: TextOverflow.ellipsis, // Handle text overflow
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//             child: Text(
//               data.inTime,
//               style: TextStyle(
//                 color: data.inTime == "--" ? Colors.red : Colors.green,
//                  fontFamily:'Poppins'
//               ),
//             ),
//           ),
//           Expanded(
//             child: data.isLeave
//                 ? Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//                     decoration: BoxDecoration(
//                       color: Colors.red,
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: const Text(
//                       'Leave',
//                       style: TextStyle(color: Colors.white, fontSize: 12,
//                       fontFamily:'Poppins'),
//                     ),
//                   )
//                 : Text(
//                     data.outTime ?? "--",
//                     style: TextStyle(
//                       color: data.outTime == "--" ? Colors.red : Colors.red,
//                        fontFamily:'Poppins',
//                     ),
//                   ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class AttendanceData {
//   final String name;
//   final String role;
//   final String inTime;
//   final String? outTime;
//   final bool isLeave;
//
//   AttendanceData({
//     required this.name,
//     required this.role,
//     required this.inTime,
//     this.outTime,
//     this.isLeave = false,
//   });
// }

//
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
//
// class AttendanceList extends StatefulWidget {
//   const AttendanceList({super.key});
//
//   @override
//   State<AttendanceList> createState() => _AttendanceListScreenState();
// }
//
// class _AttendanceListScreenState extends State<AttendanceList> {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   bool _isLoading = true;
//   List<Map<String, dynamic>> _attendanceData = [];
//
//   @override
//   void initState() {
//     super.initState();
//     _loadEmployeeAttendance();
//   }
//
//   Future<void> _loadEmployeeAttendance() async {
//     if (!mounted) return;
//
//     setState(() => _isLoading = true);
//     try {
//       final QuerySnapshot snapshot = await _firestore
//           .collection('users').doc(user.uid)
//       .collection('attendance').get();
//
//       if (!mounted) return;
//
//       setState(() {
//         _attendanceData = snapshot.docs.map((doc) {
//           final data = doc.data() as Map<String, dynamic>;
//           return {
//             'id': doc.id,
//             'name': data['name'] ?? 'Unknown',
//             'role': data['role'] ?? 'Employee',
//             'inTime': data['inTime'] ?? '--',
//             'outTime': data['outTime'] ?? '--',
//             'isLeave': data['isLeave'] ?? false,
//           };
//         }).toList();
//
//         _isLoading = false;
//       });
//     } catch (e) {
//       if (mounted) {
//         setState(() {
//           _isLoading = false;
//           _attendanceData = [];
//         });
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Error loading attendance: ${e.toString()}'),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.blue,
//         title: const Text('Employee Attendance', style: TextStyle(color: Colors.white)),
//       ),
//       body: RefreshIndicator(
//         onRefresh: _loadEmployeeAttendance,
//         child: Column(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(16),
//               child: Row(
//                 children: [
//                   const Icon(Icons.access_time),
//                   const SizedBox(width: 8),
//                   Text(
//                     'Total Employees: ${_attendanceData.length}',
//                     style: TextStyle(fontSize: 16, color: Colors.grey[600]),
//                   ),
//                 ],
//               ),
//             ),
//             Expanded(
//               child: _isLoading
//                   ? const Center(child: CircularProgressIndicator())
//                   : _attendanceData.isEmpty
//                   ? const Center(child: Text('No attendance records found'))
//                   : ListView.builder(
//                 itemCount: _attendanceData.length,
//                 itemBuilder: (context, index) {
//                   final data = _attendanceData[index];
//                   return AttendanceListItem(
//                     name: data['name'],
//                     role: data['role'],
//                     inTime: data['inTime'],
//                     outTime: data['outTime'],
//                     isLeave: data['isLeave'],
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class AttendanceListItem extends StatelessWidget {
//   final String name;
//   final String role;
//   final String inTime;
//   final String outTime;
//   final bool isLeave;
//
//   const AttendanceListItem({
//     super.key,
//     required this.name,
//     required this.role,
//     required this.inTime,
//     required this.outTime,
//     required this.isLeave,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       decoration: BoxDecoration(
//         border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
//       ),
//       child: Row(
//         children: [
//           CircleAvatar(
//             radius: 20,
//             backgroundImage: AssetImage('assets/images/main_profile.png'),
//           ),
//           const SizedBox(width: 8),
//           Expanded(
//             flex: 2,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
//                 Text(role, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
//               ],
//             ),
//           ),
//           Expanded(
//             child: Text(inTime, style: TextStyle(color: inTime == "--" ? Colors.red : Colors.green)),
//           ),
//           Expanded(
//             child: isLeave
//                 ? Container(
//               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//               decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(12)),
//               child: const Text('Leave', style: TextStyle(color: Colors.white, fontSize: 12)),
//             )
//                 : Text(outTime, style: TextStyle(color: outTime == "--" ? Colors.red : Colors.blue)),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
//
//
//

// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:intl/intl.dart';
//
// class AttendanceList extends StatefulWidget {
//   const AttendanceList({super.key});
//
//   @override
//   State<AttendanceList> createState() => _AttendanceListScreenState();
// }
//
// class _AttendanceListScreenState extends State<AttendanceList> {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   bool _isLoading = true;
//   List<Map<String, dynamic>> _attendanceData = [];
//
//   @override
//   void initState() {
//     super.initState();
//     _loadEmployeeAttendance();
//   }
//
//   // void _loadEmployeeAttendance() {
//   //   final User? user = _auth.currentUser;
//   //   if (user == null) {
//   //     setState(() => _isLoading = false);
//   //     ScaffoldMessenger.of(context).showSnackBar(
//   //       const SnackBar(
//   //         content: Text('User not logged in'),
//   //         backgroundColor: Colors.red,
//   //       ),
//   //     );
//   //     return;
//   //   }
//   //
//   //   print("Fetching attendance for user ID: ${user.uid}");
//   //
//   //   _firestore
//   //       .collection('users')
//   //       .doc(user.uid)
//   //
//   //        .collection('attendance')
//   //       .where('role',isEqualTo: 'employee')
//   //       .snapshots()
//   //       .listen((QuerySnapshot snapshot) {
//   //     if (!mounted) return;
//   //
//   //     setState(() {
//   //       _attendanceData = snapshot.docs.map((doc) {
//   //         final data = doc.data() as Map<String, dynamic>;
//   //         return {
//   //           'name': (data['name'] ?? 'Unknown').toString(),
//   //           'role': (data['role'] ?? 'role').toString(),
//   //           'attendance': (data['attendance'] ?? '--').toString(),
//   //           'inTime': (data['inTime'] ?? '--').toString(),
//   //           'outTime': (data['outTime'] ?? '--').toString(),
//   //           'isLeave': data['isLeave'] ?? false,
//   //         };
//   //       }).toList();
//   //
//   //       _isLoading = false;
//   //     });
//   //
//   //     print("Fetched attendance data: $_attendanceData");
//   //   });
//   // }
//
//   // void _loadEmployeeAttendance() {
//   //   final User? user = _auth.currentUser;
//   //   if (user == null) {
//   //     setState(() => _isLoading = false);
//   //     ScaffoldMessenger.of(context).showSnackBar(
//   //       const SnackBar(
//   //         content: Text('User not logged in'),
//   //         backgroundColor: Colors.red,
//   //       ),
//   //     );
//   //     return;
//   //   }
//   //
//   //   print("Fetching attendance for user ID: ${user.uid}");
//   //
//   //   _firestore.collection('users').doc(user.uid).snapshots().listen((DocumentSnapshot userSnapshot) {
//   //     if (!mounted) return;
//   //
//   //     if (!userSnapshot.exists) {
//   //       setState(() => _isLoading = false);
//   //       print("User document not found.");
//   //       return;
//   //     }
//   //
//   //     final userData = userSnapshot.data() as Map<String, dynamic>;
//   //
//   //     // Check if the user is an employee
//   //     if (userData['role'] != 'employee') {
//   //       setState(() => _isLoading = false);
//   //       print("User is not an employee.");
//   //       return;
//   //     }
//   //
//   //     final List<dynamic> attendanceRecords = userData['attendance'] ?? [];
//   //
//   //     String todayDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
//   //
//   //     // Find today's attendance record
//   //     Map<String, dynamic>? todayAttendance;
//   //     for (var record in attendanceRecords) {
//   //       if (record is Map<String, dynamic> && record.containsKey('date') && record['date'] == todayDate) {
//   //         todayAttendance = record;
//   //         break;
//   //       }
//   //     }
//   //
//   //     setState(() {
//   //       _attendanceData = {
//   //         'name': userData['name'] ?? 'Unknown',
//   //         'role': userData['role'] ?? 'Unknown',
//   //         'inTime': todayAttendance?['inTime'] ?? '--',
//   //         'outTime': todayAttendance?['outTime'] ?? '--',
//   //         'isLeave': todayAttendance?['isLeave'] ?? false,
//   //       } as List<Map<String, dynamic>>;
//   //       _isLoading = false;
//   //     });
//   //
//   //     print("Fetched attendance data: $_attendanceData");
//   //   });
//   // }
//
//   // void _loadEmployeeAttendance() {
//   //   final User? user = _auth.currentUser;
//   //   if (user == null) {
//   //     setState(() => _isLoading = false);
//   //     ScaffoldMessenger.of(context).showSnackBar(
//   //       const SnackBar(
//   //         content: Text('User not logged in'),
//   //         backgroundColor: Colors.red,
//   //       ),
//   //     );
//   //     return;
//   //   }
//   //
//   //   print("Fetching attendance for user ID: ${user.uid}");
//   //
//   //   _firestore.collection('users').doc(user.uid).snapshots().listen((DocumentSnapshot userSnapshot) {
//   //     if (!mounted) return;
//   //
//   //     if (!userSnapshot.exists) {
//   //       setState(() => _isLoading = false);
//   //       print("User document not found.");
//   //       return;
//   //     }
//   //
//   //     final userData = userSnapshot.data() as Map<String, dynamic>;
//   //
//   //     // Check if the user is an employee
//   //     if (userData['role'] != 'employee') {
//   //       setState(() => _isLoading = false);
//   //       print("User is not an employee.");
//   //       return;
//   //     }
//   //
//   //     final List<dynamic> attendanceRecords = userData['attendance'] ?? [];
//   //
//   //     String todayDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
//   //
//   //     // Find today's attendance records
//   //     List<Map<String, dynamic>> todayAttendance = [];
//   //     for (var record in attendanceRecords) {
//   //       if (record is Map<String, dynamic> && record.containsKey('date') && record['date'] == todayDate) {
//   //         todayAttendance.add(record);
//   //       }
//   //     }
//   //
//   //     setState(() {
//   //       _attendanceData = todayAttendance
//   //           .map((record) => {
//   //         'name': userData['name'] ?? 'Unknown',
//   //         'role': userData['role'] ?? 'Unknown',
//   //         'inTime': record['inTime'] ?? '--',
//   //         'outTime': record['outTime'] ?? '--',
//   //         'isLeave': record['isLeave'] ?? false,
//   //       })
//   //           .toList();
//   //       _isLoading = false;
//   //     });
//   //
//   //     print("Fetched attendance data: $_attendanceData");
//   //   });
//   // }
//
//   // void _loadEmployeeAttendance() {
//   //   final User? user = _auth.currentUser;
//   //   if (user == null) {
//   //     setState(() => _isLoading = false);
//   //     ScaffoldMessenger.of(context).showSnackBar(
//   //       const SnackBar(
//   //         content: Text('User not logged in'),
//   //         backgroundColor: Colors.red,
//   //       ),
//   //     );
//   //     return;
//   //   }
//   //
//   //   print("Fetching data for admin: ${user.uid}");
//   //
//   //   // First, check if the user is an admin
//   //   _firestore.collection('users').doc(user.uid).get().then((DocumentSnapshot userSnapshot) {
//   //     if (!userSnapshot.exists) {
//   //       setState(() => _isLoading = false);
//   //       print("Admin user document not found.");
//   //       return;
//   //     }
//   //
//   //     // final userData = userSnapshot.data() as Map<String, dynamic>;
//   //     // if (userData['role'] != 'admin') {
//   //     //   setState(() => _isLoading = false);
//   //     //   print("User is not an admin.");
//   //     //   return;
//   //     // }
//   //
//   //     // Now fetch all employees
//   //     _firestore.collection('users').where('role', isEqualTo: 'employee').get().then((QuerySnapshot employeesSnapshot) {
//   //       List<Map<String, dynamic>> tempAttendanceData = [];
//   //       String todayDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
//   //
//   //       for (var employeeDoc in employeesSnapshot.docs) {
//   //         final employeeData = employeeDoc.data() as Map<String, dynamic>;
//   //         final List<dynamic> attendanceRecords = employeeData['attendance'] ?? [];
//   //
//   //         // Find today's attendance record
//   //         Map<String, dynamic>? todayAttendance;
//   //         for (var record in attendanceRecords) {
//   //           if (record is Map<String, dynamic> && record.containsKey('date') && record['date'] == todayDate) {
//   //             todayAttendance = record;
//   //             break;
//   //           }
//   //         }
//   //
//   //         tempAttendanceData.add({
//   //           'name': (employeeData['name'] ?? 'Unknown').toString(),
//   //           'role': (employeeData['role'] ?? 'Unknown').toString(),
//   //           'inTime': (todayAttendance?['inTime'] ?? '--').toString(),
//   //           'outTime': (todayAttendance?['outTime'] ?? '--').toString(),
//   //           'isLeave': todayAttendance?['isLeave'] ?? false,
//   //         });
//   //       }
//   //
//   //       setState(() {
//   //         _attendanceData = tempAttendanceData;
//   //         _isLoading = false;
//   //       });
//   //
//   //       print("Fetched employee attendance data: $_attendanceData");
//   //     }).catchError((error) {
//   //       print("Error fetching employees: $error");
//   //       setState(() => _isLoading = false);
//   //     });
//   //   }).catchError((error) {
//   //     print("Error fetching admin data: $error");
//   //     setState(() => _isLoading = false);
//   //   });
//   // }
//
//   // ...void _loadEmployeeAttendance() {
//   //   final User? user = _auth.currentUser;
//   //   if (user == null) {
//   //     setState(() => _isLoading = false);
//   //     ScaffoldMessenger.of(context).showSnackBar(
//   //       const SnackBar(
//   //         content: Text('User not logged in'),
//   //         backgroundColor: Colors.red,
//   //       ),
//   //     );
//   //     return;
//   //   }
//   //
//   //   print("Fetching data for admin: ${user.uid}");
//   //
//   //   _firestore.collection('users').doc(user.uid).get().then((DocumentSnapshot userSnapshot) {
//   //     if (!userSnapshot.exists) {
//   //       setState(() => _isLoading = false);
//   //       print("Admin user document not found.");
//   //       return;
//   //     }
//   //
//   //     final userData = userSnapshot.data() as Map<String, dynamic>? ?? {};
//   //     if (userData['role'] != 'admin') {
//   //       setState(() => _isLoading = false);
//   //       print("User is not an admin.");
//   //       return;
//   //     }
//   //
//   //     _firestore.collection('users').where('role', isEqualTo: 'employee').get().then((QuerySnapshot employeesSnapshot) {
//   //       List<Map<String, dynamic>> tempAttendanceData = [];
//   //       String todayDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
//   //
//   //       for (var employeeDoc in employeesSnapshot.docs) {
//   //         final employeeData = employeeDoc.data() as Map<String, dynamic>? ?? {};
//   //         final List<dynamic> attendanceRecords = employeeData['attendance'] ?? [];
//   //
//   //         Map<String, dynamic>? todayAttendance;
//   //         for (var record in attendanceRecords) {
//   //           if (record is Map<String, dynamic> && record.containsKey('date') && record['date'] == todayDate) {
//   //             todayAttendance = record;
//   //             break;
//   //           }
//   //         }
//   //
//   //         tempAttendanceData.add({
//   //           'name': (employeeData['name'] ?? 'Unknown').toString(),
//   //           'role': (employeeData['role'] ?? 'Unknown').toString(),
//   //           'inTime': (todayAttendance?['inTime'] ?? '--').toString(),
//   //           'outTime': (todayAttendance?['outTime'] ?? '--').toString(),
//   //           'isLeave': todayAttendance?['isLeave'] ?? false,
//   //         });
//   //       }
//   //
//   //       setState(() {
//   //         _attendanceData = tempAttendanceData;
//   //         _isLoading = false;
//   //       });
//   //
//   //       print("Fetched employee attendance data: $_attendanceData");
//   //     }).catchError((error) {
//   //       print("Error fetching employees: $error");
//   //       setState(() => _isLoading = false);
//   //     });
//   //   }).catchError((error) {
//   //     print("Error fetching admin data: $error");
//   //     setState(() => _isLoading = false);
//   //   });
//   // }
//
//   // void _loadEmployeeAttendance() {
//   //   final User? user = _auth.currentUser;
//   //   if (user == null) {
//   //     setState(() => _isLoading = false);
//   //     ScaffoldMessenger.of(context).showSnackBar(
//   //       const SnackBar(
//   //         content: Text('User not logged in'),
//   //         backgroundColor: Colors.red,
//   //       ),
//   //     );
//   //     return;
//   //   }
//   //
//   //   print("Fetching data for admin: ${user.uid}");
//   //
//   //   _firestore.collection('users').doc(user.uid).get().then((DocumentSnapshot userSnapshot) {
//   //     if (!userSnapshot.exists) {
//   //       setState(() => _isLoading = false);
//   //       print("Admin user document not found.");
//   //       return;
//   //     }
//   //
//   //     final userData = userSnapshot.data() as Map<String, dynamic>? ?? {};
//   //     if (userData['role'] != 'admin') {
//   //       setState(() => _isLoading = false);
//   //       print("User is not an admin.");
//   //       return;
//   //     }
//   //
//   //     _firestore.collection('users').where('role', isEqualTo: 'employee').get().then((QuerySnapshot employeesSnapshot) {
//   //       List<Map<String, dynamic>> tempAttendanceData = [];
//   //       String todayDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
//   //
//   //       for (var employeeDoc in employeesSnapshot.docs) {
//   //         final employeeData = employeeDoc.data() as Map<String, dynamic>? ?? {};
//   //         final List<dynamic> attendanceRecords = employeeData['attendance'] ?? [];
//   //
//   //         Map<String, dynamic> todayAttendance = {};
//   //         for (var record in attendanceRecords) {
//   //           if (record is Map<String, dynamic> && record.containsKey('date') && record['date'] == todayDate) {
//   //             todayAttendance = record;
//   //             break;
//   //           }
//   //         }
//   //
//   //         // Safely extract values, defaulting to empty strings or false
//   //         String name = (employeeData['name'] ?? 'Unknown').toString();
//   //         String role = (employeeData['role'] ?? 'Unknown').toString();
//   //         String inTime = (todayAttendance['inTime'] ?? '--').toString();
//   //         String outTime = (todayAttendance['outTime'] ?? '--').toString();
//   //         bool isLeave = todayAttendance['isLeave'] ?? false;
//   //
//   //         tempAttendanceData.add({
//   //           'name': name,
//   //           'role': role,
//   //           'inTime': inTime,
//   //           'outTime': outTime,
//   //           'isLeave': isLeave,
//   //         });
//   //       }
//   //
//   //       setState(() {
//   //         _attendanceData = tempAttendanceData;
//   //         _isLoading = false;
//   //       });
//   //
//   //       print("Fetched employee attendance data: $_attendanceData");
//   //     }).catchError((error) {
//   //       print("Error fetching employees: $error");
//   //       setState(() => _isLoading = false);
//   //     });
//   //   }).catchError((error) {
//   //     print("Error fetching admin data: $error");
//   //     setState(() => _isLoading = false);
//   //   });
//   // }
//
//   void _loadEmployeeAttendance() {
//     final User? user = _auth.currentUser;
//     if (user == null) {
//       setState(() => _isLoading = false);
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('User not logged in'),
//           backgroundColor: Colors.red,
//         ),
//       );
//       return;
//     }
//
//     print("Fetching data for admin: ${user.uid}");
//
//     _firestore.collection('users').doc(user.uid).get().then((DocumentSnapshot userSnapshot) {
//       if (!userSnapshot.exists) {
//         setState(() => _isLoading = false);
//         print("Admin user document not found.");
//         return;
//       }
//
//       final userData = userSnapshot.data() as Map<String, dynamic>? ?? {};
//       if ((userData['role'] ?? '') != 'admin') {
//         setState(() => _isLoading = false);
//         print("User is not an admin.");
//         return;
//       }
//
//       _firestore.collection('users').where('role', isEqualTo: 'employee').get().then((QuerySnapshot employeesSnapshot) {
//         List<Map<String, dynamic>> tempAttendanceData = [];
//         String todayDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
//
//         for (var employeeDoc in employeesSnapshot.docs) {
//           final employeeData = employeeDoc.data() as Map<String, dynamic>? ?? {};
//           final List<dynamic> attendanceRecords = employeeData['attendance'] ?? [];
//
//           Map<String, dynamic> todayAttendance = {};
//           for (var record in attendanceRecords) {
//             if (record is Map<String, dynamic> && record.containsKey('date') && (record['date'] ?? '') == todayDate) {
//               todayAttendance = record;
//               break;
//             }
//           }
//
//           // Safely extract values, replacing null with default values
//           String name = (employeeData['name'] ?? 'Unknown').toString();
//           String role = (employeeData['role'] ?? 'Unknown').toString();
//           String inTime = (todayAttendance['inTime'] as String?) ?? '--';
//           String outTime = (todayAttendance['outTime'] as String?) ?? '--';
//           bool isLeave = (todayAttendance['isLeave'] as bool?) ?? false;
//
//           tempAttendanceData.add({
//             'name': name,
//             'role': role,
//             'inTime': inTime,
//             'outTime': outTime,
//             'isLeave': isLeave,
//           });
//         }
//
//         setState(() {
//           _attendanceData = tempAttendanceData;
//           _isLoading = false;
//         });
//
//         print("Fetched employee attendance data: $_attendanceData");
//       }).catchError((error) {
//         print("Error fetching employees: $error");
//         setState(() => _isLoading = false);
//       });
//     }).catchError((error) {
//       print("Error fetching admin data: $error");
//       setState(() => _isLoading = false);
//     });
//   }
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.blue,
//         title: const Text('Employee Attendance',
//             style: TextStyle(color: Colors.white)),
//       ),
//       drawer: Drawer(),
//       body: RefreshIndicator(
//         onRefresh: () async => _loadEmployeeAttendance(),
//         child: Column(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(16),
//               child: Row(
//                 children: [
//                   const Icon(Icons.access_time),
//                   const SizedBox(width: 8),
//                   Text(
//                     'Total Employees: ${_attendanceData.length}',
//                     style: TextStyle(fontSize: 16, color: Colors.grey[600]),
//                   ),
//                 ],
//               ),
//             ),
//             Expanded(
//               child: _isLoading
//                   ? const Center(child: CircularProgressIndicator())
//                   : _attendanceData.isEmpty
//                       ? const Center(child: Text('No attendance records found'))
//                       : ListView.builder(
//                           itemCount: _attendanceData.length,
//                           itemBuilder: (context, index) {
//                             final data = _attendanceData[index];
//                             return AttendanceListItem(
//                               name: data['name'],
//                               role: data['role'],
//                               attendance: data['attendance'],
//                               inTime: data['inTime'],
//                               outTime: data['outTime'],
//                               isLeave: data['isLeave'],
//                             );
//                           },
//                         ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class AttendanceListItem extends StatelessWidget {
//   final String name;
//   final String role;
//   final String attendance;
//   final String inTime;
//   final String outTime;
//   final bool isLeave;
//
//   const AttendanceListItem({
//     super.key,
//     required this.name,
//     required this.attendance,
//     required this.inTime,
//     required this.outTime,
//     required this.isLeave,
//     required this.role,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       decoration: BoxDecoration(
//         border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
//       ),
//       child: Row(
//         children: [
//           const CircleAvatar(
//             radius: 20,
//             backgroundImage: AssetImage('assets/images/main_profile.png'),
//           ),
//           const SizedBox(width: 8),
//           Expanded(
//             flex: 2,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
//                 Text(attendance,
//                     style: TextStyle(color: Colors.grey[600], fontSize: 12)),
//               ],
//             ),
//           ),
//           Expanded(
//             child: Text(
//               inTime,
//               style:
//                   TextStyle(color: inTime == "--" ? Colors.red : Colors.green),
//             ),
//           ),
//           Expanded(
//             child: isLeave
//                 ? Container(
//                     padding:
//                         const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//                     decoration: BoxDecoration(
//                         color: Colors.red,
//                         borderRadius: BorderRadius.circular(12)),
//                     child: const Text('Leave',
//                         style: TextStyle(color: Colors.white, fontSize: 12)),
//                   )
//                 : Text(
//                     outTime,
//                     style: TextStyle(
//                         color: outTime == "--" ? Colors.red : Colors.blue),
//                   ),
//           ),
//         ],
//       ),
//     );
//   }
// }



// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:intl/intl.dart';
//
// class AttendanceList extends StatefulWidget {
//   const AttendanceList({super.key});
//
//   @override
//   State<AttendanceList> createState() => _AttendanceListScreenState();
// }
//
// class _AttendanceListScreenState extends State<AttendanceList> {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   bool _isLoading = true;
//   List<Map<String, dynamic>> _attendanceData = [];
//   List<Map<String, dynamic>> _employees = [];
//   DateTime _selectedDate = DateTime.now();
//
//   @override
//   void initState() {
//     super.initState();
//     _loadEmployeeAttendance();
//   }
//
//   void _loadEmployeeAttendance() async {
//     if (_employees.isEmpty) return; // ✅ Ensure employees are loaded
//
//     final dateKey = DateFormat('yyyy-MM-dd').format(_selectedDate);
//
//     setState(() => _isLoading = true);
//
//     List<Map<String, dynamic>> tempAttendanceData = [];
//
//     try {
//       for (var employee in _employees) {
//         String employeeId = employee['id'];
//
//         final DocumentSnapshot attendanceDoc = await _firestore
//             .collection('users')
//             .doc(employeeId)
//             .collection('attendance')
//             .doc(dateKey)
//             .get();
//
//         if (attendanceDoc.exists) {
//           final data = attendanceDoc.data() as Map<String, dynamic>;
//
//           tempAttendanceData.add({
//             'name': employee['name'],
//             'attendance': (data['status'] ?? '--').toString(),
//             'inTime': (data['inTime'] ?? '--').toString(),
//             'outTime': (data['outTime'] ?? '--').toString(),
//             'isLeave': data['isLeave'] ?? false,
//           });
//         } else {
//           tempAttendanceData.add({
//             'name': employee['name'],
//             'attendance': '--',
//             'inTime': '--',
//             'outTime': '--',
//             'isLeave': false,
//           });
//         }
//       }
//
//       if (mounted) {
//         setState(() {
//           _attendanceData = tempAttendanceData;
//           _isLoading = false;
//         });
//       }
//
//       print("Fetched attendance data: $_attendanceData");
//     } catch (e) {
//       if (mounted) {
//         setState(() {
//           _isLoading = false;
//         });
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Error loading attendance: ${e.toString()}'),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//     }
//   }
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.blue,
//         title: const Text('Employee Attendance',
//             style: TextStyle(color: Colors.white)),
//       ),
//       body: RefreshIndicator(
//         onRefresh: () async => _loadEmployeeAttendance(),
//         child: Column(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(16),
//               child: Row(
//                 children: [
//                   const Icon(Icons.access_time),
//                   const SizedBox(width: 8),
//                   Text(
//                     'Total Employees: ${_attendanceData.length}',
//                     style: TextStyle(fontSize: 16, color: Colors.grey[600]),
//                   ),
//                 ],
//               ),
//             ),
//             Expanded(
//               child: _isLoading
//                   ? const Center(child: CircularProgressIndicator())
//                   : _attendanceData.isEmpty
//                   ? const Center(child: Text('No attendance records found'))
//                   : ListView.builder(
//                 itemCount: _attendanceData.length,
//                 itemBuilder: (context, index) {
//                   final data = _attendanceData[index];
//                   return AttendanceListItem(
//                     name: data['name'],
//                     attendance: data['attendance'],
//                     inTime: data['inTime'],
//                     outTime: data['outTime'],
//                     isLeave: data['isLeave'],
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class AttendanceListItem extends StatelessWidget {
//   final String name;
//   final String attendance;
//   final String inTime;
//   final String outTime;
//   final bool isLeave;
//
//   const AttendanceListItem({
//     super.key,
//     required this.name,
//     required this.attendance,
//     required this.inTime,
//     required this.outTime,
//     required this.isLeave,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       decoration: BoxDecoration(
//         border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
//       ),
//       child: Row(
//         children: [
//           const CircleAvatar(
//             radius: 20,
//             backgroundImage: AssetImage('assets/images/main_profile.png'),
//           ),
//           const SizedBox(width: 8),
//           Expanded(
//             flex: 2,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
//                 Text(attendance,
//                     style: TextStyle(color: Colors.grey[600], fontSize: 12)),
//               ],
//             ),
//           ),
//           Expanded(
//             child: Text(
//               inTime,
//               style:
//               TextStyle(color: inTime == "--" ? Colors.red : Colors.green),
//             ),
//           ),
//           Expanded(
//             child: isLeave
//                 ? Container(
//               padding:
//               const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//               decoration: BoxDecoration(
//                   color: Colors.red,
//                   borderRadius: BorderRadius.circular(12)),
//               child: const Text('Leave',
//                   style: TextStyle(color: Colors.white, fontSize: 12)),
//             )
//                 : Text(
//               outTime,
//               style: TextStyle(
//                   color: outTime == "--" ? Colors.red : Colors.blue),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

//...... import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:intl/intl.dart';
//
// import 'menu_bar/drawer_menu.dart';
//
// class AttendanceList extends StatefulWidget {
//   const AttendanceList({super.key});
//
//   @override
//   State<AttendanceList> createState() => _AttendanceListState();
//
// }
//
// class _AttendanceListState extends State<AttendanceList> {
//
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   bool _isLoading = true;
//   List<Map<String, dynamic>> _attendanceData = [];
//   String _userRole = "employee"; // Default to employee
//    String formatTimestamp(dynamic timestamp) {
//     if (timestamp is Timestamp) {
//       return DateFormat('hh:mm a').format(timestamp.toDate()); // Convert to readable time
//     }
//     return "--"; // Default if null
//   }
//   @override
//   void initState() {
//     super.initState();
//     _loadUserRoleAndAttendance();
//   }
//
//   Future<void> _loadUserRoleAndAttendance() async {
//     if (!mounted) return;
//     setState(() => _isLoading = true);
//
//     try {
//       final User? user = _auth.currentUser;
//       if (user == null) {
//         setState(() => _isLoading = false);
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('User not logged in'), backgroundColor: Colors.red),
//         );
//         return;
//       }
//
//       // ✅ Step 1: Fetch the user's role
//       DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();
//       if (userDoc.exists) {
//         _userRole = (userDoc.data() as Map<String, dynamic>)['role'] ?? "employee";
//       }
//
//       // ✅ Step 2: Load attendance based on role
//       if (_userRole == "admin") {
//         await _loadEmployeeAttendance();
//       } else {
//         await _loadCurrentUserAttendance(user.uid);
//       }
//
//       if (mounted) setState(() => _isLoading = false);
//     } catch (e) {
//       if (mounted) {
//         setState(() => _isLoading = false);
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Error: ${e.toString()}'), backgroundColor: Colors.red),
//         );
//       }
//     }
//   }
//
//   // Future<void> _loadAllEmployeesAttendance() async {
//   //   QuerySnapshot snapshot = await _firestore.collection('users').get();
//   //   List<Map<String, dynamic>> tempList = [];
//   //
//   //   for (var doc in snapshot.docs) {
//   //     String employeeId = doc.id;
//   //     String employeeName = doc['name'] ?? 'Unknown';
//   //     String employeeRole = doc['role'] ?? 'Employee';
//   //
//   //     QuerySnapshot attendanceSnapshot = await _firestore
//   //         .collection('users')
//   //         .doc(employeeId)
//   //         .collection('attendance')
//   //         .get();
//   //
//   //     for (var attendanceDoc in attendanceSnapshot.docs) {
//   //       final data = attendanceDoc.data() as Map<String, dynamic>;
//   //       tempList.add({
//   //         'id': attendanceDoc.id,
//   //         'name': employeeName,
//   //         'role': employeeRole,
//   //         'inTime': formatTimestamp(data['inTime']), // ✅ Convert Timestamp
//   //         'outTime': formatTimestamp(data['outTime']), // ✅
//   //         'isLeave': data['isLeave'] ?? false,
//   //       });
//   //     }
//   //   }
//   //
//   //   if (mounted) setState(() => _attendanceData = tempList);
//   // }
//
//   Future<void> _loadEmployeeAttendance() async {
//     if (!mounted) return;
//
//     setState(() => _isLoading = true);
//     try {
//       // Get the current user
//       final User? user = _auth.currentUser;
//       if (user == null) return;
//
//       // Fetch the role of the logged-in user
//       DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();
//       final userData = userDoc.data() as Map<String, dynamic>?;
//
//       if (userData == null || userData['role'] != 'admin') {
//         setState(() => _isLoading = false);
//         return; // If not an admin, stop execution
//       }
//
//       // Fetch only employee attendance (excluding admin records)
//       final QuerySnapshot snapshot = await _firestore
//           .collection('users')
//           .where('role', isNotEqualTo: 'admin') // ✅ Only employees
//           .get();
//
// // Loop through the documents and print user details
// //       for (var doc in snapshot.docs) {
// //         print(doc.data()); // Prints each document's data as a Map
// //       }
//
//
//       if (!mounted) return;
//
//       setState(() {
//         _attendanceData = snapshot.docs.map((doc) {
//           final data = doc.data() as Map<String, dynamic>;
//           return {
//             'id': doc.id,
//             'name': data['name'] ?? 'Unknown',
//             'role': data['role'] ?? 'Employee',
//             'attendanceRecords': data['attendanceRecords'] ?? '__',
//             'inTime': data.containsKey('inTime') && data['inTime'] != null ? formatTimestamp(data['inTime']) : '--',
//             'outTime': data.containsKey('outTime') && data['outTime'] != null ? formatTimestamp(data['outTime']) : '--',
//             'type': data['type'] ?? false,
//           };
//         }).toList();
//
//         _isLoading = false;
//       });
//     } catch (e) {
//       if (mounted) {
//         setState(() {
//           _isLoading = false;
//           _attendanceData = [];
//         });
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Error loading attendance: ${e.toString()}'),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//     }
//   }
//
//
//   // Future<void> _loadCurrentUserAttendance(String userId) async {
//   //   QuerySnapshot snapshot = await _firestore
//   //       .collection('users')
//   //       .doc(userId)
//   //       .collection('attendanceRecords')
//   //       .get();
//   //
//   //   setState(() {
//   //     _attendanceData = snapshot.docs.map((doc) {
//   //       final data = doc.data() as Map<String, dynamic>;
//   //       return {
//   //         'id': doc.id,
//   //         'name': data['name'] ?? 'Unknown',
//   //         'role': data['role'] ?? 'Employee',
//   //         'attendanceRecords': data['attendanceRecords'] ?? '__',
//   //         'inTime': data['inTime'] ?? '--',
//   //         'outTime': data['outTime'] ?? '--',
//   //         'type': data['type'] ?? false,
//   //       };
//   //     }).toList();
//   //   });
//   // }
//
//   Future<void> _loadCurrentUserAttendance(String userId) async {
//     try {
//       QuerySnapshot snapshot = (await _firestore
//           .collection('users')
//           .doc(userId)
//
//           .get()) as QuerySnapshot<Object?>;
//
//       setState(() {
//         _attendanceData = snapshot.docs.map((doc) {
//           final data = doc.data() as Map<String, dynamic>;
//           return {
//             'id': doc.id,
//             'name': data['name'] ?? 'Unknown',
//             'role': data['role'] ?? 'Employee',
//             'attendanceRecords': data['attendanceRecords'] ?? '__',
//             'inTime': data.containsKey('inTime') && data['inTime'] != null ? formatTimestamp(data['inTime']) : '--',
//             'outTime': data.containsKey('outTime') && data['outTime'] != null ? formatTimestamp(data['outTime']) : '--',
//             'type': data['type'] ?? false,
//
//
//           };
//         }).toList();
//       });
//     } catch (e) {
//       print("Error loading user attendance: $e");
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Error loading attendance: ${e.toString()}"), backgroundColor: Colors.red),
//       );
//     }
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Employee Attendance')),
//       drawer: CustomDrawer(userName: 'Admin', userRole: 'Admin',),
//       body: RefreshIndicator(
//         onRefresh: _loadUserRoleAndAttendance,
//         child: Column(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(16),
//               child: Row(
//                 children: [
//                   const Icon(Icons.access_time),
//                   const SizedBox(width: 8),
//                   Text(
//                     'Total Records: ${_attendanceData.length}',
//                     style: TextStyle(fontSize: 16, color: Colors.grey[600]),
//                   ),
//                 ],
//               ),
//             ),
//
//             Expanded(
//               child: _isLoading
//                   ? const Center(child: CircularProgressIndicator())
//                   : _attendanceData.isEmpty
//                   ? const Center(child: Text('No attendance records found'))
//                   : ListView.builder(
//                 itemCount: _attendanceData.length,
//                 itemBuilder: (context, index) {
//                   final data = _attendanceData[index];
//                   return AttendanceListItem(
//                     name: data['name'],
//                     role: data['role'],
//                     attendanceRecords: data['attendanceRecords'] ,
//                     inTime: data['inTime'],
//                     outTime: data['outTime'],
//                     type: data['type'],
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class AttendanceListItem extends StatelessWidget {
//   final String name;
//   final String role;
//   final String attendanceRecords;
//   final String inTime;
//   final String outTime;
//   final bool type;
//
//   const AttendanceListItem({
//     super.key,
//     required this.name,
//     required this.role,
//     required this.inTime,
//     required this.outTime,
//     required this.type, required this.attendanceRecords,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       decoration: BoxDecoration(
//         border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
//       ),
//       child: Row(
//         children: [
//           CircleAvatar(radius: 20, backgroundImage: AssetImage('assets/images/main_profile.png')),
//           const SizedBox(width: 8),
//           Expanded(
//             flex: 2,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
//                 Text(role, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
//               ],
//             ),
//           ),
//           Expanded(
//             child: Text(inTime, style: TextStyle(color: inTime == "--" ? Colors.red : Colors.green)),
//           ),
//           Expanded(
//             child: type
//                 ? Container(
//               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//               decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(12)),
//               child: const Text('Leave', style: TextStyle(color: Colors.white, fontSize: 12)),
//             )
//                 : Text(outTime, style: TextStyle(color: outTime == "--" ? Colors.red : Colors.blue)),
//           ),
//
//         ],
//       ),
//     );
//
//   }
// }


//
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:intl/intl.dart';
//
// class AttendanceList extends StatefulWidget {
//   const AttendanceList({super.key});
//
//   @override
//   State<AttendanceList> createState() => _AttendanceListState();
// }
//
// class _AttendanceListState extends State<AttendanceList> {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   bool _isLoading = true;
//   List<Map<String, dynamic>> _attendanceData = [];
//   String _userRole = "employee"; // Default role
//
//   /// ✅ Convert Firestore Timestamp to Readable Format
//   String formatTimestamp(dynamic timestamp) {
//     if (timestamp is Timestamp) {
//       return DateFormat('hh:mm a').format(timestamp.toDate()); // Convert Firestore Timestamp
//     } else if (timestamp is String) {
//       return timestamp; // If it's already a string, return it
//     }
//     return "--"; // Default if null
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _loadUserRoleAndAttendance();
//   }
//
//   /// ✅ Fetch user role and attendance data
//   Future<void> _loadUserRoleAndAttendance() async {
//     if (!mounted) return;
//     setState(() => _isLoading = true);
//
//     try {
//       final User? user = _auth.currentUser;
//       if (user == null) throw Exception('User not authenticated');
//
//       // Fetch user role
//       final userDoc = await _firestore.collection('users').doc(user.uid).get();
//       if (!userDoc.exists) throw Exception('User not found');
//
//       _userRole = userDoc.data()?['role'] ?? 'employee';
//       print('User role: $_userRole');
//
//       // Load attendance based on role
//       if (_userRole == "admin") {
//         await _loadEmployeeAttendance();
//       } else {
//         await _loadCurrentUserAttendance(user.uid);
//       }
//
//       if (!mounted) return;
//       setState(() => _isLoading = false);
//     } catch (e) {
//       print('Error in _loadUserRoleAndAttendance: $e');
//       if (!mounted) return;
//       setState(() {
//         _isLoading = false;
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
//         );
//       });
//     }
//   }
//
//   /// ✅ Fetch all employees' attendance (Admin view)
//   Future<void> _loadEmployeeAttendance() async {
//     if (!mounted) return;
//     setState(() => _isLoading = true);
//
//     try {
//       final QuerySnapshot employeeSnapshot = await _firestore
//           .collection('users')
//           .where('role', isEqualTo: 'employee')
//           .get();
//
//       List<Map<String, dynamic>> tempList = [];
//
//       for (var employeeDoc in employeeSnapshot.docs) {
//         String employeeName = employeeDoc['name'] ?? 'Unknown';
//         final userData = employeeDoc.data() as Map<String, dynamic>?;
//         final List<dynamic> attendanceList = userData?['attendance'] ?? [];
//
//         for (var record in attendanceList) {
//           tempList.add({
//             'name': employeeName,
//             'date': record['date'] ?? '--',
//             'inTime': record['inTime'] is Timestamp
//                 ? formatTimestamp(record['inTime'])
//                 : '--',
//             'outTime': record['outTime'] is Timestamp
//                 ? formatTimestamp(record['outTime'])
//                 : '--',
//             'type': record['type'] ?? 'attendance',
//           });
//         }
//       }
//
//       if (!mounted) return;
//       setState(() => _attendanceData = tempList);
//     } catch (e) {
//       print('Error loading employee attendance: $e');
//       if (!mounted) return;
//       setState(() => _isLoading = false);
//     }
//   }
//
//   /// ✅ Fetch current user's attendance
//   Future<void> _loadCurrentUserAttendance(String userId) async {
//     try {
//       DocumentSnapshot userDoc = await _firestore.collection('users').doc(userId).get();
//
//       if (userDoc.exists) {
//         final userData = userDoc.data() as Map<String, dynamic>?;
//         final List<dynamic> attendanceList = userData?['attendance'] ?? [];
//
//         List<Map<String, dynamic>> tempList = [];
//
//         for (var record in attendanceList) {
//           tempList.add({
//             'date': record['date'] ?? '--',
//             'inTime': record['inTime'] is Timestamp
//                 ? formatTimestamp(record['inTime'])
//                 : '--',
//             'outTime': record['outTime'] is Timestamp
//                 ? formatTimestamp(record['outTime'])
//                 : '--',
//             'type': record['type'] ?? 'attendance',
//           });
//         }
//
//         if (!mounted) return;
//         setState(() => _attendanceData = tempList);
//       }
//     } catch (e) {
//       print("Error loading user attendance: $e");
//       if (!mounted) return;
//       setState(() => _isLoading = false);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Employee Attendance')),
//       body: RefreshIndicator(
//         onRefresh: _loadUserRoleAndAttendance,
//         child: Column(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(16),
//               child: Row(
//                 children: [
//                   const Icon(Icons.access_time),
//                   const SizedBox(width: 8),
//                   Text(
//                     'Total Records: ${_attendanceData.length}',
//                     style: TextStyle(fontSize: 16, color: Colors.grey[600]),
//                   ),
//                 ],
//               ),
//             ),
//             Expanded(
//               child: _isLoading
//                   ? const Center(child: CircularProgressIndicator())
//                   : _attendanceData.isEmpty
//                   ? const Center(child: Text('No attendance records found'))
//                   : ListView.builder(
//                 itemCount: _attendanceData.length,
//                 itemBuilder: (context, index) {
//                   final data = _attendanceData[index];
//                   return AttendanceListItem(
//                     name: data['name'] ?? "You",
//                     date: data['date'],
//                     inTime: data['inTime'],
//                     outTime: data['outTime'],
//                     type: data['type'],
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// /// ✅ Attendance List Item Widget
// class AttendanceListItem extends StatelessWidget {
//   final String name;
//   final String date;
//   final String inTime;
//   final String outTime;
//   final String type;
//
//   const AttendanceListItem({
//     super.key,
//     required this.name,
//     required this.date,
//     required this.inTime,
//     required this.outTime,
//     required this.type,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//       child: ListTile(
//         title: Text("$name - $date", style: TextStyle(fontWeight: FontWeight.bold)),
//         subtitle: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             type == "leave"
//                 ? Text("Leave", style: TextStyle(color: Colors.red))
//                 : Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text("In Time: $inTime", style: TextStyle(color: Colors.green)),
//                 Text("Out Time: $outTime", style: TextStyle(color: Colors.blue)),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'menu_bar/drawer_menu.dart';
import 'dart:async';

class AttendanceList extends StatefulWidget {
  const AttendanceList({super.key});

  @override
  State<AttendanceList> createState() => _AttendanceListState();
}

class _AttendanceListState extends State<AttendanceList> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = true;
  List<AttendanceRecord> _attendanceData = [];
  String _userRole = "employee";

  String formatTimestamp(dynamic timestamp) {
    if (timestamp is Timestamp) {
      return DateFormat('hh:mm a').format(timestamp.toDate());
    }
    return "--";
  }

  @override
  void initState() {
    super.initState();
    _loadUserRoleAndAttendance();

  }

  Future<void> _loadUserRoleAndAttendance() async {
    if (!mounted) return;
    setState(() => _isLoading = true);

    try {
      final User? user = _auth.currentUser;
      if (user == null) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not logged in'), backgroundColor: Colors.red),
        );
        return;
      }

      // ✅ Fetch the user's role
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();
      final userData = userDoc.data() as Map<String, dynamic>? ?? {};
      _userRole = userData['role'] ?? "employee";

      // ✅ Load attendance based on role
      if (_userRole == "admin") {
        await _loadEmployeeAttendance();
      } else {
        await _loadCurrentUserAttendance(user.uid);
      }

      if (mounted) setState(() => _isLoading = false);
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _loadEmployeeAttendance() async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('users')
          .where('role', isNotEqualTo: 'admin')
          .get();

      if (!mounted) return;

      String todayDate = DateFormat('dd-MM-yyyy').format(DateTime.now());

      setState(() {
        _attendanceData = snapshot.docs.expand((doc) {
          final data = doc.data() as Map<String, dynamic>? ?? {};
          List<dynamic> records = data['attendanceRecords'] ?? [];

          return records
              .map((record) => AttendanceRecord.fromFirestore(record as Map<String, dynamic>))
              .where((record) => record.date == todayDate) // ✅ Show only today's records
              .toList();
        }).toList();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading attendance: ${e.toString()}'), backgroundColor: Colors.red),
      );
    }
  }


  Future<void> _loadCurrentUserAttendance(String userId) async {
    try {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(userId).get();
      final data = userDoc.data() as Map<String, dynamic>? ?? {};

      List<dynamic> records = data['attendanceRecords'] ?? [];

      // ✅ Get today's date in yyyy-MM-dd format
      String todayDate = DateFormat('dd-MM-yyyy').format(DateTime.now());

      List<AttendanceRecord> formattedAttendance = records
          .map((record) => AttendanceRecord.fromFirestore(record as Map<String, dynamic>))
          .where((record) => record.date == todayDate) // ✅ Show only today's records
          .toList();

      setState(() {
        _attendanceData = formattedAttendance;
      });

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error loading attendance: ${e.toString()}"), backgroundColor: Colors.red),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Employee Attendance')),
      drawer: const CustomDrawer(userName: 'Admin', userRole: 'Admin'),
      body: RefreshIndicator(
        onRefresh: _loadUserRoleAndAttendance,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.access_time),
                  const SizedBox(width: 8),
                  Text(
                    'Total Records: ${_attendanceData.length}',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),

            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _attendanceData.isEmpty
                  ? const Center(child: Text('No attendance records found'))
                  : ListView.builder(
                itemCount: _attendanceData.length,
                itemBuilder: (context, index) {
                  final attendance = _attendanceData[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: Card(
                      elevation: 3, // Adds a shadow effect
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        title: Text(
                          attendance.Name,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        subtitle: attendance.type == "leave"
                            ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Leave",
                              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4), // Spacing between "Leave" and Note
                            Text(
                              "Note: ${attendance.note.isNotEmpty ? attendance.note : 'No note provided'}",
                              style: const TextStyle(color: Colors.black87, fontStyle: FontStyle.italic),
                            ),
                          ],
                        )
                            : Text(
                          "In: ${attendance.inTime} | Out: ${attendance.outTime}",
                          style: TextStyle(
                            color: attendance.outTime == "--" ? Colors.orange : Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                    ),
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




class AttendanceRecord {
  final String date;
  final String Name;
  final String inTime;
  final String outTime;
  final String type;
  final String userId;
  final String note;

  AttendanceRecord({
    required this.date,
    required this.Name,
    required this.inTime,
    required this.outTime,
    required this.type,
    required this.userId,
    required this.note,
  });

  factory AttendanceRecord.fromFirestore(Map<String, dynamic> data) {
    return AttendanceRecord(
      date: data['date'] ?? 'Unknown',
      Name: data['Name'] ?? 'Unknown',
      inTime: data.containsKey('inTime') && data['inTime'] != null
          ? DateFormat('hh:mm a').format((data['inTime'] as Timestamp).toDate())
          : '--',
      outTime: data.containsKey('outTime') && data['outTime'] != null
          ? DateFormat('hh:mm a').format((data['outTime'] as Timestamp).toDate())
          : '--',
      type: data['type'] ?? 'Unknown',
      userId: data['userId'] ?? 'Unknown',
      note: data['note'] ?? '',
    );
  }
}

// class AttendanceListItem extends StatelessWidget {
//   final AttendanceRecord attendance;
//
//   const AttendanceListItem({super.key, required this.attendance});
//
//
//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       title: Text(attendance.employeeName),
//       subtitle: attendance.type == "leave"
//           ? Text(
//         " Leave",
//         style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
//       )
//           : Text.rich(
//         TextSpan(
//           children: [
//             const TextSpan(text: "In: ", style: TextStyle(fontWeight: FontWeight.bold)),
//             TextSpan(text: attendance.inTime, style: const TextStyle(color: Colors.blue)),
//             const TextSpan(text: "  |  Out: ", style: TextStyle(fontWeight: FontWeight.bold)),
//             TextSpan(text: attendance.outTime, style: const TextStyle(color: Colors.blue)),
//           ],
//         ),
//       ),
//     );
//   }
// }

