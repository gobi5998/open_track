//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
//
// class LeaveListScreen extends StatefulWidget {
//   @override
//   _LeaveListScreenState createState() => _LeaveListScreenState();
// }
//
// class _LeaveListScreenState extends State<LeaveListScreen> {
//   Stream<Map<int, int>> getMonthlyLeaveDaysStream() {
//     final String? currentUserId = FirebaseAuth.instance.currentUser?.uid;
//
//     if (currentUserId == null) {
//       return Stream.value({});
//     }
//
//     return FirebaseFirestore.instance
//         .collection('users')
//         .doc(currentUserId)
//         .snapshots()
//         .map((doc) {
//       if (!doc.exists) return {};
//
//       final data = doc.data()!;
//       Map<int, int> leaveDaysPerMonth = {
//         for (int i = 1; i <= 12; i++) i: 0
//       }; // Initialize all months with 0
//
//       if (data.containsKey('attendanceRecords') &&
//           data['attendanceRecords'] is List) {
//         for (var record in data['attendanceRecords']) {
//           if (record['type'] == 'leave' && record['dd-MM-yyyy'] != null) {
//             try {
//               DateTime leaveDate;
//
//               // ✅ Fix: Handle both Timestamp and String formats
//               if (record['dd-MM-yyyy'] is Timestamp) {
//                 leaveDate = (record['dd-MM-yyyy'] as Timestamp).toDate();
//               } else if (record['dd-MM-yyyy'] is String) {
//                 leaveDate = DateTime.parse(record['dd-MM-yyyy']); // Format: yyyy-MM-dd
//               } else {
//                 continue; // Skip invalid records
//               }
//
//               int month = leaveDate.month;
//               leaveDaysPerMonth[month] = (leaveDaysPerMonth[month] ?? 0) + 1;
//               print(record);
//             } catch (e) {
//               print("❌ Error parsing leave date: $e");
//             }
//           }
//         }
//       }
//       return leaveDaysPerMonth;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//             title: const Text('Leave Days List'), backgroundColor: Colors.blue),
//         body: StreamBuilder<Map<int, int>>(
//             stream: getMonthlyLeaveDaysStream(),
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return const Center(child: CircularProgressIndicator());
//               }
//               if (snapshot.hasError) {
//                 return Center(child: Text("Error: ${snapshot.error}"));
//               }
//
//               Map<int, int> leaveData = snapshot.data ?? {};
//               List<String> months = [
//                 'January',
//                 'February',
//                 'March',
//                 'April',
//                 'May',
//                 'June',
//                 'July',
//                 'August',
//                 'September',
//                 'October',
//                 'November',
//                 'December'
//               ];
//
//               return ListView.builder(
//                 itemCount: 12,
//                 itemBuilder: (context, index) {
//                   int month = index + 1;
//                   int leaveDays = leaveData[month] ?? 0;
//
//                   return ListTile(
//                     leading: CircleAvatar(
//                         backgroundImage:
//                         const AssetImage('assets/images/main_profile.png')),
//                     title: Text(months[index],
//                         style: const TextStyle(
//                             fontSize: 16, fontWeight: FontWeight.bold)),
//                     subtitle: Text("Leave Days: $leaveDays"),
//                   );
//                 },
//               );
//             }));
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import for date formatting

class LeaveListScreen extends StatefulWidget {
  @override
  _LeaveListScreenState createState() => _LeaveListScreenState();
}

class _LeaveListScreenState extends State<LeaveListScreen> {
  final String? currentUserId = FirebaseAuth.instance.currentUser?.uid;

  /// ✅ Fetches both **work hours & leave days** dynamically
  Stream<Map<String, dynamic>> getEmployeeDataStream() {
    final String? currentUserId = FirebaseAuth.instance.currentUser?.uid;

    if (currentUserId == null) {
      return Stream.value({});
    }

    return FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserId)
        .snapshots()
        .map((doc) {
      if (!doc.exists) return {};

      final data = doc.data()!;
      Map<String, double> dailyWorkHours = {};
      Map<String, double> dailyLeaveHours = {};
      Map<int, int> leaveDaysPerMonth = {for (int i = 1; i <= 12; i++) i: 0};

      if (data.containsKey('attendanceRecords') &&
          data['attendanceRecords'] is List) {
        for (var record in data['attendanceRecords']) {
          double workHours = 0;
          double leaveHours = (record['type'] == 'leave') ? 8.0 : 0.0;

          // ✅ Safe parsing of date
          String? dateStr = record['date'];
          if (dateStr != null && dateStr.isNotEmpty) {
            try {
              DateTime leaveDate = DateFormat('dd-MM-yyyy').parse(dateStr);
              int month = leaveDate.month;
              leaveDaysPerMonth[month] = (leaveDaysPerMonth[month] ?? 0) + 1;
            } catch (e) {
              print("❌ Error parsing leave date: $e");
            }
          }

          // ✅ Safe parsing of inTime and outTime
          DateTime? inTime = (record['inTime'] != null)
              ? (record['inTime'] as Timestamp).toDate()
              : null;
          DateTime? outTime = (record['outTime'] != null)
              ? (record['outTime'] as Timestamp).toDate()
              : null;

          if (inTime != null && outTime != null && outTime.isAfter(inTime)) {
            workHours = outTime.difference(inTime).inHours.toDouble();
          }

          String dateKey = dateStr ?? "Unknown";
          dailyWorkHours[dateKey] = (dailyWorkHours[dateKey] ?? 0) + workHours;
          dailyLeaveHours[dateKey] =
              (dailyLeaveHours[dateKey] ?? 0) + leaveHours;
        }
      }

      return {
        'name': data['name'] ?? '',
        'photoURL': data['photoURL'] ?? '',
        'dailyWorkHours': dailyWorkHours,
        'dailyLeaveHours': dailyLeaveHours,
        'leaveDaysPerMonth': leaveDaysPerMonth,
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text('Leave & Work Hours'),
            backgroundColor: Colors.blue),
        body: StreamBuilder<Map<String, dynamic>>(
            stream: getEmployeeDataStream(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              }

              Map<String, dynamic> employeeData = snapshot.data ?? {};
              Map<int, int> leaveData = employeeData['leaveDaysPerMonth'] ?? {};
              Map<String, double> dailyWorkHours =
                  employeeData['dailyWorkHours'] ?? {};
              Map<String, double> dailyLeaveHours =
                  employeeData['dailyLeaveHours'] ?? {};
              String employeeName = employeeData['name'] ?? "Unknown";

              List<String> months = [
                'January',
                'February',
                'March',
                'April',
                'May',
                'June',
                'July',
                'August',
                'September',
                'October',
                'November',
                'December'
              ];

              return Column(
                children: [
                  // ✅ Employee Name
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Employee: $employeeName",
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                  ),

                  // ✅ Leave Summary List
                  Expanded(
                    child: ListView.builder(
                      itemCount: 12,
                      itemBuilder: (context, index) {
                        int month = index + 1;
                        int leaveDays = leaveData[month] ?? 0;

                        return ListTile(
                          leading: const Icon(Icons.calendar_today,
                              color: Colors.blue),
                          title: Text(months[index],
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          subtitle: Text("Leave Days: $leaveDays",
                              style: TextStyle(
                                  color: leaveDays > 0
                                      ? Colors.red
                                      : Colors.black)),
                        );
                      },
                    ),
                  ),

                  // ✅ Work Hours Summary
                  // Expanded(
                  //   child: ListView(
                  //     children: dailyWorkHours.keys.map((date) {
                  //       return ListTile(
                  //         leading: const Icon(Icons.access_time, color: Colors.green),
                  //         title: Text("Date: $date",
                  //             style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  //         subtitle: Text(
                  //             "Work Hours: ${dailyWorkHours[date]?.toStringAsFixed(2)} hrs | Leave Hours: ${dailyLeaveHours[date]?.toStringAsFixed(2)} hrs",
                  //             style: const TextStyle(color: Colors.black)),
                  //       );
                  //     }).toList(),
                  //   ),
                  // ),
                ],
              );
            }));
  }
}
