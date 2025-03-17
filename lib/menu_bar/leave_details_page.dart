import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LeaveDetailsPage extends StatefulWidget {
  final String name;
  final String role;
  final String userId;
  final String leaveDate;

  const LeaveDetailsPage({
    Key? key,
    required this.name,
    required this.role,
    required this.userId,
    required this.leaveDate,
  }) : super(key: key);

  @override
  State<LeaveDetailsPage> createState() => _LeaveDetailsPageState();
}

class _LeaveDetailsPageState extends State<LeaveDetailsPage> {
  String _leaveStatus = 'Pending'; // Default status

  @override
  void initState() {
    super.initState();
    _listenForStatusUpdates(); // Start listening for Firestore updates
  }

  /// ✅ Listen for Real-Time Firestore Updates
  void _listenForStatusUpdates() {
    FirebaseFirestore.instance.collection('users').doc(widget.userId).snapshots().listen((doc) {
      if (doc.exists) {
        List<dynamic> attendanceRecords = doc['attendanceRecords'];
        for (var record in attendanceRecords) {
          if (record['date'] == widget.leaveDate && record['type'] == 'leave') {
            setState(() {
              _leaveStatus = record['status']; // Update status dynamically
            });
          }
        }
      }
    });
  }

  /// ✅ Update Leave Status in Firestore
  Future<void> updateLeaveStatus(String newStatus) async {
    try {
      final userDocRef = FirebaseFirestore.instance.collection('users').doc(widget.userId);
      final userDoc = await userDocRef.get();

      if (userDoc.exists) {
        List<dynamic> attendanceRecords = userDoc['attendanceRecords'];

        for (var record in attendanceRecords) {
          if (record['date'] == widget.leaveDate && record['type'] == 'leave') {
            record['status'] = newStatus;
          }
        }

        await userDocRef.update({'attendanceRecords': attendanceRecords});

        setState(() {
          _leaveStatus = newStatus; // Update local UI instantly
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Leave status updated to $newStatus")),
        );
      }
    } catch (e) {
      print("Error updating leave status: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error updating status: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Leave Details', style: TextStyle(fontFamily: 'Poppins')),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.blue[100],
                    child: const Icon(Icons.person, color: Colors.blue, size: 30),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.name,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500, fontFamily: 'Poppins'),
                      ),
                      Text(widget.role, style: TextStyle(color: Colors.grey[600], fontFamily: 'Poppins')),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Leave Details', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Poppins')),
                  const SizedBox(height: 12),
                  Text('Status: $_leaveStatus', style: TextStyle(fontFamily: 'Poppins', color: _getStatusColor())),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => updateLeaveStatus('Pending'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  ),
                  child: const Text('Pending', style: TextStyle(fontFamily: 'Poppins')),
                ),
                ElevatedButton(
                  onPressed: () => updateLeaveStatus('Accepted'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  ),
                  child: const Text('Accept', style: TextStyle(fontFamily: 'Poppins')),
                ),
                ElevatedButton(
                  onPressed: () => updateLeaveStatus('Rejected'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  ),
                  child: const Text('Reject', style: TextStyle(fontFamily: 'Poppins')),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// ✅ Get status color dynamically
  Color _getStatusColor() {
    if (_leaveStatus == 'Accepted') return Colors.green;
    if (_leaveStatus == 'Rejected') return Colors.red;
    return Colors.orange;
  }
}
