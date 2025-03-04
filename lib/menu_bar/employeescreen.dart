import 'package:flutter/material.dart';
import 'personal_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'edit_employee_details.dart';

class EmployeeScreen extends StatefulWidget {
  const EmployeeScreen({super.key});

  @override
  State<EmployeeScreen> createState() => _EmployeeScreenState();
}

class _EmployeeScreenState extends State<EmployeeScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = true;
  List<Map<String, dynamic>> _employees = [];

  @override
  void initState() {
    super.initState();
    _checkAuthAndLoadEmployees();
  }

  // Add this method to refresh the list after adding a new employee
  void refreshEmployeeList() {
    _loadEmployees();
  }

  Future<void> _checkAuthAndLoadEmployees() async {
    try {
      User? user = _auth.currentUser;
      if (user == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please login to view employees'),
              backgroundColor: Colors.red,
            ),
          );
          Navigator.of(context).pushReplacementNamed('/login');
        }
        return;
      }
      await _loadEmployees();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _loadEmployees() async {
    if (!mounted) return;
    
    setState(() => _isLoading = true);
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('users')
          .where('role', isEqualTo: 'employee')
          .get(); // Temporarily remove orderBy until all documents have createdAt

      if (!mounted) return;

      setState(() {
        _employees = snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          final employeeData = data['employeeData'] as Map<String, dynamic>? ?? {};
          return {
            'id': doc.id,
            'name': data['name'] ?? '',
            'email': data['email'] ?? '',
            'phone': employeeData['phone'] ?? '',
            'role': data['role'] ?? '',
            'department': employeeData['department'] ?? '',
            'status': employeeData['status'] ?? 'active',
            'photoURL': employeeData['photoURL'] ?? '',
          };
        }).toList();
        
        // Sort the list in memory instead
        _employees.sort((a, b) => b['name'].compareTo(a['name']));
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _employees = [];
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading employees: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Employee',
          style: TextStyle(fontFamily: 'Poppins', color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            color: Colors.white,
            onPressed: () => _showFilterBottomSheet(context),
          ),
          IconButton(
            icon: const Icon(Icons.person_add),
            color: Colors.white,
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PersonalDetailsScreen(),
                ),
              );
              // Refresh the list when returning from PersonalDetailsScreen
              refreshEmployeeList();
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadEmployees,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.people_outline),
                  const SizedBox(width: 8),
                  Text(
                    'Total Employee : ${_employees.length}',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _employees.isEmpty
                      ? const Center(
                          child: Text(
                            'No employees found',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: _employees.length,
                          itemBuilder: (context, index) {
                            final employee = _employees[index];
                            return EmployeeListTile(
                              index: index + 1,
                              name: employee['name'],
                              role: employee['role'],
                              department: employee['department'],
                              photoURL: employee['photoURL'],
                              employeeData: employee,
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const FilterBottomSheet(),
    );
  }
}

class EmployeeListTile extends StatelessWidget {
  final int index;
  final String name;
  final String role;
  final String department;
  final String? photoURL;
  final Map<String, dynamic> employeeData;

  const EmployeeListTile({
    super.key,
    required this.index,
    required this.name,
    required this.role,
    required this.department,
    this.photoURL,
    required this.employeeData,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final updated = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EditEmployeeDetails(
              employeeData: employeeData,
            ),
          ),
        );
        
        if (updated == true) {
          if (context.mounted) {
            final state = context.findAncestorStateOfType<_EmployeeScreenState>();
            state?.refreshEmployeeList();
          }
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey[200]!),
          ),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 30,
              child: Text(
                '${index.toString().padLeft(2, '0')}.',
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            ),
            CircleAvatar(
              radius: 25,
              backgroundImage: photoURL != null
                  ? NetworkImage(photoURL!) as ImageProvider
                  : const AssetImage('assets/images/main_profile.png'),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$role${department.isNotEmpty ? ' • $department' : ''}',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  final Map<String, bool> skills = {
    'Java': true,
    'Php': true,
    'Ph': true,
    'Python': true,
    'Dot.net': true,
    'React.js': true,
    'Node.js': true,
    'Mern stack': true,
    'Flutter':true,
    'ML/AL': true,
    'Testing': true,
    'UI/UX': true,
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Department',
                style: TextStyle(
                  fontFamily:'Poppins',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    skills.updateAll((key, value) => false);
                  });
                },
                child: const Text(
                  'Clear all',
                  style: TextStyle(
                    fontFamily:'Poppins',
                    color: Colors.blue,
                  ),
                ),
              ),
            ],
          ),
          const Divider(),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: skills.length,
              itemBuilder: (context, index) {
                String key = skills.keys.elementAt(index);
                return CheckboxListTile(
                  title: Text(key),
                  value: skills[key],
                  onChanged: (bool? value) {
                    setState(() {
                      skills[key] = value!;
                    });
                  },
                  controlAffinity: ListTileControlAffinity.trailing,
                );
              },
            ),
          ),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[200],
                    foregroundColor: Colors.black,
                  ),
                  child: const Text('Cancel',
                  style:TextStyle(fontFamily:'Poppins')),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // Handle apply filter logic here
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  child: const Text('Apply',
                  style:TextStyle(fontFamily:'Poppins')),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
