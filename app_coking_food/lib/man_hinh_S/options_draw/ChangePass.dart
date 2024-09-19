
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../authen/au_be.dart';

class ChangerPass extends StatefulWidget {
  const ChangerPass({super.key});

  @override
  State<ChangerPass> createState() => _ChangerPassState();
}

class _ChangerPassState extends State<ChangerPass> {
  final TextEditingController _currentPassController = TextEditingController();
  final TextEditingController _newPassController = TextEditingController();
  final TextEditingController _configNewPassController =
  TextEditingController();

  bool _obscureCurrentPass = true;
  bool _obscureNewPass = true;
  bool _obscureConfigPass = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            height: 150,
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [
                Color(0xffFF6645),
                Color(0xffFFC554),
              ]),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    )),
                const Text(
                  'Đổi mật khẩu',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white),
                ),
                const SizedBox(
                  height: 40,
                  width: 40,
                )
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.only(top: 100),
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(15),
                    topLeft: Radius.circular(15))),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  rowText('Mật khẩu hiện tại'),
                  buildContainerOnMenu(
                      _currentPassController, _obscureCurrentPass, () {
                    setState(() {
                      _obscureCurrentPass = !_obscureCurrentPass;
                    });
                  }),
                  rowText('Mật khẩu mới'),
                  buildContainerOnMenu(_newPassController, _obscureNewPass, () {
                    setState(() {
                      _obscureNewPass = !_obscureNewPass;
                    });
                  }),
                  rowText('Xác nhận mật khẩu mới'),
                  buildContainerOnMenu(
                      _configNewPassController, _obscureConfigPass, () {
                    setState(() {
                      _obscureConfigPass = !_obscureConfigPass;
                    });
                  }),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      _handleChangePassword(context);
                    },
                    child: const Text(
                      'Đổi mật khẩu',
                      style: TextStyle(color: Color(0XFFff9e4e)),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Container buildContainerOnMenu(TextEditingController controller,
      bool obscureText, VoidCallback toggleObscureText) {
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
          obscureText: obscureText,
          controller: controller,
          decoration: InputDecoration(
              suffixIcon: IconButton(
                onPressed: toggleObscureText,
                icon:
                Icon(obscureText ? Icons.visibility_off : Icons.visibility),
              ),
              isDense: true,
              contentPadding:
              const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
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

  void _handleChangePassword(BuildContext context) async {
    String currentPassword = _currentPassController.text.trim();
    String newPassword = _newPassController.text.trim();
    String confirmPassword = _configNewPassController.text.trim();

    if (newPassword != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Mật khẩu mới không khớp. Vui lòng nhập lại.')),
      );
      return;
    }

    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        AuthCredential credential = EmailAuthProvider.credential(
          email: user.email!,
          password: currentPassword,
        );

        await user.reauthenticateWithCredential(credential);

        await AuthService().changePassword(newPassword);

        _currentPassController.clear();
        _newPassController.clear();
        _configNewPassController.clear();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đổi mật khẩu thành công.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Lỗi khi đổi mật khẩu. Vui lòng thử lại sau.')),
      );
    }
  }
}