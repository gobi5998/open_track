import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:firebase_core/firebase_core.dart';
import '../models/attendance_record.dart';
import 'attendance_form.dart';

class AttendanceListEmployee extends StatefulWidget {
  const AttendanceListEmployee({super.key});

  @override
  State<AttendanceListEmployee> createState() => _AttendanceListEmployeeState();
}

class _AttendanceListEmployeeState extends State<AttendanceListEmployee> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  List<Map<String, dynamic>> _attendanceRecords = [];
  bool _isLoading = false;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _loadAttendanceRecords();
  }

  Future<void> _loadAttendanceRecords() async {
    if (!mounted) return;
    
    setState(() {
      _isLoading = true;
      _error = '';
    });

    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      print('Loading records for user: ${user.uid}');
      
      // First ensure the user document exists
      final userRef = _firestore.collection('users').doc(user.uid);
      
      // Create/update user document
      await userRef.set({
        'lastAccess': FieldValue.serverTimestamp(),
        'email': user.email,
        'isAnonymous': user.isAnonymous,
        'providers': user.providerData.map((e) => e.providerId).toList(),
      }, SetOptions(merge: true));
      
      final attendanceRef = _firestore
          .collection('users')
          .doc(user.uid)
          .collection('attendance');
          
      final snapshot = await attendanceRef
          .orderBy('date', descending: true)
          .get();

      if (!mounted) return;

      final List<Map<String, dynamic>> records = [];
      for (var doc in snapshot.docs) {
        final data = doc.data();
        records.add({
          'employeeName': data['employeeName'] ?? 'Unknown',
          'date': data['date'],
          'type': data['type'] ?? 'attendance',
          'inTime': data['inTime'],
          'outTime': data['outTime'],
          'note': data['note'],
        });
      }

      if (!mounted) return;
      setState(() {
        _attendanceRecords = records;
        _isLoading = false;
      });
    } catch (e, stack) {
      print('Error in _loadAttendanceRecords: $e');
      print('Stack trace: $stack');
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_error.isNotEmpty) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 48),
              const SizedBox(height: 16),
              Text('Error: $_error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadAttendanceRecords,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black),
          onPressed: () {

          },
        ),
        title: const Text('Daily Attendance'),
        actions: [

          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadAttendanceRecords,
          ),
        ],
      ),
      body: _attendanceRecords.isEmpty
          ? const Center(child: Text('No attendance records found'))
          : ListView.builder(
              itemCount: _attendanceRecords.length,
              itemBuilder: (context, index) {
                final record = _attendanceRecords[index];
                final date = (record['date'] as Timestamp).toDate();
                
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              record['employeeName'],
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              DateFormat('MMM dd, yyyy').format(date),
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        if (record['type'] == 'leave')
                          Text(
                            'Leave Status: ${record['note'] ?? 'Pending'}',
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.blue,
                            ),
                          )
                        else
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'In Time',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      record['inTime'] != null
                                          ? DateFormat('hh:mm a').format((record['inTime'] as Timestamp).toDate())
                                          : '--:--',
                                      style: const TextStyle(fontSize: 15),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Out Time',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      record['outTime'] != null
                                          ? DateFormat('hh:mm a').format((record['outTime'] as Timestamp).toDate())
                                          : '--:--',
                                      style: const TextStyle(fontSize: 15),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AttendanceForm()),
          );
          if (result == true && mounted) {
            await _loadAttendanceRecords();
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Attendance recorded successfully')),
              );
            }
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
