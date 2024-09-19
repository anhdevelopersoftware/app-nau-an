import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class WishListPost with ChangeNotifier {
  List<Map<String, dynamic>> ListFavPost = [];
  List<Map<String, dynamic>> ListSavePost = [];

  List<String> get listFavPostIds =>
      ListFavPost.map((item) => item['idTime'] as String).toList();
  List<String> get listSavePostIds =>
      ListSavePost.map((item) => item['idTime'] as String).toList();

  void addList(List<Map<String, dynamic>> list, Map<String, dynamic> item) async {
    if (!list.contains(item)) { // Kiểm tra trước khi thêm
      list.add(item);
      notifyListeners();
      await uploadListsToFirebase();
    }
  }

  void removeList(List<Map<String, dynamic>> list, Map<String, dynamic> item) async {
    if (list.contains(item)) { // Kiểm tra trước khi xóa
      list.remove(item);
      notifyListeners();
      await uploadListsToFirebase();
    }
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<void> uploadListsToFirebase() async {
    try {
      final String uid =
          _auth.currentUser!.uid; // Lấy UID của người dùng đã đăng nhập

      await _firestore.collection('public_posts').doc(uid).set({
        'ListFavPost': ListFavPost,
        'ListSavePost': ListSavePost,
      }, SetOptions(merge: true));

      //print('Upload successful');
    } catch (e) {
      //print('Error uploading lists: $e');
    }
  }
  Future<void> fetchListsFromFirebase() async {
    try {
      final String uid = _auth.currentUser!.uid; // Lấy UID của người dùng đã đăng nhập
      final DocumentSnapshot doc = await _firestore.collection('public_posts').doc(uid).get();

      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;

        ListFavPost = List<Map<String, dynamic>>.from(data['ListFavPost'] ?? []);
        ListSavePost = List<Map<String, dynamic>>.from(data['ListSavePost'] ?? []);
        notifyListeners();
      } else {
        //print('Document does not exist');
      }
    } catch (e) {
      //print('Error fetching lists: $e');
    }
  }

}
