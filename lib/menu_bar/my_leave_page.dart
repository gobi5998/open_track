import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class LeaveListScreen extends StatefulWidget {
  @override
  _LeaveListScreenState createState() => _LeaveListScreenState();
}

class _LeaveListScreenState extends State<LeaveListScreen> {
  String? selectedUserId;

  /// ✅ Fetch all employees' data
  Stream<List<Map<String, dynamic>>> getAllEmployeesStream() {
    return FirebaseFirestore.instance.collection('users').where('role', isEqualTo: 'employee').snapshots().map(
          (snapshot) {
        return snapshot.docs.map((doc) {
          final data = doc.data();
          return {
            'id': doc.id,
            'name': data['name'] ?? 'Unknown',
            'photoURL': data['photoURL'] ?? '',
          };
        }).toList();
      },
    );
  }

  /// ✅ Fetch selected employee's work hours & leave days dynamically
  Stream<Map<String, dynamic>> getEmployeeDataStream(String userId) {
    return FirebaseFirestore.instance.collection('users').doc(userId).snapshots().map((doc) {
      if (!doc.exists) return {};

      final data = doc.data()!;
      Map<String, double> dailyWorkHours = {};
      Map<String, double> dailyLeaveHours = {};
      Map<int, int> leaveDaysPerMonth = {for (int i = 1; i <= 12; i++) i: 0};

      if (data.containsKey('attendanceRecords') && data['attendanceRecords'] is List) {
        for (var record in data['attendanceRecords']) {
          double workHours = 0;
          double leaveHours = (record['type'] == 'leave') ? 8.0 : 0.0;

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

          DateTime? inTime = (record['inTime'] != null) ? (record['inTime'] as Timestamp).toDate() : null;
          DateTime? outTime = (record['outTime'] != null) ? (record['outTime'] as Timestamp).toDate() : null;

          if (inTime != null && outTime != null && outTime.isAfter(inTime)) {
            workHours = outTime.difference(inTime).inHours.toDouble();
          }

          String dateKey = dateStr ?? "Unknown";
          dailyWorkHours[dateKey] = (dailyWorkHours[dateKey] ?? 0) + workHours;
          dailyLeaveHours[dateKey] = (dailyLeaveHours[dateKey] ?? 0) + leaveHours;
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
        appBar: AppBar(title: const Text('Employee Leave & Work Hours'), backgroundColor: Colors.blue),
        body: Column(
          children: [
            // ✅ Employee Selection Dropdown
            StreamBuilder<List<Map<String, dynamic>>>(
              stream: getAllEmployeesStream(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final employees = snapshot.data!;
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButton<String>(
                    value: selectedUserId,
                    hint: const Text("Select an Employee"),
                    isExpanded: true,
                    onChanged: (newValue) {
                      setState(() {
                        selectedUserId = newValue;
                      });
                    },
                    items: employees.map<DropdownMenuItem<String>>((employee) {
                      return DropdownMenuItem<String>(
                        value: employee['id'] as String, // Ensure the value is of type String
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundImage: employee['photoURL'].isNotEmpty
                                  ? NetworkImage(employee['photoURL'])
                                  : null,
                              child: employee['photoURL'].isEmpty ? const Icon(Icons.person) : null,
                            ),
                            const SizedBox(width: 10),
                            Text(employee['name']),
                          ],
                        ),
                      );
                    }).toList(),

                  ),
                );
              },
            ),

            // ✅ Show selected employee's leave & work details
            if (selectedUserId != null)
              Expanded(
                child: StreamBuilder<Map<String, dynamic>>(
                  stream: getEmployeeDataStream(selectedUserId!),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text("Error: ${snapshot.error}"));
                    }

                    Map<String, dynamic> employeeData = snapshot.data ?? {};
                    Map<int, int> leaveData = employeeData['leaveDaysPerMonth'] ?? {};
                    Map<String, double> dailyWorkHours = employeeData['dailyWorkHours'] ?? {};
                    Map<String, double> dailyLeaveHours = employeeData['dailyLeaveHours'] ?? {};
                    String employeeName = employeeData['name'] ?? "Unknown";

                    List<String> months = [
                      'January', 'February', 'March', 'April', 'May', 'June',
                      'July', 'August', 'September', 'October', 'November', 'December'
                    ];

                    return Column(
                      children: [
                        // ✅ Employee Name
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Employee: $employeeName",
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        ),

                        // ✅ Leave Summary List
                        Expanded(
                          child: ListView.builder(
                            itemCount: 12,
                            itemBuilder: (context, index) {
                              int month = index + 1;
                              int leaveDays = leaveData[month] ?? 0;

                              return ListTile(
                                leading: const Icon(Icons.calendar_today, color: Colors.blue),
                                title: Text(months[index],
                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                subtitle: Text("Leave Days: $leaveDays",
                                    style: TextStyle(color: leaveDays > 0 ? Colors.red : Colors.black)),
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
                  },
                ),
              ),
          ],
        ));
  }
}
