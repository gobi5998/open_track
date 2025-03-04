import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AttendanceListEmployees extends StatefulWidget {
  const AttendanceListEmployees({Key? key}) : super(key: key);

  @override
  State<AttendanceListEmployees> createState() => _AttendanceListEmployeesState();
}

class _AttendanceListEmployeesState extends State<AttendanceListEmployees> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> _attendanceRecords = [];
  bool _isLoading = false;
  String _error = '';
  String _userId = '';

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final email = prefs.getString('email');
      if (email != null) {
        final userDoc = await _firestore
            .collection('users')
            .where('email', isEqualTo: email)
            .limit(1)
            .get();
        
        if (userDoc.docs.isNotEmpty) {
          _userId = userDoc.docs.first.id;
          _loadAttendanceRecords();
        }
      }
    } catch (e) {
      print('Error loading user ID: $e');
      setState(() => _error = 'Failed to load user data');
    }
  }

  Future<void> _loadAttendanceRecords() async {
    if (_userId.isEmpty) return;
    
    setState(() => _isLoading = true);
    try {
      final docSnapshot = await _firestore
          .collection('users')
          .doc(_userId)
          .get();

      if (!docSnapshot.exists) {
        setState(() {
          _error = 'User data not found';
          _isLoading = false;
        });
        return;
      }

      final data = docSnapshot.data() as Map<String, dynamic>;
      final attendance = data['attendance'] as Map<String, dynamic>? ?? {};
      
      final List<Map<String, dynamic>> records = [];
      attendance.forEach((date, record) {
        if (record is Map<String, dynamic>) {
          records.add({
            'date': date,
            'inTime': record['inTime'] ?? '',
            'outTime': record['outTime'] ?? '',
          });
        }
      });

      // Sort by date descending
      records.sort((a, b) => b['date'].compareTo(a['date']));

      setState(() {
        _attendanceRecords = records;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
      print('Error loading attendance: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error.isNotEmpty) {
      return Center(child: Text('Error: $_error'));
    }

    if (_attendanceRecords.isEmpty) {
      return const Center(child: Text('No attendance records found'));
    }

    return ListView.builder(
      itemCount: _attendanceRecords.length,
      itemBuilder: (context, index) {
        final record = _attendanceRecords[index];
        final date = record['date'];
        final formattedDate = DateFormat('MMM dd, yyyy').format(DateTime.parse(date));
        
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            title: Text(
              formattedDate,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            subtitle: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('In Time:'),
                      Text(
                        record['inTime'] ?? 'Not recorded',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Out Time:'),
                      Text(
                        record['outTime'] ?? 'Not recorded',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
