// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'calendar_page.dart';
// import 'leave_details_page.dart';
//
// class LeavePage extends StatefulWidget {
//   const LeavePage({super.key});
//
//   @override
//   State<LeavePage> createState() => _LeavePageState();
// }
//
// class _LeavePageState extends State<LeavePage> {
//   String _selectedFilter = 'All';
//   final List<String> _filters = ['All', 'Leave', 'Pending', 'Cancel'];
//
//   /// ✅ Fetch Leave Requests from Firestore
//   Stream<List<LeaveItem>> getLeaveStream() {
//     return FirebaseFirestore.instance.collection('users').snapshots().map((snapshot) {
//       List<LeaveItem> leaveList = [];
//
//       for (var doc in snapshot.docs) {
//         final userData = doc.data();
//
//         if (userData.containsKey('attendanceRecords') && userData['attendanceRecords'] is List) {
//           for (var record in userData['attendanceRecords']) {
//             if (record['type'] == 'leave') {
//               leaveList.add(LeaveItem(
//                 id: doc.id,
//                 name: userData['employeeName'] ?? 'Unknown',
//                 email: userData['email'] ?? 'N/A',
//                 date: record['date'] ?? '',
//                 note: record['note'] ?? '',
//                 status: 'Leave',
//               ));
//             }
//           }
//         }
//       }
//
//       return leaveList;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       appBar: AppBar(
//         backgroundColor: Colors.grey[100],
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios, size: 20, color: Colors.blue),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: const Text(
//           'Leave',
//           style: TextStyle(fontSize: 16, color: Colors.black, fontFamily: 'Poppins'),
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.calendar_today, color: Colors.blue),
//             onPressed: () {
//               Navigator.push(context, MaterialPageRoute(builder: (context) => const CalendarPage()));
//             },
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           /// ✅ Status Filters
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//             child: SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: Row(
//                 children: _filters.map((filter) {
//                   final isSelected = _selectedFilter == filter;
//                   return Padding(
//                     padding: const EdgeInsets.only(right: 8),
//                     child: ChoiceChip(
//                       label: Text(
//                         filter,
//                         style: TextStyle(color: isSelected ? Colors.white : Colors.black, fontFamily: 'Poppins'),
//                       ),
//                       selected: isSelected,
//                       selectedColor: Colors.blue,
//                       backgroundColor: Colors.white,
//                       onSelected: (selected) {
//                         if (selected) {
//                           setState(() {
//                             _selectedFilter = filter;
//                           });
//                         }
//                       },
//                     ),
//                   );
//                 }).toList(),
//               ),
//             ),
//           ),
//
//           /// ✅ Leave List from Firestore
//           Expanded(
//             child: StreamBuilder<List<LeaveItem>>(
//               stream: getLeaveStream(),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator());
//                 }
//
//                 if (snapshot.hasError) {
//                   return Center(child: Text("Error: ${snapshot.error}"));
//                 }
//
//                 List<LeaveItem> leaveItems = snapshot.data ?? [];
//
//                 /// ✅ Apply Filter
//                 if (_selectedFilter != 'All') {
//                   leaveItems = leaveItems.where((item) => item.status == _selectedFilter).toList();
//                 }
//
//                 return ListView.builder(
//                   itemCount: leaveItems.length,
//                   itemBuilder: (context, index) {
//                     final item = leaveItems[index];
//                     return ListTile(
//                       leading: CircleAvatar(
//                         backgroundColor: Colors.blue[100],
//                         child: const Icon(Icons.person, color: Colors.blue),
//                       ),
//                       title: Text(item.name, style: const TextStyle(fontFamily: 'Poppins')),
//                       subtitle: Text(
//                         "${item.date} - ${item.note}",
//                         style: const TextStyle(fontFamily: 'Poppins'),
//                       ),
//                       trailing: const Icon(Icons.arrow_forward_ios, size: 16),
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => LeaveDetailsPage(name: item.name, role: 'employee'),
//                           ),
//                         );
//                       },
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// /// ✅ LeaveItem Model
// class LeaveItem {
//   final String id;
//   final String name;
//   final String email;
//   final String date;
//   final String note;
//   final String status;
//
//   LeaveItem({
//     required this.id,
//     required this.name,
//     required this.email,
//     required this.date,
//     required this.note,
//     required this.status,
//   });
// }


import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'calendar_page.dart';
import 'leave_details_page.dart';

class LeavePage extends StatefulWidget {
  const LeavePage({super.key});

  @override
  State<LeavePage> createState() => _LeavePageState();
}

class _LeavePageState extends State<LeavePage> {
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Pending', 'Accepted', 'Rejected'];

  /// ✅ Fetch Leave Requests from Firestore
  Stream<List<LeaveItem>> getLeaveStream() {
    return FirebaseFirestore.instance.collection('users').snapshots().map((snapshot) {
      List<LeaveItem> leaveList = [];

      for (var doc in snapshot.docs) {
        final userData = doc.data();

        if (userData.containsKey('attendanceRecords') && userData['attendanceRecords'] is List) {
          for (var record in userData['attendanceRecords']) {
            if (record['type'] == 'leave') {
              leaveList.add(LeaveItem(
                userId: doc.id,
                name: userData['employeeName'] ?? 'Unknown',
                email: userData['email'] ?? 'N/A',
                date: record['date'] ?? '',
                note: record['note'] ?? '',
                status: record['status'] ?? 'Pending',
              ));
            }
          }
        }
      }

      return leaveList;
    });
  }

  /// ✅ Update Leave Status in Firestore
  Future<void> updateLeaveStatus(String userId, String date, String newStatus) async {
    final userDocRef = FirebaseFirestore.instance.collection('users').doc(userId);
    final userDoc = await userDocRef.get();

    if (userDoc.exists) {
      List<dynamic> attendanceRecords = userDoc['attendanceRecords'];

      for (var record in attendanceRecords) {
        if (record['date'] == date && record['type'] == 'leave') {
          record['status'] = newStatus;
        }
      }

      await userDocRef.update({'attendanceRecords': attendanceRecords});
      // await PushNotificationService.notifyEmployeeOnLeaveStatus(userId, newStatus);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Manage Leave Requests',
          style: TextStyle(fontSize: 16, color: Colors.black, fontFamily: 'Poppins'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today, color: Colors.blue),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const AdminCalendarPage()));
            },
          ),
        ],
      ),
      body: Column(
        children: [
          /// ✅ Status Filters
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _filters.map((filter) {
                  final isSelected = _selectedFilter == filter;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(
                        filter,
                        style: TextStyle(color: isSelected ? Colors.white : Colors.black, fontFamily: 'Poppins'),
                      ),
                      selected: isSelected,
                      selectedColor: Colors.blue,
                      backgroundColor: Colors.white,
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            _selectedFilter = filter;
                          });
                        }
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          /// ✅ Leave List from Firestore
          Expanded(
            child: StreamBuilder<List<LeaveItem>>(
              stream: getLeaveStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                }

                List<LeaveItem> leaveItems = snapshot.data ?? [];

                /// ✅ Apply Filter
                if (_selectedFilter != 'All') {
                  leaveItems = leaveItems.where((item) => item.status == _selectedFilter).toList();
                }

                return ListView.builder(
                  itemCount: leaveItems.length,
                  itemBuilder: (context, index) {
                    final item = leaveItems[index];
                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue[100],
                          child: const Icon(Icons.person, color: Colors.blue),
                        ),
                        title: Text(item.name, style: const TextStyle(fontFamily: 'Poppins')),
                        subtitle: Text(
                          "${item.date} - ${item.note}",
                          style: const TextStyle(fontFamily: 'Poppins'),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            /// ✅ Accept Button
                            if (item.status == 'Pending')
                              IconButton(
                                icon: const Icon(Icons.check_circle, color: Colors.green),
                                onPressed: () => updateLeaveStatus(item.userId, item.date, 'Accepted'),
                              ),

                            /// ✅ Reject Button
                            if (item.status == 'Pending')
                              IconButton(
                                icon: const Icon(Icons.cancel, color: Colors.red),
                                onPressed: () => updateLeaveStatus(item.userId, item.date, 'Rejected'),
                              ),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LeaveDetailsPage( userId: 'userId', name: 'name', role: 'role', leaveDate: 'date',),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// ✅ LeaveItem Model
class LeaveItem {
  final String userId;
  final String name;
  final String email;
  final String date;
  final String note;
  final String status;

  LeaveItem({
    required this.userId,
    required this.name,
    required this.email,
    required this.date,
    required this.note,
    required this.status,
  });
}
