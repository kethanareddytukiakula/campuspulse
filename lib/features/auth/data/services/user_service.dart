import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/user_model.dart';

class UserService {
  final FirebaseFirestore _firestore;

  UserService({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Reference to users collection
  CollectionReference<Map<String, dynamic>> get _usersCollection =>
      _firestore.collection('users');

  /// Create a new user profile in Firestore
  Future<UserModel> createUserProfile({
    required String uid,
    required String name,
    required String email,
    required String regNo,
    required String course,
    required String year,
  }) async {
    try {
      final userModel = UserModel(
        uid: uid,
        name: name,
        email: email,
        regNo: regNo,
        course: course,
        year: year,
        createdAt: DateTime.now(),
      );

      await _usersCollection.doc(uid).set(userModel.toMap());

      return userModel;
    } catch (e) {
      throw Exception('Failed to create user profile: $e');
    }
  }

  /// Retrieve user profile from Firestore
  Future<UserModel?> getUserProfile(String uid) async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> snapshot =
          await _usersCollection.doc(uid).get();

      if (snapshot.exists && snapshot.data() != null) {
        return UserModel.fromMap(snapshot.data()!, uid);
      }

      return null;
    } catch (e) {
      throw Exception('Failed to retrieve user profile: $e');
    }
  }

  /// Update user profile
  Future<void> updateUserProfile({
    required String uid,
    required Map<String, dynamic> data,
  }) async {
    try {
      await _usersCollection.doc(uid).update(data);
    } catch (e) {
      throw Exception('Failed to update user profile: $e');
    }
  }

  /// Delete user profile
  Future<void> deleteUserProfile(String uid) async {
    try {
      await _usersCollection.doc(uid).delete();
    } catch (e) {
      throw Exception('Failed to delete user profile: $e');
    }
  }

  /// Check if user profile exists
  Future<bool> userProfileExists(String uid) async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> snapshot =
          await _usersCollection.doc(uid).get();
      return snapshot.exists;
    } catch (e) {
      throw Exception('Failed to check user profile: $e');
    }
  }
}
