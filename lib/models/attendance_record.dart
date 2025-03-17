import 'package:cloud_firestore/cloud_firestore.dart';

class AttendanceRecord {
  final String id;
  final String userId;
  final DateTime date;
  final DateTime? inTime;
  final DateTime? outTime;
  final String? note;
  final String type; // 'in', 'out', or 'leave'

  AttendanceRecord({
    required this.id,
    required this.userId,
    required this.date,
    this.inTime,
    this.outTime,
    this.note,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'date': Timestamp.fromDate(date),
      'inTime': inTime != null ? Timestamp.fromDate(inTime!) : null,
      'outTime': outTime != null ? Timestamp.fromDate(outTime!) : null,
      'note': note,
      'type': type,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  static AttendanceRecord fromMap(String id, Map<String, dynamic> map) {
    return AttendanceRecord(
      id: id,
      userId: map['userId'] as String,
      date: (map['date'] as Timestamp).toDate(),
      inTime: map['inTime'] != null ? (map['inTime'] as Timestamp).toDate() : null,
      outTime: map['outTime'] != null ? (map['outTime'] as Timestamp).toDate() : null,
      note: map['note'] as String?,
      type: map['type'] as String,
    );
  }
}
