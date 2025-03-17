import 'package:cloud_firestore/cloud_firestore.dart';

class UserRecord {
  final String id;
  final String name;
  final String email;
  final String password; // Hashed password
  final String role;
  final DateTime createdAt;
  final DateTime lastLogin;
  final Map<String, dynamic> employeeData;
  final Map<String, AttendanceRecord> attendance;

  UserRecord({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.role,
    required this.createdAt,
    required this.lastLogin,
    required this.employeeData,
    required this.attendance,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'role': role,
      'createdAt': Timestamp.fromDate(createdAt),
      'lastLogin': Timestamp.fromDate(lastLogin),
      'employeeData': employeeData,
      'attendance': attendance.map((date, record) => MapEntry(date, record.toMap())),
    };
  }

  factory UserRecord.fromMap(String id, Map<String, dynamic> map) {
    final attendanceMap = (map['attendance'] as Map<String, dynamic>?) ?? {};
    final attendance = attendanceMap.map((key, value) => 
      MapEntry(key, AttendanceRecord.fromMap(value as Map<String, dynamic>)));

    return UserRecord(
      id: id,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      role: map['role'] ?? '',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      lastLogin: (map['lastLogin'] as Timestamp).toDate(),
      employeeData: (map['employeeData'] as Map<String, dynamic>?) ?? {},
      attendance: attendance,
    );
  }
}

class AttendanceRecord {
  final DateTime? inTime;
  final DateTime? outTime;
  final String type; // 'in', 'out', or 'leave'
  final String note;

  AttendanceRecord({
    this.inTime,
    this.outTime,
    required this.type,
    required this.note,
  });

  Map<String, dynamic> toMap() {
    return {
      if (inTime != null) 'inTime': Timestamp.fromDate(inTime!),
      if (outTime != null) 'outTime': Timestamp.fromDate(outTime!),
      'type': type,
      'note': note,
    };
  }

  factory AttendanceRecord.fromMap(Map<String, dynamic> map) {
    return AttendanceRecord(
      inTime: map['inTime'] != null ? (map['inTime'] as Timestamp).toDate() : null,
      outTime: map['outTime'] != null ? (map['outTime'] as Timestamp).toDate() : null,
      type: map['type'] as String,
      note: map['note'] as String,
    );
  }
}
