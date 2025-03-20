import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;

  User? get user => _user;

  // Đăng ký tài khoản
  Future<String?> register(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      _user = userCredential.user;
      notifyListeners();
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  // Đăng nhập
  Future<String?> login(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _user = userCredential.user;
      notifyListeners();
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  // Đăng xuất
  Future<void> logout() async {
    await _auth.signOut();
    _user = null;
    notifyListeners();
  }
}
