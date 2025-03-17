// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:table_calendar/table_calendar.dart';
// import 'package:intl/intl.dart';
//
// class AdminCalendarPage extends StatefulWidget {
//   const AdminCalendarPage({super.key});
//
//   @override
//   State<AdminCalendarPage> createState() => _AdminCalendarPageState();
// }
//
// class _AdminCalendarPageState extends State<AdminCalendarPage> {
//   DateTime _focusedDay = DateTime.now();
//   DateTime? _selectedDay;
//   Map<DateTime, List<Map<String, String>>> leaveData = {}; // Stores leave dates and employee details
//
//   @override
//   void initState() {
//     super.initState();
//     fetchLeaveData();
//   }
//
//   /// ✅ Fetch Leave Data from Firestore
//   Future<void> fetchLeaveData() async {
//     QuerySnapshot usersSnapshot = await FirebaseFirestore.instance.collection('users').get();
//     Map<DateTime, List<Map<String, String>>> tempLeaveData = {};
//
//     for (var doc in usersSnapshot.docs) {
//       final userData = doc.data() as Map<String, dynamic>;
//       final attendanceRecords = userData['attendanceRecords'] ?? [];
//
//       for (var record in attendanceRecords) {
//         if (record['type'] == 'leave') {
//           try {
//             DateTime leaveDate = DateFormat('dd-MM-yyyy').parse(record['date']);
//             String status = record['status'] ?? 'Pending';
//
//             print("Fetched Leave: ${record['date']} - Status: $status - Employee: ${userData['employeeName']}");
//
//             if (!tempLeaveData.containsKey(leaveDate)) {
//               tempLeaveData[leaveDate] = [];
//             }
//
//             tempLeaveData[leaveDate]!.add({
//               'name': userData['employeeName'] ?? 'Unknown',
//               'status': status,
//             });
//           } catch (e) {
//             print("Error parsing date: ${record['date']}, Error: $e");
//           }
//         }
//       }
//     }
//
//     setState(() {
//       leaveData = tempLeaveData;
//     });
//
//     print("Leave Data Loaded: $leaveData"); // Debug output
//   }
//
//
//   /// ✅ Show Leave Days with a Dot (Red for Accepted, Orange for Pending)
//   Widget _buildMarker(DateTime day, List<Map<String, String>> events) {
//     bool hasAccepted = events.any((e) => e['status'] == 'Accepted');
//     bool hasPending = events.any((e) => e['status'] == 'Pending');
//
//     return Stack(
//       children: [
//         if (hasAccepted)
//           Positioned(
//             bottom: 4,
//             child: Container(
//               width: 6,
//               height: 6,
//               decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.red),
//             ),
//           ),
//         if (hasPending)
//           Positioned(
//             bottom: 4,
//             right: 8,
//             child: Container(
//               width: 6,
//               height: 6,
//               decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.orange),
//             ),
//           ),
//       ],
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Leave Calendar")),
//       body: Column(
//         children: [
//           TableCalendar(
//             focusedDay: _focusedDay,
//             firstDay: DateTime(2024),
//             lastDay: DateTime(2026),
//             calendarFormat: CalendarFormat.month,
//             selectedDayPredicate: (day) {
//               return isSameDay(_selectedDay, day);
//             },
//             onDaySelected: (selectedDay, focusedDay) {
//               setState(() {
//                 _selectedDay = selectedDay;
//                 _focusedDay = focusedDay;
//               });
//             },
//             eventLoader: (day) => leaveData[day] ?? [],
//             calendarBuilders: CalendarBuilders(
//               markerBuilder: (context, date, events) {
//                 return _buildMarker(date, events.cast<Map<String, String>>());
//               },
//             ),
//           ),
//
//           /// ✅ Show Employee List for Selected Day
//           if (_selectedDay != null) ...[
//             const SizedBox(height: 16),
//             Text(
//               "Employees on Leave - ${DateFormat('dd MMM yyyy').format(_selectedDay!)}",
//               style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             ),
//             Expanded(
//               child: leaveData[_selectedDay] != null
//                   ? ListView.builder(
//                 itemCount: leaveData[_selectedDay]!.length,
//                 itemBuilder: (context, index) {
//                   var employee = leaveData[_selectedDay]![index];
//                   return ListTile(
//                     leading: const Icon(Icons.person, color: Colors.blue),
//                     title: Text(employee['name']!),
//                     trailing: Text(
//                       employee['status']!,
//                       style: TextStyle(
//                         color: employee['status'] == 'Accepted' ? Colors.green : Colors.orange,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   );
//                 },
//               )
//                   : const Center(child: Text("No leave requests for this day")),
//             ),
//           ],
//         ],
//       ),
//     );
//   }
// }

//
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:table_calendar/table_calendar.dart';
// import 'package:intl/intl.dart';
//
// class AdminCalendarPage extends StatefulWidget {
//   const AdminCalendarPage({super.key});
//
//   @override
//   State<AdminCalendarPage> createState() => _AdminCalendarPageState();
// }
//
// class _AdminCalendarPageState extends State<AdminCalendarPage> {
//   DateTime _focusedDay = DateTime.now();
//   DateTime? _selectedDay;
//   Map<DateTime, List<Map<String, String>>> leaveData = {}; // Stores leave records
//
//   @override
//   void initState() {
//     super.initState();
//     fetchLeaveData();
//   }
//
//   /// ✅ Fetch Leave Data from Firestore
//   Future<void> fetchLeaveData() async {
//     QuerySnapshot usersSnapshot = await FirebaseFirestore.instance.collection('users').get();
//     Map<DateTime, List<Map<String, String>>> tempLeaveData = {};
//
//     for (var doc in usersSnapshot.docs) {
//       final userData = doc.data() as Map<String, dynamic>;
//       final attendanceRecords = userData['attendanceRecords'] ?? [];
//
//       for (var record in attendanceRecords) {
//         if (record['type'] == 'leave') {
//           try {
//             DateTime leaveDate = DateFormat('dd-MM-yyyy').parse(record['date']);
//             String status = record['status'] ?? 'Pending';
//
//             print("Fetched Leave: ${record['date']} - Status: $status - Employee: ${userData['employeeName']}");
//
//             if (!tempLeaveData.containsKey(leaveDate)) {
//               tempLeaveData[leaveDate] = [];
//             }
//
//             tempLeaveData[leaveDate]!.add({
//               'name': userData['employeeName'] ?? 'Unknown',
//               'status': status,
//             });
//           } catch (e) {
//             print("Error parsing date: ${record['date']}, Error: $e");
//           }
//         }
//       }
//     }
//
//     setState(() {
//       leaveData = tempLeaveData;
//     });
//
//     print("Leave Data Loaded: $leaveData"); // Debug output
//   }
//
//   /// ✅ Show Leave Days with Dots (Red for Accepted, Orange for Pending)
//   /// ✅ Show Leave Days with Dots (Red for Accepted, Orange for Pending)
//   Widget _buildMarker(DateTime day, List<Map<String, String>> events) {
//     bool hasAccepted = events.any((e) => e['status'] == 'Accepted');
//     bool hasPending = events.any((e) => e['status'] == 'Pending');
//
//     List<Widget> markers = [];
//
//     if (hasAccepted) {
//       markers.add(Container(
//         width: 8,
//         height: 8,
//         margin: const EdgeInsets.only(right: 2),
//         decoration: const BoxDecoration(
//           shape: BoxShape.circle,
//           color: Colors.red, // Red for Accepted Leave
//         ),
//       ));
//     }
//
//     if (hasPending) {
//       markers.add(Container(
//         width: 8,
//         height: 8,
//         decoration: const BoxDecoration(
//           shape: BoxShape.circle,
//           color: Colors.orange, // Orange for Pending Leave
//         ),
//       ));
//     }
//
//     return markers.isNotEmpty
//         ? Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: markers,
//     )
//         : const SizedBox();
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Leave Calendar")),
//       body: Column(
//         children: [
//           TableCalendar(
//             focusedDay: _focusedDay,
//             firstDay: DateTime(2024),
//             lastDay: DateTime(2026),
//             calendarFormat: CalendarFormat.month,
//             selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
//             onDaySelected: (selectedDay, focusedDay) {
//               setState(() {
//                 _selectedDay = selectedDay;
//                 _focusedDay = focusedDay;
//               });
//             },
//             eventLoader: (day) => leaveData[day] ?? [],
//             calendarBuilders: CalendarBuilders(
//               markerBuilder: (context, date, events) {
//                 return _buildMarker(date, events.cast<Map<String, String>>());
//               },
//             ),
//           ),
//
//           /// ✅ Show Employee List for Selected Day
//           if (_selectedDay != null) ...[
//             const SizedBox(height: 16),
//             Text(
//               "Employees on Leave - ${DateFormat('dd MMM yyyy').format(_selectedDay!)}",
//               style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             ),
//             Expanded(
//               child: leaveData[_selectedDay] != null
//                   ? ListView.builder(
//                 itemCount: leaveData[_selectedDay]!.length,
//                 itemBuilder: (context, index) {
//                   var employee = leaveData[_selectedDay]![index];
//                   return ListTile(
//                     leading: const Icon(Icons.person, color: Colors.blue),
//                     title: Text(employee['name']!),
//                     trailing: Text(
//                       employee['status']!,
//                       style: TextStyle(
//                         color: employee['status'] == 'Accepted' ? Colors.green : Colors.orange,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   );
//                 },
//               )
//                   : const Center(child: Text("No leave requests for this day")),
//             ),
//           ],
//         ],
//       ),
//     );
//   }
// }



// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:table_calendar/table_calendar.dart';
// import 'package:intl/intl.dart';
//
// class AdminCalendarPage extends StatefulWidget {
//   const AdminCalendarPage({super.key});
//
//   @override
//   State<AdminCalendarPage> createState() => _AdminCalendarPageState();
// }
//
// class _AdminCalendarPageState extends State<AdminCalendarPage> {
//   DateTime _focusedDay = DateTime.now();
//   DateTime? _selectedDay;
//   Map<DateTime, Map<String, List<String>>> leaveData = {}; // Stores leave records
//
//   @override
//   void initState() {
//     super.initState();
//     fetchLeaveData();
//   }
//
//   /// ✅ Fetch Leave Data from Firestore
//   Future<void> fetchLeaveData() async {
//     QuerySnapshot usersSnapshot = await FirebaseFirestore.instance.collection('users').get();
//     Map<DateTime, Map<String, List<String>>> tempLeaveData = {};
//
//     for (var doc in usersSnapshot.docs) {
//       final userData = doc.data() as Map<String, dynamic>;
//       final attendanceRecords = userData['attendanceRecords'] ?? [];
//
//       for (var record in attendanceRecords) {
//         if (record['type'] == 'leave') {
//           try {
//             DateTime leaveDate = DateFormat('dd-MM-yyyy').parse(record['date']);
//             String status = record['status'] ?? 'Pending';
//             String employeeName = userData['employeeName'] ?? 'Unknown';
//
//             print("Fetched Leave: ${record['date']} - Status: $status - Employee: $employeeName");
//
//             // Initialize date entry if not present
//             tempLeaveData.putIfAbsent(leaveDate, () => {'Accepted': [], 'Pending': []});
//
//             // Store employee names based on status
//             tempLeaveData[leaveDate]![status]!.add(employeeName);
//           } catch (e) {
//             print("Error parsing date: ${record['date']}, Error: $e");
//           }
//         }
//       }
//     }
//
//     setState(() {
//       leaveData = tempLeaveData;
//     });
//
//     print("Leave Data Loaded: $leaveData"); // Debug output
//   }
//
//   /// ✅ Show Correct Dots (Red for Accepted, Orange for Pending)
//   Widget _buildMarker(DateTime day, Map<String, List<String>>? events) {
//     if (events == null || events.isEmpty) return const SizedBox();
//
//     bool hasAccepted = events['Accepted']!.isNotEmpty;
//     bool hasPending = events['Pending']!.isNotEmpty;
//
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         if (hasAccepted)
//           Container(
//             width: 8,
//             height: 8,
//             margin: const EdgeInsets.only(right: 2),
//             decoration: const BoxDecoration(
//               shape: BoxShape.circle,
//               color: Colors.red,
//             ),
//           ),
//         if (hasPending)
//           Container(
//             width: 8,
//             height: 8,
//             decoration: const BoxDecoration(
//               shape: BoxShape.circle,
//               color: Colors.orange,
//             ),
//           ),
//       ],
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Leave Calendar")),
//       body: Column(
//         children: [
//           TableCalendar(
//             focusedDay: _focusedDay,
//             firstDay: DateTime(2024),
//             lastDay: DateTime(2026),
//             calendarFormat: CalendarFormat.month,
//             selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
//             onDaySelected: (selectedDay, focusedDay) {
//               setState(() {
//                 _selectedDay = selectedDay;
//                 _focusedDay = focusedDay;
//               });
//             },
//             eventLoader: (day) {
//               return leaveData.containsKey(day) ? leaveData[day]! : {};
//             },
//             calendarBuilders: CalendarBuilders(
//               markerBuilder: (context, date, events) {
//                 return _buildMarker(date, events as Map<String, List<String>>?);
//               },
//             ),
//           ),
//
//           /// ✅ Show Employee List for Selected Day
//           if (_selectedDay != null) ...[
//             const SizedBox(height: 16),
//             Text(
//               "Employees on Leave - ${DateFormat('dd MMM yyyy').format(_selectedDay!)}",
//               style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             ),
//             Expanded(
//               child: leaveData[_selectedDay] != null
//                   ? ListView.builder(
//                 itemCount: (leaveData[_selectedDay]!['Accepted']!.length +
//                     leaveData[_selectedDay]!['Pending']!.length),
//                 itemBuilder: (context, index) {
//                   var employees = [
//                     ...leaveData[_selectedDay]!['Accepted']!.map((e) => {'name': e, 'status': 'Accepted'}),
//                     ...leaveData[_selectedDay]!['Pending']!.map((e) => {'name': e, 'status': 'Pending'}),
//                   ];
//                   var employee = employees[index];
//
//                   return ListTile(
//                     leading: const Icon(Icons.person, color: Colors.blue),
//                     title: Text(employee['name']!),
//                     trailing: Text(
//                       employee['status']!,
//                       style: TextStyle(
//                         color: employee['status'] == 'Accepted' ? Colors.green : Colors.orange,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   );
//                 },
//               )
//                   : const Center(child: Text("No leave requests for this day")),
//             ),
//           ],
//         ],
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'dart:collection';

class AdminCalendarPage extends StatefulWidget {
  const AdminCalendarPage({super.key});

  @override
  State<AdminCalendarPage> createState() => _AdminCalendarPageState();
}

class _AdminCalendarPageState extends State<AdminCalendarPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<Map<String, String>>> leaveData = {}; // Stores leave records

  @override
  void initState() {
    super.initState();
    fetchLeaveData();
  }

  /// ✅ Fetch Leave Data from Firestore
  Future<void> fetchLeaveData() async {
    QuerySnapshot usersSnapshot = await FirebaseFirestore.instance.collection('users').get();
    Map<DateTime, List<Map<String, String>>> tempLeaveData = {};

    for (var doc in usersSnapshot.docs) {
      final userData = doc.data() as Map<String, dynamic>;
      final attendanceRecords = userData['attendanceRecords'] ?? [];

      for (var record in attendanceRecords) {
        if (record['type'] == 'leave') {
          try {
            DateTime leaveDate = DateFormat('dd-MM-yyyy').parse(record['date']);
            String status = record['status'] ?? 'Pending';
            String employeeName = userData['employeeName'] ?? 'Unknown';

            if (!tempLeaveData.containsKey(leaveDate)) {
              tempLeaveData[leaveDate] = [];
            }

            // Convert LinkedMap to a proper Map<String, String>
            Map<String, String> formattedRecord = {
              'name': employeeName,
              'status': status,
            };

            tempLeaveData[leaveDate]!.add(formattedRecord);
          } catch (e) {
            print("Error parsing date: ${record['date']}, Error: $e");
          }
        }
      }
    }

    setState(() {
      leaveData = tempLeaveData;
    });

    print("Leave Data Loaded: $leaveData"); // Debug output
  }

  /// ✅ Custom Dot Marker for Leave Days
  Widget _buildMarker(DateTime day, List<dynamic> events) {
    bool hasAccepted = events.any((e) => (e as Map<String, String>)['status'] == 'Accepted');
    bool hasPending = events.any((e) => (e as Map<String, String>)['status'] == 'Pending');

    List<Widget> markers = [];
    if (hasAccepted) {
      markers.add(
        Container(
          width: 6,
          height: 6,
          margin: const EdgeInsets.only(right: 2),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.red, // Red dot for accepted leaves
          ),
        ),
      );
    }
    if (hasPending) {
      markers.add(
        Container(
          width: 6,
          height: 6,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.orange, // Orange dot for pending leaves
          ),
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: markers,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Leave Calendar")),
      body: Column(
        children: [
          TableCalendar(
            focusedDay: _focusedDay,
            firstDay: DateTime(2024),
            lastDay: DateTime(2026),
            calendarFormat: CalendarFormat.month,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            eventLoader: (day) {
              return leaveData[day]?.map((e) => Map<String, String>.from(e)).toList() ?? [];
            },
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, date, events) {
                return events.isNotEmpty ? _buildMarker(date, events.cast<Map<String, String>>()) : const SizedBox();
              },
            ),
          ),

          /// ✅ Show Employee List for Selected Day
          if (_selectedDay != null) ...[
            const SizedBox(height: 16),
            Text(
              "Employees on Leave - ${DateFormat('dd MMM yyyy').format(_selectedDay!)}",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: leaveData[_selectedDay] != null
                  ? ListView.builder(
                itemCount: leaveData[_selectedDay]!.length,
                itemBuilder: (context, index) {
                  var employee = leaveData[_selectedDay]![index];

                  return ListTile(
                    leading: const Icon(Icons.person, color: Colors.blue),
                    title: Text(employee['name']!),
                    trailing: Text(
                      employee['status']!,
                      style: TextStyle(
                        color: employee['status'] == 'Accepted' ? Colors.green : Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
              )
                  : const Center(child: Text("No leave requests for this day")),
            ),
          ],
        ],
      ),
    );
  }
}
