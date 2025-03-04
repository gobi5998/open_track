import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import '../auth_service.dart';

class AttendanceForm extends StatefulWidget {
  const AttendanceForm({super.key});

  @override
  State<AttendanceForm> createState() => _AttendanceFormState();
}

class _AttendanceFormState extends State<AttendanceForm> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final _authService = AuthService();
  
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _inTime = TimeOfDay.now();
  TimeOfDay _outTime = TimeOfDay.now();
  String _selectedType = 'IN'; // 'IN', 'OUT', or 'LEAVE'
  final _noteController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2024),
      lastDate: DateTime(2026),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // Future<void> _selectInTime(BuildContext context) async {
  //   final TimeOfDay? picked = await showTimePicker(
  //     context: context,
  //     initialTime: _inTime,
  //   );
  //   if (picked != null) {
  //     setState(() {
  //       _inTime = picked;
  //     });
  //   }
  // }

  Future<void> _selectOutTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _outTime,
    );
    if (picked != null) {
      setState(() {
        _outTime = picked;
      });
    }
  }

  Future<void> _submitAttendance() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      final dateKey = DateFormat('yyyy-MM-dd').format(_selectedDate);
      
      final docRef = _firestore
          .collection('users')
          .doc(user.uid)
          .collection('attendance')
          .doc(dateKey);
          
      Map<String, dynamic> updateData = {
        'employeeName': user.displayName ?? user.email ?? 'Unknown',
        'userId': user.uid,
        'date': Timestamp.fromDate(_selectedDate),
        'lastUpdated': FieldValue.serverTimestamp(),
      };
      
      if (_selectedType == 'IN') {
        updateData.addAll({
          'inTime': Timestamp.fromDate(DateTime(
            _selectedDate.year,
            _selectedDate.month,
            _selectedDate.day,
            _inTime.hour,
            _inTime.minute,
          )),
          'type': 'attendance',
          'note': _noteController.text.trim(),
        });
      } else if (_selectedType == 'OUT') {
        updateData.addAll({
          'outTime': Timestamp.fromDate(DateTime(
            _selectedDate.year,
            _selectedDate.month,
            _selectedDate.day,
            _outTime.hour,
            _outTime.minute,
          )),
          'type': 'attendance',
          'note': _noteController.text.trim(),
        });
      } else if (_selectedType == 'LEAVE') {
        updateData.addAll({
          'type': 'leave',
          'note': _noteController.text.trim(),
        });
      }

      print('Saving attendance record: $updateData'); // Debug log
      await docRef.set(updateData, SetOptions(merge: true));

      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      print('Error saving attendance: $e'); // Debug log
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Record Attendance'),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _submitAttendance,
            child: Text(
              'Done',
              style: TextStyle(
                color: _isLoading ? Colors.grey : Colors.blue,
                fontSize: 16,
              ),    
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Type Selector
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'IN', label: Text('IN')),
                  ButtonSegment(value: 'OUT', label: Text('OUT')),
                  ButtonSegment(value: 'LEAVE', label: Text('LEAVE')),
                ],
                selected: {_selectedType},
                onSelectionChanged: (Set<String> newSelection) {
                  setState(() {
                    _selectedType = newSelection.first;
                  });
                },
              ),
              const SizedBox(height: 24),

              // Date Picker - only show for LEAVE type
              if (_selectedType == 'LEAVE')
                ListTile(
                  title: const Text('Date'),
                  subtitle: Text(
                    DateFormat('MMM dd, yyyy').format(_selectedDate),
                    style: const TextStyle(fontSize: 16),
                  ),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () => _selectDate(context),
                ),
              const Divider(),

              // Time display for IN type
              if (_selectedType == 'IN')
                ListTile(
                  title: const Text('In Time'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        DateFormat('MMM dd, yyyy').format(_selectedDate),
                        style: const TextStyle(fontSize: 14),
                      ),
                      Text(
                        _inTime.format(context),
                        style: const TextStyle(fontSize: 16),
                      ),
                       // trailing: const Icon(Icons.access_time),
                  // onTap: () => _selectInTime(context),
                    ],
                  ),
                ),

              // Time display for OUT type  
              if (_selectedType == 'OUT')
                ListTile(
                  title: const Text('Out Time'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        DateFormat('MMM dd, yyyy').format(_selectedDate),
                        style: const TextStyle(fontSize: 14),
                      ),
                      Text(
                        _outTime.format(context),
                        style: const TextStyle(fontSize: 16),
                      ),
                       // trailing: const Icon(Icons.access_time),
                  // onTap: () => _selectOutTime(context),
                    ],
                  ),
                ),

              // Note Field for Leave
              if (_selectedType == 'LEAVE')
                TextField(
                  controller: _noteController,
                  decoration: const InputDecoration(
                    labelText: 'Leave Reason',
                    hintText: 'Enter reason for leave',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
              if (_selectedType != 'LEAVE')
                TextField(   
                  controller: _noteController,
                  decoration: const InputDecoration(
                    labelText: 'Note',
                    hintText: 'Add a note (optional)',
                  ),
                  maxLines: 3,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
