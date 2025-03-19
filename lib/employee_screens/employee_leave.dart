import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class LeaveTrackerScreen extends StatefulWidget {
  @override
  _LeaveTrackerScreenState createState() => _LeaveTrackerScreenState();
}

class _LeaveTrackerScreenState extends State<LeaveTrackerScreen> {
  final String employeeId = "userId"; // Example Employee ID
  int selectedYear = DateTime.now().year;
  int selectedMonth = DateTime.now().month;
  int monthlyLeaveCount = 0;
  int yearlyLeaveCount = 0;

  @override
  void initState() {
    super.initState();
    _fetchLeaveCounts();
  }

  /// Fetch Monthly and Yearly Leave Count
  void _fetchLeaveCounts() async {
    int monthLeaves = await getMonthlyLeaveCount(employeeId, selectedYear, selectedMonth);
    int yearLeaves = await getYearlyLeaveCount(employeeId, selectedYear);

    setState(() {
      monthlyLeaveCount = monthLeaves;
      yearlyLeaveCount = yearLeaves;
    });
  }

  /// Get Leave Count for a Specific Month
  Future<int> getMonthlyLeaveCount(String employeeId, int year, int month) async {
    final firestore = FirebaseFirestore.instance;
    DateTime startDate = DateTime(year, month, 1);
    DateTime endDate = DateTime(year, month + 1, 0);

    QuerySnapshot leaveSnapshot = await firestore
         .collection('users')
        .where('employeeId', isEqualTo: employeeId)
        .where('status', isEqualTo: 'Accepted')
        .get();

    int totalDays = 0;

    for (var doc in leaveSnapshot.docs) {
      DateTime leaveStart = DateTime.parse(doc['startDate']);
      DateTime leaveEnd = DateTime.parse(doc['endDate']);

      // Adjust range to fit within the selected month
      DateTime rangeStart = leaveStart.isBefore(startDate) ? startDate : leaveStart;
      DateTime rangeEnd = leaveEnd.isAfter(endDate) ? endDate : leaveEnd;

      totalDays += rangeEnd.difference(rangeStart).inDays + 1;
    }

    return totalDays;
  }

  /// Get Total Leaves Taken in a Year
  Future<int> getYearlyLeaveCount(String employeeId, int year) async {
    int totalLeaves = 0;
    for (int month = 1; month <= 12; month++) {
      int monthLeaves = await getMonthlyLeaveCount(employeeId, year, month);
      totalLeaves += monthLeaves;
    }
    return totalLeaves;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Employee Leave Tracker'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Leave Details for Employee: $employeeId",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),

            // Month Selection Dropdown
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DropdownButton<int>(
                  value: selectedMonth,
                  onChanged: (newMonth) {
                    setState(() {
                      selectedMonth = newMonth!;
                    });
                    _fetchLeaveCounts();
                  },
                  items: List.generate(12, (index) {
                    return DropdownMenuItem<int>(
                      value: index + 1,
                      child: Text("Month ${index + 1}"),
                    );
                  }),
                ),

                // Year Selection Dropdown
                DropdownButton<int>(
                  value: selectedYear,
                  onChanged: (newYear) {
                    setState(() {
                      selectedYear = newYear!;
                    });
                    _fetchLeaveCounts();
                  },
                  items: List.generate(5, (index) {
                    int year = DateTime.now().year - index;
                    return DropdownMenuItem<int>(
                      value: year,
                      child: Text("$year"),
                    );
                  }),
                ),
              ],
            ),

            SizedBox(height: 20),

            // Display Monthly Leave Count
            Text(
              "Total Leaves Taken in Selected Month: $monthlyLeaveCount days",
              style: TextStyle(fontSize: 16),
            ),

            SizedBox(height: 10),

            // Display Yearly Leave Count
            Text(
              "Total Leaves Taken in Selected Year: $yearlyLeaveCount days",
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}