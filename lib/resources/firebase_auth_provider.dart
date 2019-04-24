import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthProvider {
  FirebaseAuth _auth = FirebaseAuth.instance;
  Future<FirebaseUser> login(email, password) {
    print(email);
    print(password);

    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<FirebaseUser> getCurrentUser() async {
    return _auth.currentUser();
  }

  Future<FirebaseUser> signup(
      String email, String password, String username) async {
    var user = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    UserUpdateInfo updateInfo = UserUpdateInfo();
    updateInfo.displayName = username;
    await user.updateProfile(updateInfo);
    return user;
  }

  Future<void> logout() {
    return _auth.signOut();
  }
}
