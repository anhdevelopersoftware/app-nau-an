import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

class AuthService {
  final _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String?> getUserName() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(user.uid).get();
      return userDoc.get('name');
    }
    return null;
  }

  Future<User?> registerWithEmail(
      String email, String password, String name) async {
    try {
      final UserCredential cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _firestore.collection('users').doc(cred.user!.uid).set({
        'name': name,
        'email': email,
      });

      return cred.user;
    } catch (e) {
      return null;
    }
  }

  Future<void> updateUserInfo(
      String name, String number, String? imageUrl, String address) async {
    User? user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).set({
        'name': name,
        'number': number,
        'imageUrl': imageUrl,
        'address': address,
      }, SetOptions(merge: true));
    }
  }

  Future<void> changePassword(String newPassword) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await user.updatePassword(newPassword);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<DocumentSnapshot?> getUserInfo() async {
    User? user = _auth.currentUser;
    if (user != null) {
      return await _firestore.collection('users').doc(user.uid).get();
    }
    return null;
  }

  Future<void> updateUserName(String name) async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        await _firestore.collection('users').doc(user.uid).set({
          'name': name,
        }, SetOptions(merge: true));
      } catch (e) {
        throw ('Lỗi khi cập nhật tên người dùng: $e');
      }
    }
  }

  Future<void> saveLoginState(bool isLoggedIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', isLoggedIn);
  }

  Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  Future<User?> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return cred.user;
    } catch (e) {
      return null;
    }
  }

  Future<User?> loginUserWithEmailAndPassword(
      String email, String password) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return cred.user;
    } catch (e) {
      return null;
    }
  }

  Future<void> signout() async {
    try {
      await _auth.signOut();
      await saveLoginState(false);
    } catch (e) {}
  }

  Future<String> uploadImage(File imageFile) async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      Reference ref = _storage.ref().child('user_files/$userId/profile.jpg');
      UploadTask uploadTask = ref.putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      return '';
    }
  }
}
