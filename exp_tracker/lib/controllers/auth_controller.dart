import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthController extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  User? get currentUser => _auth.currentUser;

  // Register with Email and Password
  Future<String?> register({
    required String email,
    required String password,
    required String name,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      debugPrint('Attempting to register user: $email');
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Update display name
      await credential.user?.updateDisplayName(name);
      
      debugPrint('Firebase Registration Successful: ${credential.user?.uid}');
      _isLoading = false;
      notifyListeners();
      return null; // Success
    } on FirebaseAuthException catch (e) {
      debugPrint('Firebase Registration Error: ${e.code} - ${e.message}');
      _isLoading = false;
      notifyListeners();
      return e.message;
    } catch (e) {
      debugPrint('Unexpected Registration Error: $e');
      _isLoading = false;
      notifyListeners();
      return 'An unexpected error occurred';
    }
  }

  // Login with Email and Password
  Future<String?> login({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      debugPrint('Attempting to login user: $email');
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      debugPrint('Firebase Login Successful');
      _isLoading = false;
      notifyListeners();
      return null; // Success
    } on FirebaseAuthException catch (e) {
      debugPrint('Firebase Login Error: ${e.code} - ${e.message}');
      _isLoading = false;
      notifyListeners();
      return e.message;
    } catch (e) {
      debugPrint('Unexpected Login Error: $e');
      _isLoading = false;
      notifyListeners();
      return 'An unexpected error occurred';
    }
  }

  // Logout
  Future<void> logout() async {
    await _auth.signOut();
    notifyListeners();
  }
}
