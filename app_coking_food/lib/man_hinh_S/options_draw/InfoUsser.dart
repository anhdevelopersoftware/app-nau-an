import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../authen/au_be.dart';

class InfoUser extends StatefulWidget {
  const InfoUser({super.key});

  @override
  _InfoUserState createState() => _InfoUserState();
}

class _InfoUserState extends State<InfoUser> {
  final TextEditingController _nickNameController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  bool _saving = false;
  final AuthService _authService = AuthService();
  String? _imageUrl;
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    DocumentSnapshot? userDoc = await _authService.getUserInfo();
    if (userDoc != null && userDoc.data() != null) {
      Map<String, dynamic>? data = userDoc.data() as Map<String, dynamic>?;
      setState(() {
        _nickNameController.text = data?['name'] ?? '';
        _numberController.text = data?['number'] ?? '';
        _addressController.text = data?['address'] ?? '';
        _imageUrl = data?['imageUrl'];
      });
    }
  }

  Future<void> _saveUserInfo(BuildContext context) async {
    final nickname = _nickNameController.text.trim();
    final number = _numberController.text.trim();
    final address = _addressController.text.trim();
    String? imageUrl = _imageUrl;

    if (_imageFile != null) {
      await _deleteOldImage();

      final userId = FirebaseAuth.instance.currentUser!.uid;
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('user_info_data/$userId/profile_image.jpg');
      final uploadTask = storageRef.putFile(_imageFile!);

      final snapshot = await uploadTask.whenComplete(() {});
      imageUrl = await snapshot.ref.getDownloadURL();
    }

    if (nickname.isNotEmpty) {
      await _authService.updateUserInfo(nickname, number, imageUrl, address);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Thông tin đã được cập nhật')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập tên')),
      );
    }
  }

  Future<void> _deleteOldImage() async {
    try {
      final oldImageRef = FirebaseStorage.instance.refFromURL(_imageUrl!);
      await oldImageRef.delete();
    } catch (e) {}
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });

      if (_imageUrl != null && _imageUrl!.isNotEmpty) {
        await _deleteOldImage();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          GestureDetector(
            onTap: () async {
              setState(() {
                _saving = true;
              });
              await _saveUserInfo(context);
              setState(() {
                _saving = false;
              });
            },
            child: Container(
              margin: const EdgeInsets.only(right: 10),
              height: 32,
              width: 32,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(colors: [
                  Color(0xffFF6645),
                  Color(0xffFFC554),
                ]),
              ),
              child: Center(
                child: _saving
                    ? const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                    : const Icon(
                        Icons.publish_sharp,
                        color: Colors.white,
                      ),
              ),
            ),
          ),
        ],
        title: const Text(
          'Thông tin tài khoản',
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Color(0xff000000)),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(15), topLeft: Radius.circular(15))),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: _imageFile != null
                    ? Image.file(_imageFile!).image
                    : _imageUrl != null
                        ? CachedNetworkImageProvider(_imageUrl!)
                        : null,
                child: _imageFile != null || _imageUrl != null
                    ? null
                    : const Icon(Icons.person, size: 50),
              ),
              TextButton(
                onPressed: _pickImage,
                child: const Text('Chọn ảnh'),
              ),
              rowText('Nickname'),
              buildContainerOnMenu(_nickNameController),
              rowText('Số điện thoại'),
              buildContainerOnMenu(_numberController),
              rowText('Địa chỉ'),
              buildContainerOnMenu(_addressController),
            ],
          ),
        ),
      ),
    );
  }

  Container buildContainerOnMenu(TextEditingController controller) {
    return Container(
      margin: const EdgeInsets.only(top: 10, bottom: 10),
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.4),
                blurRadius: 10,
                offset: const Offset(0, 3))
          ]),
      width: double.infinity,
      height: 45,
      child: Center(
        child: TextFormField(
          controller: controller,
          decoration: const InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              border: InputBorder.none),
        ),
      ),
    );
  }

  Row rowText(String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          text,
          style: const TextStyle(
            color: Color(0xff000000),
            fontWeight: FontWeight.w500,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
