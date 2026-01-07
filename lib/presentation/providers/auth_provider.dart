import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/user_entity.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  UserEntity? _user;
  UserEntity? get user => _user;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;
  Future<void> updateProfile(String newName) async {
    if (_user == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      // 1. Update the name in Firebase Authentication
      await _auth.currentUser?.updateDisplayName(newName);

      // 2. Update the name in Firestore
      await _firestore.collection('users').doc(_user!.uid).update({
        'fullName': newName,
      });

      // 3. Update the local user object manually to refresh the UI
      _user = UserEntity(
        uid: _user!.uid,
        email: _user!.email,
        fullName: newName,
      );

      _error = null;
    } catch (e) {
      _error = e.toString();
      debugPrint("Error updating profile: $e");
    } finally {
      _isLoading = false;
      notifyListeners(); // This makes the new name show up on the Dashboard
    }
  }

  // Your existing SignIn
  Future<bool> signIn(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final credential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password
      );

      final doc = await _firestore.collection('users').doc(credential.user!.uid).get();
      final data = doc.data();

      if (data != null) {
        _user = UserEntity(
          uid: credential.user!.uid,
          email: email,
          fullName: data['fullName'] ?? 'User',
        );
        return true;
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    return false;
  }

  // Your existing SignUp
  Future<void> signUp(String email, String password, String fullName) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final credential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password
      );

      await credential.user?.updateDisplayName(fullName);

      await _firestore.collection('users').doc(credential.user!.uid).set({
        'email': email,
        'fullName': fullName,
        'uid': credential.user!.uid,
      });

      _user = UserEntity(
        uid: credential.user!.uid,
        email: email,
        fullName: fullName,
      );
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    _user = null;
    notifyListeners();
  }
}