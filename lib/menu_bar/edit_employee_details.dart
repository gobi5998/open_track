// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:image_picker/image_picker.dart';
//
// class EditEmployeeDetails extends StatefulWidget {
//   final Map<String, dynamic> employeeData;
//
//   const EditEmployeeDetails({
//     super.key,
//     required this.employeeData,
//   });
//
//   @override
//   State<EditEmployeeDetails> createState() => _EditEmployeeDetailsState();
// }
//
// class _EditEmployeeDetailsState extends State<EditEmployeeDetails> {
//   final _formKey = GlobalKey<FormState>();
//   late final TextEditingController _nameController;
//   late final TextEditingController _emailController;
//   late final TextEditingController _phoneController;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   bool _isLoading = false;
//   String? _selectedRole;
//   String? _selectedDepartment;
//   File? _imageFile;
//   final ImagePicker _picker = ImagePicker();
//   bool _isUploadingImage = false;
//   String? _currentPhotoURL;
//
//   // Add your roles and departments lists here (same as in personal_details.dart)
//   final List<String> _roles = [
//     'Software Developer',
//     'Frontend Developer',
//     'Backend Developer',
//     'Full-Stack Developer',
//     'Mobile App Developer',
//     'DevOps Engineer',
//     'Software Architect',
//     'QA Engineer (Tester)',
//   ];
//
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
//   @override
//   void initState() {
//     super.initState();
//     _nameController = TextEditingController(text: widget.employeeData['name']);
//     _emailController = TextEditingController(text: widget.employeeData['email']);
//     _phoneController = TextEditingController(text: widget.employeeData['phone']);
//     _selectedRole = widget.employeeData['role'];
//     _selectedDepartment = widget.employeeData['department'];
//     _currentPhotoURL = widget.employeeData['photoURL'];
//   }
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
//       // Create storage reference
//       final storageRef = FirebaseStorage.instance.ref();
//
//       // Make sure the employee_photos directory exists
//       final employeePhotosRef = storageRef.child('employee_photos');
//
//       // Create a unique filename
//       final String fileName = 'employee_${DateTime.now().millisecondsSinceEpoch}.jpg';
//       final photoRef = employeePhotosRef.child(fileName);
//
//       // Upload file with metadata
//       final metadata = SettableMetadata(
//         contentType: 'image/jpeg',
//         customMetadata: {
//           'uploaded_by': FirebaseAuth.instance.currentUser?.uid ?? 'unknown',
//           'uploaded_at': DateTime.now().toIso8601String(),
//         },
//       );
//
//       // Start upload task
//       final uploadTask = photoRef.putFile(_imageFile!, metadata);
//
//       // Wait for upload to complete
//       final snapshot = await uploadTask;
//
//       // Get download URL
//       if (snapshot.state == TaskState.success) {
//         final downloadURL = await snapshot.ref.getDownloadURL();
//
//         // Delete old photo if exists
//         if (_currentPhotoURL != null && _currentPhotoURL!.isNotEmpty) {
//           try {
//             final oldPhotoRef = FirebaseStorage.instance.refFromURL(_currentPhotoURL!);
//             await oldPhotoRef.delete();
//           } catch (e) {
//             print('Error deleting old photo: $e');
//           }
//         }
//
//         return downloadURL;
//       } else {
//         throw 'Upload failed';
//       }
//     } catch (e) {
//       print('Error uploading image: $e');
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Error uploading image: ${e.toString()}'),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//       return null;
//     } finally {
//       if (mounted) {
//         setState(() => _isUploadingImage = false);
//       }
//     }
//   }
//
//   Future<void> _handleUpdate() async {
//     if (_formKey.currentState!.validate()) {
//       setState(() => _isLoading = true);
//       try {
//         String? photoURL = _currentPhotoURL;
//         if (_imageFile != null) {
//           photoURL = await _uploadImage();
//         }
//
//         await _firestore.collection('employees').doc(widget.employeeData['id']).update({
//           'name': _nameController.text.trim(),
//           'email': _emailController.text.trim(),
//           'phone': _phoneController.text.trim(),
//           'role': _selectedRole,
//           'department': _selectedDepartment,
//           if (photoURL != null) 'photoURL': photoURL,
//           'lastUpdated': FieldValue.serverTimestamp(),
//         });
//
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               content: Text('Employee updated successfully'),
//               backgroundColor: Colors.green,
//             ),
//           );
//           Navigator.pop(context, true); // Return true to indicate successful update
//         }
//       } catch (e) {
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text('Error updating employee: ${e.toString()}'),
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
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.blue,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.white),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: const Text(
//           'Edit Employee',
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
//                           : (_currentPhotoURL != null
//                               ? NetworkImage(_currentPhotoURL!) as ImageProvider
//                               : const AssetImage('assets/images/main_profile.png')),
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
//               _buildDropdown(
//                 label: 'Role',
//                 value: _selectedRole,
//                 items: _roles,
//                 onChanged: (String? newValue) {
//                   setState(() => _selectedRole = newValue);
//                 },
//               ),
//               const SizedBox(height: 16),
//               _buildDropdown(
//                 label: 'Department',
//                 value: _selectedDepartment,
//                 items: _departments,
//                 onChanged: (String? newValue) {
//                   setState(() => _selectedDepartment = newValue);
//                 },
//               ),
//               const SizedBox(height: 24),
//               SizedBox(
//                 width: double.infinity,
//                 height: 50,
//                 child: ElevatedButton(
//                   onPressed: _isLoading ? null : _handleUpdate,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.blue,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                   child: _isLoading
//                       ? const CircularProgressIndicator(color: Colors.white)
//                       : const Text(
//                           'Update Employee',
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
//   Widget _buildDropdown({
//     required String label,
//     required String? value,
//     required List<String> items,
//     required void Function(String?) onChanged,
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
//         DropdownButtonFormField<String>(
//           value: value,
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
//           items: items.map((String item) {
//             return DropdownMenuItem<String>(
//               value: item,
//               child: Text(
//                 item,
//                 style: const TextStyle(fontFamily: 'Poppins'),
//               ),
//             );
//           }).toList(),
//           onChanged: onChanged,
//           validator: (value) {
//             if (value == null || value.isEmpty) {
//               return 'Please select a ${label.toLowerCase()}';
//             }
//             return null;
//           },
//         ),
//       ],
//     );
//   }
//
//   @override
//   void dispose() {
//     _nameController.dispose();
//     _emailController.dispose();
//     _phoneController.dispose();
//     super.dispose();
//   }
// }

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class EditEmployeeDetails extends StatefulWidget {
  final String userId; // Pass the employee ID

  const EditEmployeeDetails({super.key, required this.userId});

  @override
  State<EditEmployeeDetails> createState() => _EditEmployeeDetailsState();
}

class _EditEmployeeDetailsState extends State<EditEmployeeDetails> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ImagePicker _picker = ImagePicker();

  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  String? _selectedRole;
  File? _imageFile;
  bool _isLoading = false;
  bool _isUploadingImage = false;
  String? _photoURL;

  final List<String> _roles = [
    'Software Developer',
    'Frontend Developer',
    'Backend Developer',
    'Full-Stack Developer',
    'Mobile App Developer',
    'DevOps Engineer',
    'Software Architect',
    'QA Engineer (Tester)',
  ];

  @override
  void initState() {
    super.initState();
    _loadEmployeeDetails();
  }

  /// ✅ Load employee details from Firestore
  Future<void> _loadEmployeeDetails() async {
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(widget.userId).get();
      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        setState(() {
          _nameController.text = data['name'] ?? '';
          _emailController.text = data['email'] ?? '';
          _selectedRole = data['role'] ?? '';
          _photoURL = data['photoURL'];
          _isLoading = false;
        });
      }
    } catch (e) {
      _showSnackbar("Error loading details: ${e.toString()}", Colors.red);
    }
  }

  /// ✅ Pick an image from the gallery
  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 75,
      );

      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      _showSnackbar("Error picking image: ${e.toString()}", Colors.red);
    }
  }

  /// ✅ Upload image to Firebase Storage and get URL
  Future<String?> _uploadImage() async {
    if (_imageFile == null) return null;

    try {
      setState(() => _isUploadingImage = true);

      final storageRef = FirebaseStorage.instance.ref().child('profile_pictures/${widget.userId}.jpg');
      await storageRef.putFile(_imageFile!);

      return await storageRef.getDownloadURL();
    } catch (e) {
      _showSnackbar("Error uploading image: ${e.toString()}", Colors.red);
      return null;
    } finally {
      setState(() => _isUploadingImage = false);
    }
  }

  /// ✅ Update Firestore with the new details
  Future<void> _handleUpdate() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      String? photoURL = _photoURL;
      if (_imageFile != null) {
        photoURL = await _uploadImage();
      }

      // ✅ Print the data being sent to Firestore
      Map<String, dynamic> updatedData = {
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'role': _selectedRole,
        if (photoURL != null) 'photoURL': photoURL,
        'lastUpdated': FieldValue.serverTimestamp(),
      };

      print("Updating Firestore for userId: ${widget.userId}");
      print("Data being sent: $updatedData");

      await _firestore.collection('users').doc(widget.userId).update(updatedData);

      print("Update successful!");

      _showSnackbar("Employee updated successfully!", Colors.green);
      Navigator.pop(context, true);
    } catch (e) {
      print("Error updating employee: $e");
      _showSnackbar("Error updating employee: ${e.toString()}", Colors.red);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// ✅ Show Snackbar Messages
  void _showSnackbar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Employee")),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 🔹 Profile Picture
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: _imageFile != null
                          ? FileImage(_imageFile!) as ImageProvider
                          : (_photoURL != null
                          ? NetworkImage(_photoURL!)
                          : const AssetImage('assets/images/main_profile.png')),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
                          child: _isUploadingImage
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              /// 🔹 Name Field
              _buildTextField(controller: _nameController, label: "Full Name"),
              const SizedBox(height: 16),

              /// 🔹 Email Field
              _buildTextField(controller: _emailController, label: "Email", keyboardType: TextInputType.emailAddress),
              const SizedBox(height: 16),

              /// 🔹 Role Dropdown
              // _buildDropdown(
              //   label: "Role",
              //   value: _selectedRole,
              //   items: _roles,
              //   onChanged: (newValue) => setState(() => _selectedRole = newValue),
              // ),
              const SizedBox(height: 24),

              /// 🔹 Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleUpdate,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Update Employee", style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({required TextEditingController controller, required String label, TextInputType? keyboardType}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(labelText: label, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
      validator: (value) => value == null || value.isEmpty ? "Please enter $label" : null,
    );
  }

  // Widget _buildDropdown({required String label, required String? value, required List<String> items, required void Function(String?) onChanged}) {
  //   return DropdownButtonFormField<String>(
  //     value: value,
  //     decoration: InputDecoration(labelText: label, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
  //     items: items.map((item) => DropdownMenuItem<String>(value: item, child: Text(item))).toList(),
  //     onChanged: onChanged,
  //     validator: (value) => value == null || value.isEmpty ? "Please select a $label" : null,
  //   );
  // }
}

