// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:image_picker/image_picker.dart';
//
// class PersonalDetailsScreen extends StatefulWidget {
//   const PersonalDetailsScreen({super.key});
//
//   @override
//   State<PersonalDetailsScreen> createState() => _PersonalDetailsScreenState();
// }
//
// class _PersonalDetailsScreenState extends State<PersonalDetailsScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _nameController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _phoneController = TextEditingController();
//   final _roleController = TextEditingController();
//   final _departmentController = TextEditingController();
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   bool _isLoading = false;
//   final List<String> _roles = [
//     'Software Developer',
//     'Frontend Developer',
//     'Backend Developer',
//     'Full-Stack Developer',
//     'Mobile App Developer',
//     'DevOps Engineer	',
//     'Software Architect',
//     'QA Engineer (Tester)',
//   ];
//   String? _selectedRole;
//   final List<String> _departments = [
//     'React Developer',
//     'Angular Developer',
//     'UI/UX Developer',
//     'Nodejs Developer',
//     'Python Developer',
//     'Java Developer',
//     'PHP Developer',
//     'Golang Developer',
//     'C#/.NET Developer',
//     'MERN Developer',
//     'Flutter Developer',
//   ];
//   String? _selectedDepartment;
//
//   File? _imageFile;
//   final ImagePicker _picker = ImagePicker();
//   bool _isUploadingImage = false;
//
//   Future<void> _pickImage() async {
//     try {
//       final XFile? pickedFile = await _picker.pickImage(
//         source: ImageSource.gallery,
//         maxWidth: 512,
//         maxHeight: 512,
//         imageQuality: 75,
//       );
//
//       if (pickedFile != null) {
//         setState(() {
//           _imageFile = File(pickedFile.path);
//         });
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Error picking image: ${e.toString()}'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }
//
//   Future<String?> _uploadImage() async {
//     if (_imageFile == null) return null;
//
//     try {
//       setState(() => _isUploadingImage = true);
//
//       // Create a unique file name
//       final String fileName = 'employee_${DateTime.now().millisecondsSinceEpoch}.jpg';
//       final Reference storageRef = FirebaseStorage.instance
//           .ref()
//           .child('employee_photos')
//           .child(fileName);
//
//       // Upload the file
//       await storageRef.putFile(_imageFile!);
//
//       // Get the download URL
//       final String downloadURL = await storageRef.getDownloadURL();
//       return downloadURL;
//     } catch (e) {
//       print('Error uploading image: $e');
//       return null;
//     } finally {
//       setState(() => _isUploadingImage = false);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.blue,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.white),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: const Text(
//           'Add Employee',
//           style: TextStyle(
//             fontFamily: 'Poppins',
//             color: Colors.white,
//           ),
//         ),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Center(
//                 child: Stack(
//                   children: [
//                     CircleAvatar(
//                       radius: 50,
//                       backgroundImage: _imageFile != null
//                           ? FileImage(_imageFile!) as ImageProvider
//                           : const AssetImage('assets/images/main_profile.png'),
//                     ),
//                     Positioned(
//                       bottom: 0,
//                       right: 0,
//                       child: GestureDetector(
//                         onTap: _pickImage,
//                         child: Container(
//                           padding: const EdgeInsets.all(4),
//                           decoration: const BoxDecoration(
//                             color: Colors.blue,
//                             shape: BoxShape.circle,
//                           ),
//                           child: _isUploadingImage
//                               ? const SizedBox(
//                                   width: 20,
//                                   height: 20,
//                                   child: CircularProgressIndicator(
//                                     color: Colors.white,
//                                     strokeWidth: 2,
//                                   ),
//                                 )
//                               : const Icon(
//                                   Icons.camera_alt,
//                                   color: Colors.white,
//                                   size: 20,
//                                 ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 24),
//               _buildTextField(
//                 controller: _nameController,
//                 label: 'Full Name',
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter full name';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 16),
//               _buildTextField(
//                 controller: _emailController,
//                 label: 'Email',
//                 keyboardType: TextInputType.emailAddress,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter email';
//                   }
//                   if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
//                     return 'Please enter a valid email';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 16),
//               _buildTextField(
//                 controller: _phoneController,
//                 label: 'Phone Number',
//                 keyboardType: TextInputType.phone,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter phone number';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 16),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     'Role',
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w500,
//                       fontFamily: 'Poppins',
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   DropdownButtonFormField<String>(
//                     value: _selectedRole,
//                     decoration: InputDecoration(
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                         borderSide: const BorderSide(color: Colors.blue),
//                       ),
//                       enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                         borderSide: const BorderSide(color: Colors.blue),
//                       ),
//                     ),
//                     hint: const Text('Select Role'),
//                     items: _roles.map((String role) {
//                       return DropdownMenuItem<String>(
//                         value: role,
//                         child: Text(
//                           role,
//                           style: const TextStyle(fontFamily: 'Poppins'),
//                         ),
//                       );
//                     }).toList(),
//                     onChanged: (String? newValue) {
//                       setState(() {
//                         _selectedRole = newValue;
//                         _roleController.text = newValue ?? '';
//                       });
//                     },
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please select a role';
//                       }
//                       return null;
//                     },
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 16),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     'Department',
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w500,
//                       fontFamily: 'Poppins',
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   DropdownButtonFormField<String>(
//                     value: _selectedDepartment,
//                     decoration: InputDecoration(
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                         borderSide: const BorderSide(color: Colors.blue),
//                       ),
//                       enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                         borderSide: const BorderSide(color: Colors.blue),
//                       ),
//                     ),
//                     hint: const Text('Select Department'),
//                     items: _departments.map((String department) {
//                       return DropdownMenuItem<String>(
//                         value: department,
//                         child: Text(
//                           department,
//                           style: const TextStyle(fontFamily: 'Poppins'),
//                         ),
//                       );
//                     }).toList(),
//                     onChanged: (String? newValue) {
//                       setState(() {
//                         _selectedDepartment = newValue;
//                         _departmentController.text = newValue ?? '';
//                       });
//                     },
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please select a department';
//                       }
//                       return null;
//                     },
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 24),
//               SizedBox(
//                 width: double.infinity,
//                 height: 50,
//                 child: ElevatedButton(
//                   onPressed: _isLoading ? null : _handleSubmit,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.blue,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                   child: _isLoading
//                       ? const CircularProgressIndicator(color: Colors.white)
//                       : const Text(
//                           'Add Employee',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 16,
//                             fontFamily: 'Poppins',
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTextField({
//     required TextEditingController controller,
//     required String label,
//     TextInputType? keyboardType,
//     String? Function(String?)? validator,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: const TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.w500,
//             fontFamily: 'Poppins',
//           ),
//         ),
//         const SizedBox(height: 8),
//         TextFormField(
//           controller: controller,
//           keyboardType: keyboardType,
//           decoration: InputDecoration(
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide: const BorderSide(color: Colors.blue),
//             ),
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide: const BorderSide(color: Colors.blue),
//             ),
//           ),
//           validator: validator,
//         ),
//       ],
//     );
//   }
//
//   Future<void> _handleSubmit() async {
//     if (_formKey.currentState!.validate()) {
//       setState(() => _isLoading = true);
//       try {
//         final user = _auth.currentUser;
//         if (user == null) throw 'Not authenticated';
//
//         // Upload image if selected
//         String? photoURL;
//         if (_imageFile != null) {
//           photoURL = await _uploadImage();
//         }
//
//         await _firestore.collection('users').add({
//           'name': _nameController.text.trim(),
//           'email': _emailController.text.trim(),
//           'phone': _phoneController.text.trim(),
//           'role': _selectedRole,
//           'department': _selectedDepartment,
//           'photoURL': photoURL,
//           'createdAt': FieldValue.serverTimestamp(),
//           'createdBy': user.uid,
//           'status': 'active',
//           'lastUpdated': FieldValue.serverTimestamp(),
//         });
//
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               content: Text('Employee added successfully'),
//               backgroundColor: Colors.green,
//             ),
//           );
//           Navigator.pop(context);
//         }
//       } catch (e) {
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text('Error adding employee: ${e.toString()}'),
//               backgroundColor: Colors.red,
//             ),
//           );
//         }
//       } finally {
//         if (mounted) {
//           setState(() => _isLoading = false);
//         }
//       }
//     }
//   }
//
//   @override
//   void dispose() {
//     _nameController.dispose();
//     _emailController.dispose();
//     _phoneController.dispose();
//     _roleController.dispose();
//     _departmentController.dispose();
//     super.dispose();
//   }
// }
//
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:image_picker/image_picker.dart';
//
// import '../attendance/attendance_list.dart';
// import '../home_screen.dart';
// import 'employeescreen.dart';
//
// class PersonalDetailsScreen extends StatefulWidget {
//   const PersonalDetailsScreen({super.key});
//
//   @override
//   State<PersonalDetailsScreen> createState() => _PersonalDetailsScreenState();
// }
//
// class _PersonalDetailsScreenState extends State<PersonalDetailsScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _nameController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _phoneController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _domainController = TextEditingController();
//   final _roleController = TextEditingController();
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//
//   bool _isLoading = false;
//   String? _selectedRole;
//   String? _selectedDomain;
//   String? _selectedDepartment;
//
//   final List<String> _roles = ['Admin', 'Employee'];
//   final List<String> _domains = [
//     'Software Developer',
//     'Frontend Developer',
//     'Backend Developer',
//     'Full-Stack Developer',
//     'Mobile App Developer',
//     'DevOps Engineer',
//     'Software Architect',
//     'QA Engineer (Tester)',
//   ];
//   final List<String> _departments = [
//     'React Developer',
//     'Angular Developer',
//     'UI/UX Developer',
//     'Nodejs Developer',
//     'Python Developer',
//     'Java Developer',
//     'PHP Developer',
//     'Golang Developer',
//     'C#/.NET Developer',
//     'MERN Developer',
//     'Flutter Developer',
//   ];
//
//   File? _imageFile;
//   final ImagePicker _picker = ImagePicker();
//   bool _isUploadingImage = false;
//
//   Future<void> _pickImage() async {
//     try {
//       final XFile? pickedFile = await _picker.pickImage(
//         source: ImageSource.gallery,
//         maxWidth: 512,
//         maxHeight: 512,
//         imageQuality: 75,
//       );
//
//       if (pickedFile != null) {
//         setState(() {
//           _imageFile = File(pickedFile.path);
//         });
//       }
//     } catch (e) {
//       _showSnackbar('Error picking image: ${e.toString()}');
//     }
//   }
//
//   Future<String?> _uploadImage() async {
//     if (_imageFile == null) return null;
//
//     try {
//       setState(() => _isUploadingImage = true);
//       final String fileName = 'employee_${DateTime.now().millisecondsSinceEpoch}.jpg';
//       final Reference storageRef = FirebaseStorage.instance
//           .ref()
//           .child('employee_photos')
//           .child(fileName);
//
//       await storageRef.putFile(_imageFile!);
//       return await storageRef.getDownloadURL();
//     } catch (e) {
//       _showSnackbar('Error uploading image: $e');
//       return null;
//     } finally {
//       setState(() => _isUploadingImage = false);
//     }
//   }
//
//   Future<void> _handleAddEmployee() async {
//     if (_formKey.currentState!.validate()) {
//       setState(() => _isLoading = true);
//       try {
//         final UserCredential userCred = await _auth.createUserWithEmailAndPassword(
//           email: _emailController.text.trim(),
//           password: _passwordController.text.trim(),
//         );
//
//         if (userCred.user == null) throw 'User registration failed';
//
//         String? photoURL = await _uploadImage();
//
//         await _firestore.collection('users').doc(userCred.user!.uid).set({
//           'uid': userCred.user!.uid,
//           'name': _nameController.text.trim(),
//           'email': _emailController.text.trim(),
//           'phone': _phoneController.text.trim(),
//           'role': _selectedRole,
//           'domain': _selectedDomain,
//           'department': _selectedDepartment,
//           'photoURL': photoURL,
//           'createdAt': FieldValue.serverTimestamp(),
//           'status': 'active',
//         });
//
//         if (mounted) {
//           if (_selectedRole == 'Admin') {
//             Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(builder: (context) => const AttendanceList()),
//             );
//           } else if (_selectedRole == 'Employee') {
//             Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(builder: (context) => const EmployeeScreen()),
//             );
//           }
//           _showSnackbar('Employee added successfully', Colors.green);
//         }
//       } on FirebaseAuthException catch (e) {
//         _showSnackbar(_getFirebaseErrorMessage(e));
//       } catch (e) {
//         _showSnackbar('Error adding employee: ${e.toString()}');
//       } finally {
//         setState(() => _isLoading = false);
//       }
//     }
//   }
//
//   String _getFirebaseErrorMessage(FirebaseAuthException e) {
//     switch (e.code) {
//       case 'email-already-in-use':
//         return 'An account already exists with this email';
//       case 'weak-password':
//         return 'Password is too weak';
//       default:
//         return e.message ?? 'Registration failed';
//     }
//   }
//
//   void _showSnackbar(String message, [Color color = Colors.red]) {
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//       content: Text(message),
//       backgroundColor: color,
//     ));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.blue,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.white),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: const Text(
//           'Add Employee',
//           style: TextStyle(fontFamily: 'Poppins', color: Colors.white),
//         ),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               Center(
//                 child: GestureDetector(
//                   onTap: _pickImage,
//                   child: CircleAvatar(
//                     radius: 50,
//                     backgroundImage: _imageFile != null
//                         ? FileImage(_imageFile!) as ImageProvider
//                         : const AssetImage('assets/images/main_profile.png'),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 24),
//               _buildTextField(_nameController, 'Full Name'),
//               _buildTextField(_emailController, 'Email', keyboardType: TextInputType.emailAddress),
//               _buildTextField(_phoneController, 'Phone Number', keyboardType: TextInputType.phone),
//               _buildTextField(_passwordController, 'Password', keyboardType: TextInputType.visiblePassword, obscureText: true),
//               // _buildTextField(_domainController, 'Domain', keyboardType: TextInputType.d),
//               // _buildTextField(_roleController, 'Role', keyboardType: TextInputType.phone),
//               _buildDropdown('Role', _roles, _selectedRole, (value) => setState(() => _selectedRole = value)),
//               _buildDropdown('Domain', _domains, _selectedDomain, (value) => setState(() => _selectedDomain = value)),
//               _buildDropdown('Department', _departments, _selectedDepartment, (value) => setState(() => _selectedDepartment = value)),
//               const SizedBox(height: 24),
//               ElevatedButton(
//                 onPressed: _isLoading ? null : _handleAddEmployee,
//                 style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
//                 child: _isLoading
//                     ? const CircularProgressIndicator(color: Colors.white)
//                     : const Text('Add Employee', style: TextStyle(color: Colors.white)),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTextField(
//       TextEditingController controller,
//       String label, {
//         TextInputType keyboardType = TextInputType.text,
//         bool obscureText = false,
//       }) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: TextFormField(
//         controller: controller,
//         keyboardType: keyboardType,
//         obscureText: obscureText,
//         decoration: InputDecoration(labelText: label, border: OutlineInputBorder()),
//         validator: (value) => value == null || value.isEmpty ? 'Please enter $label' : null,
//       ),
//     );
//   }
//     Widget _buildDropdown(String label, List<String> items, String? selectedItem, ValueChanged<String?> onChanged) {
//      return Padding(
//        padding: const EdgeInsets.symmetric(vertical: 8),
//        child: DropdownButtonFormField<String>(
//          decoration: InputDecoration(labelText: label, border: OutlineInputBorder()),
//          value: selectedItem,
//          onChanged: onChanged,
//          items: items.map((String value) {
//            return DropdownMenuItem<String>(
//              value: value,
//              child: Text(value),
//            );
//          }).toList(),
//        ),
//      );
//    }
// }


import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

import '../attendance/attendance_list.dart';
import '../home_screen.dart';
import 'employeescreen.dart';

class PersonalDetailsScreen extends StatefulWidget {
  const PersonalDetailsScreen({super.key});

  @override
  State<PersonalDetailsScreen> createState() => _PersonalDetailsScreenState();
}

class _PersonalDetailsScreenState extends State<PersonalDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isLoading = false;
  bool _isObscured = true; // Password visibility toggle
  String? _selectedRole;
  String? _selectedDomain;
  String? _selectedDepartment;

  final List<String> _roles = ['admin', 'employee'];
  final List<String> _domains = [
    'Software Developer', 'Frontend Developer', 'Backend Developer', 'Full-Stack Developer',
    'Mobile App Developer', 'DevOps Engineer', 'Software Architect', 'QA Engineer (Tester)',
  ];
  final List<String> _departments = [
    'React Developer', 'Angular Developer', 'UI/UX Developer', 'Nodejs Developer', 'Python Developer',
    'Java Developer', 'PHP Developer', 'Golang Developer', 'C#/.NET Developer', 'MERN Developer', 'Flutter Developer',
  ];

  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  bool _isUploadingImage = false;

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 75,
      );

      if (pickedFile != null) {
        setState(() => _imageFile = File(pickedFile.path));
      }
    } catch (e) {
      _showSnackbar('Error picking image: ${e.toString()}');
    }
  }

  Future<String?> _uploadImage() async {
    if (_imageFile == null) return null;

    try {
      setState(() => _isUploadingImage = true);
      final String fileName = 'employee_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final Reference storageRef = FirebaseStorage.instance.ref().child('employee_photos').child(fileName);

      await storageRef.putFile(_imageFile!);
      return await storageRef.getDownloadURL();
    } catch (e) {
      _showSnackbar('Error uploading image: $e');
      return null;
    } finally {
      setState(() => _isUploadingImage = false);
    }
  }

  Future<void> _handleAddEmployee() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        final UserCredential userCred = await _auth.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        if (userCred.user == null) throw 'User registration failed';

        String? photoURL = await _uploadImage();

        await _firestore.collection('users').doc(userCred.user!.uid).set({
          'uid': userCred.user!.uid,
          'name': _nameController.text.trim(),
          'email': _emailController.text.trim(),
          'phone': _phoneController.text.trim(),
          'role': _selectedRole,
          'domain': _selectedDomain,
          'department': _selectedDepartment,
          'photoURL': photoURL,
          'createdAt': FieldValue.serverTimestamp(),
          'status': 'active',
        });

        if (mounted) {
          if (_selectedRole == 'admin') {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const EmployeeScreen()));
          } else if (_selectedRole == 'employee') {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const EmployeeScreen()));
          }
          _showSnackbar('Employee added successfully', Colors.green);
        }
      } on FirebaseAuthException catch (e) {
        _showSnackbar(_getFirebaseErrorMessage(e));
      } catch (e) {
        _showSnackbar('Error adding employee: ${e.toString()}');
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  String _getFirebaseErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'An account already exists with this email';
      case 'weak-password':
        return 'Password is too weak';
      default:
        return e.message ?? 'Registration failed';
    }
  }

  void _showSnackbar(String message, [Color color = Colors.red]) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: color));
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
        title: const Text('Add Employee', style: TextStyle(fontFamily: 'Poppins', color: Colors.white)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildProfileImagePicker(),
              _buildTextField(_nameController, 'Full Name'),
              _buildTextField(_emailController, 'Email', keyboardType: TextInputType.emailAddress),
              _buildTextField(_phoneController, 'Phone Number', keyboardType: TextInputType.phone, phoneValidation: true),
              _buildPasswordField(),
              _buildDropdown('Role', _roles, _selectedRole, (value) => setState(() => _selectedRole = value)),
              _buildDropdown('Domain', _domains, _selectedDomain, (value) => setState(() => _selectedDomain = value)),
              _buildDropdown('Department', _departments, _selectedDepartment, (value) => setState(() => _selectedDepartment = value)),
              const SizedBox(height: 24),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImagePicker() {
    return Center(
      child: GestureDetector(
        onTap: _pickImage,
        child: CircleAvatar(
          radius: 50,
          backgroundImage: _imageFile != null ? FileImage(_imageFile!) : const AssetImage('assets/images/main_profile.png'),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {TextInputType keyboardType = TextInputType.text, bool phoneValidation = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(labelText: label, border: OutlineInputBorder()),
        validator: (value) {
          if (value == null || value.isEmpty) return 'Please enter $label';
          if (phoneValidation && (value.length < 10 || !RegExp(r'^\d+$').hasMatch(value))) return 'Enter a valid phone number';
          return null;
        },
      ),
    );
  }

  Widget _buildPasswordField() {
    return _buildTextField(_passwordController, 'Password', keyboardType: TextInputType.visiblePassword);
  }

  Widget _buildDropdown(String label, List<String> items, String? selectedItem, ValueChanged<String?> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(labelText: label, border: OutlineInputBorder()),
        value: selectedItem,
        onChanged: onChanged,
        items: items.map((String value) => DropdownMenuItem(value: value, child: Text(value))).toList(),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: _isLoading ? null : _handleAddEmployee,
      style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
      child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text('Add Employee', style: TextStyle(color: Colors.white)),
    );
  }
}
