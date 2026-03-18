import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/error/exceptions.dart';
import '../models/user_model.dart';
import 'package:flutter/foundation.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login({
    required String email,
    required String password,
  });

  Future<UserModel> register({
    required String email,
    required String password,
    required String name,
  });

  Future<void> logout();
  
  UserModel? getCurrentUser();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;

  AuthRemoteDataSourceImpl({required this.firebaseAuth});

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user != null) {
        return UserModel.fromFirebaseUser(userCredential.user!);
      } else {
        throw ServerException('Login failed: user is null');
      }
    } on FirebaseAuthException catch (e) {
      debugPrint('Firebase Login Error: ${e.code} - ${e.message}');
      throw ServerException(e.message ?? 'Unknown Firebase Auth Error');
    } catch (e) {
      debugPrint('Unexpected Login Error: $e');
      throw ServerException('An unexpected error occurred during login');
    }
  }

  @override
  Future<UserModel> register({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final userCredential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      final user = userCredential.user;
      if (user != null) {
        await user.updateDisplayName(name);
        // reload user to get the updated display name
        await user.reload();
        final updatedUser = firebaseAuth.currentUser;
        if(updatedUser != null) {
          return UserModel.fromFirebaseUser(updatedUser);
        } else {
           return UserModel.fromFirebaseUser(user);
        }
      } else {
        throw ServerException('Registration failed: user is null');
      }
    } on FirebaseAuthException catch (e) {
      debugPrint('Firebase Registration Error: ${e.code} - ${e.message}');
      throw ServerException(e.message ?? 'Unknown Firebase Auth Error');
    } catch (e) {
      debugPrint('Unexpected Registration Error: $e');
      throw ServerException('An unexpected error occurred during registration');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await firebaseAuth.signOut();
    } catch (e) {
      debugPrint('Logout error: $e');
      throw ServerException('An error occurred during logout');
    }
  }
  
  @override
  UserModel? getCurrentUser() {
    final user = firebaseAuth.currentUser;
    if (user != null) {
      return UserModel.fromFirebaseUser(user);
    }
    return null;
  }
}
