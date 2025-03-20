import 'package:fl_chart/fl_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EmployeeTimeSheet extends StatefulWidget {
  @override
  _EmployeeTimeSheetState createState() => _EmployeeTimeSheetState();
}

class _EmployeeTimeSheetState extends State<EmployeeTimeSheet> {
  final workColor = Colors.blue;
  final leaveColor = Colors.amber;
  final betweenSpace = 0.2;

  DateTime selectedWeekStart =
  DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1));

  Stream<Map<String, dynamic>> getCurrentEmployeeDataStream() {
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

      if (data.containsKey('attendanceRecords') && data['attendanceRecords'] is List) {
        for (var record in data['attendanceRecords']) {
          double workHours = 0;
          double leaveHours = (record['type'] == 'leave') ? 8.0 : 0.0;

          if (record['inTime'] != null && record['outTime'] != null) {
            try {
              DateTime inTime = (record['inTime'] as Timestamp).toDate();
              DateTime outTime = (record['outTime'] as Timestamp).toDate();
              if (outTime.isAfter(inTime)) {
                workHours = outTime.difference(inTime).inHours.toDouble();
              }
            } catch (e) {
              print("❌ Error parsing time: $e");
            }
          }

          String dateKey = record['date'];
          dailyWorkHours[dateKey] = (dailyWorkHours[dateKey] ?? 0) + workHours;
          dailyLeaveHours[dateKey] = (dailyLeaveHours[dateKey] ?? 0) + leaveHours;
        }
      }

      return {
        'name': data['name'] ?? '',
        'photoURL': data['photoURL'] ?? '',
        'dailyWorkHours': dailyWorkHours,
        'dailyLeaveHours': dailyLeaveHours,
      };
    });
  }

  List<BarChartGroupData> generateChartData(Map<String, dynamic> employeeData) {
    if (employeeData.isEmpty) return [];

    Map<int, double> weeklyWorkHours = {};
    Map<int, double> weeklyLeaveHours = {};

    for (var entry in (employeeData['dailyWorkHours'] as Map<String, double>).entries) {
      DateTime date = DateFormat('dd-MM-yyyy').parse(entry.key);
      if (date.isAfter(selectedWeekStart.subtract(const Duration(days: 1))) &&
          date.isBefore(selectedWeekStart.add(const Duration(days: 7)))) {
        int weekdayIndex = date.weekday - 1;
        weeklyWorkHours[weekdayIndex] = (weeklyWorkHours[weekdayIndex] ?? 0) + entry.value;
      }
    }

    for (var entry in (employeeData['dailyLeaveHours'] as Map<String, double>).entries) {
      DateTime date = DateFormat('dd-MM-yyyy').parse(entry.key);
      if (date.isAfter(selectedWeekStart.subtract(const Duration(days: 1))) &&
          date.isBefore(selectedWeekStart.add(const Duration(days: 7)))) {
        int weekdayIndex = date.weekday - 1;
        weeklyLeaveHours[weekdayIndex] = (weeklyLeaveHours[weekdayIndex] ?? 0) + entry.value;
      }
    }

    return List.generate(7, (i) {
      return BarChartGroupData(
        x: i,
        groupVertically: true,
        barRods: [
          if (weeklyLeaveHours[i] != null)
            BarChartRodData(fromY: 0, toY: weeklyLeaveHours[i]!, color: leaveColor, width: 15),
          if (weeklyWorkHours[i] != null)
            BarChartRodData(
                fromY: (weeklyLeaveHours[i] ?? 0) + betweenSpace,
                toY: (weeklyLeaveHours[i] ?? 0) + betweenSpace + weeklyWorkHours[i]!,
                color: workColor,
                width: 15),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Time Sheet'), backgroundColor: Colors.blue),
        body:StreamBuilder<Map<String, dynamic>>(
            stream: getCurrentEmployeeDataStream(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              }
              Map<String, dynamic> employeeData = snapshot.data ?? {};
              if (employeeData.isEmpty) {
                return const Center(child: Text("No data available"));
              }

              double todayHours = employeeData['dailyWorkHours'] != null
                  ? employeeData['dailyWorkHours'][DateFormat('dd-MM-yyyy').format(DateTime.now())] ?? 0
                  : 0;

              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          setState(() {
                            selectedWeekStart = selectedWeekStart.subtract(const Duration(days: 7));
                          });
                        },
                      ),
                      Text(
                          "Week: ${DateFormat('dd MMM').format(selectedWeekStart)} - ${DateFormat('dd MMM').format(selectedWeekStart.add(const Duration(days: 6)))}"),
                      IconButton(
                        icon: const Icon(Icons.arrow_forward),
                        onPressed: () {
                          setState(() {
                            selectedWeekStart = selectedWeekStart.add(const Duration(days: 7));
                          });
                        },
                      ),
                    ],
                  ),
                  AspectRatio(
                    aspectRatio: 1.5,
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceBetween,
                        maxY: 24,
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              interval: 4,
                              getTitlesWidget: (value, meta) =>
                                  Text(value.toInt().toString(), style: const TextStyle(fontSize: 12)),
                            ),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                                return Text(days[value.toInt()], style: const TextStyle(fontSize: 12));
                              },

                              reservedSize: 30,
                            ),
                          ),
                        ),
                        barGroups: generateChartData(employeeData),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      const SizedBox(width: 10),
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: (employeeData['photoURL'] != null &&
                            employeeData['photoURL'].isNotEmpty)
                            ? NetworkImage(employeeData['photoURL'])
                            : const AssetImage('assets/images/main_profile.png') as ImageProvider,
                      ),
                      const SizedBox(width: 8,),
                      Text("Employee:",
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
                      SizedBox(width: 5),
                      Text("${employeeData['name']}",
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.normal)),
                    ],

                  ),

                  // SizedBox(height: 10),
                  // Column(
                  //  children: [
                  //    LinearProgressIndicator(
                  //      value: todayHours / 8,
                  //      backgroundColor: Colors.grey.shade300,
                  //      color: workColor,
                  //    ),
                  //  ],
                  // )
                ],
              );
            }
            )
    );
  }
}
