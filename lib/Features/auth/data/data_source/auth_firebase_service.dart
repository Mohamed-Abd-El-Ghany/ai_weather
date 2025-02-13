import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/forget_password_request.dart';
import '../models/login_request.dart';
import '../models/signup_request.dart';

class AuthFirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> login(LoginRequest loginRequest) async {
    await _auth.signInWithEmailAndPassword(
      email: loginRequest.email,
      password: loginRequest.password,
    );
  }

  Future<void> signup(SignupRequest signupRequest) async {
    final UserCredential userCredential =
        await _auth.createUserWithEmailAndPassword(
      email: signupRequest.email,
      password: signupRequest.password,
    );

    await FirebaseFirestore.instance
        .collection('Users')
        .doc(userCredential.user!.uid)
        .set({
      'name': signupRequest.name,
      'phone': signupRequest.phone,
      'email': signupRequest.email,
      'password': signupRequest.password,
    });
  }

  Future<void> forgetPassword(
      ForgetPasswordRequest forgetPasswordRequest) async {
    await _auth.sendPasswordResetEmail(email: forgetPasswordRequest.email);
  }

  Future<bool> isLoggedIn() async {
    if (_auth.currentUser != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}
