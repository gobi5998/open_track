// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart'; // Add this package to pubspec.yaml
//
// class TimeSheetScreen extends StatefulWidget {
//   const TimeSheetScreen({super.key});
//
//   @override
//   State<TimeSheetScreen> createState() => _TimeSheetScreenState();
// }
//
// class _TimeSheetScreenState extends State<TimeSheetScreen> {
//   String selectedFilter = 'Week';
//   final workColor = Colors.blue;
//   final leaveColor = Colors.amber;
//   final overtimeColor = Colors.green;
//   final betweenSpace = 0.2;
//
//   BarChartGroupData generateGroupData(
//     int x,
//     double work,
//     double leave,
//     double overtime,
//   ) {
//     return BarChartGroupData(
//       x: x,
//       groupVertically: true,
//       barRods: [
//         BarChartRodData(
//           fromY: 0,
//           toY: work,
//           color: workColor,
//           width: 15,
//           borderRadius: BorderRadius.circular(2),
//         ),
//         BarChartRodData(
//           fromY: work + betweenSpace,
//           toY: work + betweenSpace + leave,
//           color: leaveColor,
//           width: 15,
//           borderRadius: BorderRadius.circular(2),
//         ),
//         BarChartRodData(
//           fromY: work + betweenSpace + leave + betweenSpace,
//           toY: work + betweenSpace + leave + betweenSpace + overtime,
//           color: overtimeColor,
//           width: 15,
//           borderRadius: BorderRadius.circular(2),
//         ),
//       ],
//     );
//   }
//
//   Widget bottomTitles(double value, TitleMeta meta) {
//     const style = TextStyle(
//       fontSize: 12,
//       fontFamily: 'Poppins',
//       color: Colors.grey,
//     );
//     const days = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
//     return SideTitleWidget(
//       meta: meta,
//       child: Text(days[value.toInt()], style: style),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: const Text(
//           'Time Sheet',
//           style: TextStyle(fontFamily: 'Poppins'),
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Filter buttons
//               Row(
//                 children: [
//                   FilterButton(
//                     text: 'Year',
//                     isSelected: selectedFilter == 'Year',
//                     onTap: () => setState(() => selectedFilter = 'Year'),
//                   ),
//                   const SizedBox(width: 8),
//                   FilterButton(
//                     text: 'Month',
//                     isSelected: selectedFilter == 'Month',
//                     onTap: () => setState(() => selectedFilter = 'Month'),
//                   ),
//                   const SizedBox(width: 8),
//                   FilterButton(
//                     text: 'Week',
//                     isSelected: selectedFilter == 'Week',
//                     onTap: () => setState(() => selectedFilter = 'Week'),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 24),
//
//               const Text(
//                 'Total Employee Working Hours',
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                   fontFamily: 'Poppins',
//                 ),
//               ),
//               const SizedBox(height: 16),
//
//               // Chart
//               SizedBox(
//                 height: 300,
//                 child: BarChart(
//                   BarChartData(
//                     alignment: BarChartAlignment.spaceBetween,
//                     maxY: 24 + (betweenSpace * 3),
//                     barTouchData: BarTouchData(enabled: true),
//                     titlesData: FlTitlesData(
//                       leftTitles: AxisTitles(
//                         sideTitles: SideTitles(
//                           showTitles: true,
//                           interval: 4,
//                           getTitlesWidget: (value, meta) {
//                             return Text(
//                               value.toInt().toString(),
//                               style: const TextStyle(
//                                 color: Colors.grey,
//                                 fontFamily: 'Poppins',
//                                 fontSize: 12,
//                               ),
//                             );
//                           },
//                         ),
//                       ),
//                       rightTitles: const AxisTitles(
//                         sideTitles: SideTitles(showTitles: false),
//                       ),
//                       topTitles: const AxisTitles(
//                         sideTitles: SideTitles(showTitles: false),
//                       ),
//                       bottomTitles: AxisTitles(
//                         sideTitles: SideTitles(
//                           showTitles: true,
//                           getTitlesWidget: bottomTitles,
//                           reservedSize: 30,
//                         ),
//                       ),
//                     ),
//                     borderData: FlBorderData(show: false),
//                     gridData: const FlGridData(show: false),
//                     barGroups: [
//                       generateGroupData(0, 0, 8, 0),  // Sunday
//                       generateGroupData(1, 8, 2, 1),  // Monday
//                       generateGroupData(2, 5, 0, 2),  // Tuesday
//                       generateGroupData(3, 8, 1, 1),  // Wednesday
//                       generateGroupData(4, 3, 0, 0),  // Thursday
//                       generateGroupData(5, 8, 0, 1),  // Friday
//                       generateGroupData(6, 0, 8, 0),  // Saturday
//                     ],
//                   ),
//                 ),
//               ),
//
//               // Legend
//               const SizedBox(height: 16),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   _buildLegendItem('Work', workColor, '8h'),
//                   const SizedBox(width: 24),
//                   _buildLegendItem('Leave', leaveColor, '2h'),
//                   const SizedBox(width: 24),
//                   _buildLegendItem('Overtime', overtimeColor, '2h'),
//                 ],
//               ),
//
//               const SizedBox(height: 24),
//               const Text(
//                 'Total Employee : 58',
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                   fontFamily: 'Poppins',
//                 ),
//               ),
//               const SizedBox(height: 16),
//
//               // Employee List
//               ListView.separated(
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 itemCount: 4,
//                 separatorBuilder: (context, index) => const Divider(),
//                 itemBuilder: (context, index) {
//                   return ListTile(
//                     leading: CircleAvatar(
//                       backgroundImage: AssetImage('assets/images/profile.png'),
//                     ),
//                     title: const Text(
//                       'Arun Kumar',
//                       style: TextStyle(fontFamily: 'Poppins'),
//                     ),
//                     trailing: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Text(
//                           index == 2 ? '4h' : '8h',
//                           style: const TextStyle(fontFamily: 'Poppins'),
//                         ),
//                         const Icon(Icons.chevron_right),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildLegendItem(String label, Color color, String hours) {
//     return Row(
//       children: [
//         Container(
//           width: 12,
//           height: 12,
//           decoration: BoxDecoration(
//             color: color,
//             borderRadius: BorderRadius.circular(2),
//           ),
//         ),
//         const SizedBox(width: 8),
//         Text(
//           '$label\n$hours',
//           style: const TextStyle(
//             fontSize: 12,
//             fontFamily: 'Poppins',
//           ),
//         ),
//       ],
//     );
//   }
// }
//
// class FilterButton extends StatelessWidget {
//   final String text;
//   final bool isSelected;
//   final VoidCallback onTap;
//
//   const FilterButton({
//     super.key,
//     required this.text,
//     required this.isSelected,
//     required this.onTap,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
//         decoration: BoxDecoration(
//           color: isSelected ? Colors.blue : Colors.grey[200],
//           borderRadius: BorderRadius.circular(20),
//         ),
//         child: Text(
//           text,
//           style: TextStyle(
//             color: isSelected ? Colors.white : Colors.black,
//             fontWeight: FontWeight.w500,
//             fontFamily: 'Poppins',
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class TimeSheetScreen extends StatefulWidget {
  const TimeSheetScreen({super.key, required String userId});

  @override
  State<TimeSheetScreen> createState() => _TimeSheetScreenState();
}

class _TimeSheetScreenState extends State<TimeSheetScreen> {
  final workColor = Colors.blue;
  final leaveColor = Colors.amber;
  final betweenSpace = 0.2;

  String? selectedEmployeeId;
  DateTime selectedWeekStart =
      DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1));

  Stream<List<Map<String, dynamic>>> getEmployeeDataStream() {
    return FirebaseFirestore.instance
        .collection('users')
        .where('role', isEqualTo: 'employee')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        Map<String, double> dailyWorkHours = {};
        Map<String, double> dailyLeaveHours = {};

        if (data.containsKey('attendanceRecords') &&
            data['attendanceRecords'] is List) {
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
                print("❌ Error parsing time for employee ${doc.id}: $e");
              }
            }
            String dateKey = record['date'];
            dailyWorkHours[dateKey] =
                (dailyWorkHours[dateKey] ?? 0) + workHours;
            dailyLeaveHours[dateKey] =
                (dailyLeaveHours[dateKey] ?? 0) + leaveHours;
          }
        }
        return {
          'id': doc.id,
          'name': data['name'] ?? '',
          'photoURL': data['photoURL'] ?? '',
          'dailyWorkHours': dailyWorkHours,
          'dailyLeaveHours': dailyLeaveHours,
        };
      }).toList();
    });
  }

  List<BarChartGroupData> generateChartData(
      List<Map<String, dynamic>> employees) {
    if (selectedEmployeeId == null) return [];

    Map<int, double> weeklyWorkHours = {};
    Map<int, double> weeklyLeaveHours = {};

    var selectedEmployee = employees.firstWhere(
      (e) => e['id'] == selectedEmployeeId,
      orElse: () => {},
    );

    if (selectedEmployee.isNotEmpty) {
      for (var entry in selectedEmployee['dailyWorkHours'].entries) {
        DateTime date = DateFormat('dd-MM-yyyy').parse(entry.key);
        if (date.isAfter(selectedWeekStart.subtract(const Duration(days: 1))) &&
            date.isBefore(selectedWeekStart.add(const Duration(days: 7)))) {
          int weekdayIndex = date.weekday - 1;
          weeklyWorkHours[weekdayIndex] =
              (weeklyWorkHours[weekdayIndex] ?? 0) + entry.value;
        }
      }
      for (var entry in selectedEmployee['dailyLeaveHours'].entries) {
        DateTime date = DateFormat('dd-MM-yyyy').parse(entry.key);
        if (date.isAfter(selectedWeekStart.subtract(const Duration(days: 1))) &&
            date.isBefore(selectedWeekStart.add(const Duration(days: 7)))) {
          int weekdayIndex = date.weekday - 1;
          weeklyLeaveHours[weekdayIndex] =
              (weeklyLeaveHours[weekdayIndex] ?? 0) + entry.value;
        }
      }
    }

    return List.generate(7, (i) {
      return BarChartGroupData(
        x: i,
        groupVertically: true,
        barRods: [
          if (weeklyLeaveHours[i] != null)
            BarChartRodData(
                fromY: 0,
                toY: weeklyLeaveHours[i]!,
                color: leaveColor,
                width: 15),
          if (weeklyWorkHours[i] != null)
            BarChartRodData(
                fromY: weeklyLeaveHours[i]! + betweenSpace,
                toY: weeklyLeaveHours[i]! + betweenSpace + weeklyWorkHours[i]!,
                color: workColor,
                width: 15),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Time Sheet'),
        backgroundColor: Colors.blue,),
        body: SingleChildScrollView(
          child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: getEmployeeDataStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                }
                List<Map<String, dynamic>> employees = snapshot.data ?? [];
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () {
                            setState(() {
                              selectedWeekStart = selectedWeekStart
                                  .subtract(const Duration(days: 7));
                            });
                          },
                        ),
                        Text(
                            "Week: ${DateFormat('dd MMM').format(selectedWeekStart)} - ${DateFormat('dd MMM').format(selectedWeekStart.add(const Duration(days: 6)))}"),
                        IconButton(
                          icon: const Icon(Icons.arrow_forward),
                          onPressed: () {
                            setState(() {
                              selectedWeekStart =
                                  selectedWeekStart.add(const Duration(days: 7));
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
                                getTitlesWidget: (value, meta) => Text(value.toInt().toString(), style: const TextStyle(fontSize: 12)),
                              ),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  const days = ['M', 'T', 'W', 'T', 'F', 'S','S'];
                                  return Text(days[value.toInt()], style: const TextStyle(fontSize: 12));
                                },
                                reservedSize: 30,
                              ),
                            ),
                          ),
                          barGroups: generateChartData(employees),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text("Total Employees: ${employees.length}",
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: employees.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final employee = employees[index];
                        Map<String, double> dailyWorkHours =
                            employee['dailyWorkHours'] ?? {};
                        bool isSelected = employee['id'] == selectedEmployeeId;
                        String today =
                            DateFormat('dd-MM-yyyy').format(DateTime.now());
                        double todayHours = dailyWorkHours[today] ??
                            0.0; // Get today's hours or default to 0

                        return Column(
                          children: [
                            ListTile(
                              leading: CircleAvatar(
                                backgroundImage: (employee['photoURL'] != null &&
                                        employee['photoURL'].isNotEmpty)
                                    ? NetworkImage(employee['photoURL'])
                                    : const AssetImage(
                                            'assets/images/main_profile.png')
                                        as ImageProvider,
                              ),
                              subtitle: Column(
                                children: [
                                  LinearProgressIndicator(
                                    value: todayHours / 8,
                                    backgroundColor: Colors.grey.shade300,
                                    color: workColor,
                                  ),
                                ],
                              ),
                              title: Text("${index + 1}. ${employee['name']}"),
                              trailing: isSelected
                                  ? const Icon(Icons.check_circle,
                                      color: Colors.green)
                                  : null,
                              onTap: () {
                                setState(() {
                                  selectedEmployeeId =
                                      (selectedEmployeeId == employee['id'])
                                          ? null
                                          : employee['id'];
                                });
                              },
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                );
              }),
        ));
  }
}
