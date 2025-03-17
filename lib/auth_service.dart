import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/employee_record.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class AuthService {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  
  static const String _emailKey = 'user_email';
  static const String _passwordKey = 'user_password';

  // User roles
  static const String ROLE_ADMIN = 'admin';
  static const String ROLE_EMPLOYEE = 'employee';

  // Collection names
  static const String USERS_COLLECTION = 'users';

  AuthService() {
    // Remove Firebase initialization from constructor
  }

  // Hash password
  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  // Validate role
  bool _isValidRole(String? role) {
    return role?.toLowerCase() == ROLE_ADMIN || role?.toLowerCase() == ROLE_EMPLOYEE;
  }

  Future<void> saveLoginCredentials(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_emailKey, email);
    await prefs.setString(_passwordKey, password);
  }

  Future<Map<String, String?>> getSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'email': prefs.getString(_emailKey),
      'password': prefs.getString(_passwordKey),
    };
  }

  Future<void> clearSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_emailKey);
    await prefs.remove(_passwordKey);
  }

  // Create new user with role
  Future<UserCredential> registerUser(String email, String password, {
    required String name,
    required String role,
    Map<String, dynamic> employeeData = const {},
  }) async {
    final normalizedRole = role.toLowerCase();
    if (!_isValidRole(normalizedRole)) {
      throw FirebaseAuthException(
        code: 'invalid-role',
        message: 'Invalid role. Must be either "admin" or "employee"'
      );
    }

    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        final now = DateTime.now();
        
        // Get a new write batch
        final batch = _firestore.batch();
        
        // Reference to the user document
        final userRef = _firestore.collection(USERS_COLLECTION).doc(userCredential.user!.uid);
        
        // Set the user document data
        batch.set(userRef, {
          'id': userCredential.user!.uid,
          'name': name,
          'email': email,
          'password': _hashPassword(password),
          'role': normalizedRole,
          'createdAt': FieldValue.serverTimestamp(),
          'lastLogin': now,
          'employeeData': employeeData,
        });
        
        // Create initial attendance collection
        final attendanceRef = userRef.collection('attendance').doc();
        batch.set(attendanceRef, {
          'createdAt': FieldValue.serverTimestamp(),
        });
        
        // Commit the batch
        await batch.commit();
        print('Successfully created user document and attendance collection');

        await saveLoginCredentials(email, password);
      }

      return userCredential;
    } catch (e) {
      print('Error in registerUser: $e');
      rethrow;
    }
  }

  // Get user role from Firestore
  Future<String?> getUserRole(String uid) async {
    try {
      print('Getting role for user: $uid');
      final doc = await _firestore.collection(USERS_COLLECTION).doc(uid).get();
      
      if (!doc.exists) {
        print('No user document found for uid: $uid');
        return null;
      }

      final role = doc.data()?['role'] as String?;
      print('Found role: $role');
      
      if (!_isValidRole(role)) {
        print('Invalid role found: $role');
        return null;
      }

      return role?.toLowerCase();
    } catch (e) {
      print('Error getting user role: $e');
      return null;
    }
  }

  // Login with email and password
  Future<UserCredential> loginUserWithEmailAndPassword(
    String email, 
    String password
  ) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password
      );

      if (userCredential.user == null) {
        throw FirebaseAuthException(
          code: 'user-not-found',
          message: 'No account found with this email'
        );
      }

      final userDoc = await _firestore.collection(USERS_COLLECTION)
          .doc(userCredential.user!.uid)
          .get();

      if (!userDoc.exists) {
        await signOut();
        throw FirebaseAuthException(
          code: 'user-not-found',
          message: 'User account is not properly configured'
        );
      }

      final userData = userDoc.data();
      if (!_isValidRole(userData?['role'])) {
        await signOut();
        throw FirebaseAuthException(
          code: 'invalid-role',
          message: 'Invalid account configuration'
        );
      }

      await _firestore.collection(USERS_COLLECTION)
          .doc(userCredential.user!.uid)
          .update({
        'lastLogin': FieldValue.serverTimestamp(),
      });

      await saveLoginCredentials(email, password);
      return userCredential;
    } catch (e) {
      print('Error in loginUserWithEmailAndPassword: $e');
      rethrow;
    }
  }

  // Auto login from saved credentials
  Future<User?> autoLogin() async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser != null) {
        final role = await getUserRole(currentUser.uid);
        if (_isValidRole(role)) {
          return currentUser;
        }
        await signOut();
        return null;
      }

      final credentials = await getSavedCredentials();
      final email = credentials['email'];
      final password = credentials['password'];

      if (email != null && password != null) {
        final userCredential = await loginUserWithEmailAndPassword(
          email,
          password,
        );
        return userCredential.user;
      }
    } catch (e) {
      print('Auto-login failed: $e');
      await clearSavedCredentials();
    }
    return null;
  }

  // Google Sign In
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      
      // Check if user document exists
      final userDoc = await _firestore.collection(USERS_COLLECTION)
          .doc(userCredential.user!.uid)
          .get();

      if (!userDoc.exists) {
        // Create new user document with default role
        await _firestore.collection(USERS_COLLECTION)
            .doc(userCredential.user!.uid)
            .set({
          'name': userCredential.user!.displayName,
          'email': userCredential.user!.email,
          'role': ROLE_EMPLOYEE,  // Default role for Google sign-in
          'createdAt': FieldValue.serverTimestamp(),
          'lastLogin': FieldValue.serverTimestamp(),
          'authProvider': 'google',
        });
      } else {
        // Update last login
        await _firestore.collection(USERS_COLLECTION)
            .doc(userCredential.user!.uid)
            .update({
          'lastLogin': FieldValue.serverTimestamp(),
        });
      }

      return userCredential.user;
    } catch (e) {
      print('Error in signInWithGoogle: $e');
      return null;
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      await _googleSignIn.signOut();
      await clearSavedCredentials();
    } catch (e) {
      print('Error signing out: $e');
      rethrow;
    }
  }

  // Admin operations
  Future<List<UserRecord>> getAllUsers() async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw Exception('Not authenticated');
      }

      final userRole = await getUserRole(currentUser.uid);
      if (userRole != ROLE_ADMIN) {
        throw Exception('Unauthorized access');
      }

      final snapshot = await _firestore.collection(USERS_COLLECTION).get();
      return snapshot.docs.map((doc) => 
        UserRecord.fromMap(doc.id, doc.data())).toList();
    } catch (e) {
      print('Error in getAllUsers: $e');
      rethrow;
    }
  }

  Future<UserRecord?> getUserData(String userId) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw Exception('Not authenticated');
      }

      final userRole = await getUserRole(currentUser.uid);
      if (userRole != ROLE_ADMIN && currentUser.uid != userId) {
        throw Exception('Unauthorized access');
      }

      final doc = await _firestore
          .collection(USERS_COLLECTION)
          .doc(userId)
          .get();

      if (!doc.exists) {
        return null;
      }

      return UserRecord.fromMap(doc.id, doc.data()!);
    } catch (e) {
      print('Error in getUserData: $e');
      rethrow;
    }
  }

  Future<void> updateAttendance(String userId, String date, AttendanceRecord record) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw Exception('Not authenticated');
      }

      final userRole = await getUserRole(currentUser.uid);
      if (userRole != ROLE_ADMIN && currentUser.uid != userId) {
        throw Exception('Unauthorized access');
      }

      await _firestore
          .collection(USERS_COLLECTION)
          .doc(userId)
          .update({
        'attendance.$date': record.toMap(),
      });
    } catch (e) {
      print('Error in updateAttendance: $e');
      rethrow;
    }
  }

  Future<void> updateUserData(String userId, Map<String, dynamic> data) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw Exception('Not authenticated');
      }

      final userRole = await getUserRole(currentUser.uid);
      if (userRole != ROLE_ADMIN && currentUser.uid != userId) {
        throw Exception('Unauthorized access');
      }

      // If not admin, only allow attendance updates
      if (userRole != ROLE_ADMIN) {
        if (data.keys.any((key) => !['attendance', 'employeeData'].contains(key))) {
          throw Exception('Employees can only update attendance and employee data');
        }
      }

      await _firestore
          .collection(USERS_COLLECTION)
          .doc(userId)
          .update(data);
    } catch (e) {
      print('Error in updateUserData: $e');
      rethrow;
    }
  }

  Future<void> deleteUser(String userId) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw Exception('Not authenticated');
      }

      final userRole = await getUserRole(currentUser.uid);
      if (userRole != ROLE_ADMIN) {
        throw Exception('Unauthorized access');
      }

      await _firestore
          .collection(USERS_COLLECTION)
          .doc(userId)
          .delete();
    } catch (e) {
      print('Error in deleteUser: $e');
      rethrow;
    }
  }
}