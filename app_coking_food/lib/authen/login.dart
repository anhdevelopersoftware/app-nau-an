import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../man_hinh_S/HomePage.dart';
import 'au_be.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _selectLogin = true;
  final TextEditingController _loginEmail = TextEditingController();
  final TextEditingController _loginPass = TextEditingController();

  final TextEditingController _signupEmail = TextEditingController();
  final TextEditingController _signupName = TextEditingController();
  final TextEditingController _signupPass = TextEditingController();
  final TextEditingController _signupConfirmPass = TextEditingController();
  final _passErr = 'Mật khẩu phải có ít nhất 8 ký tự';
  bool _passCheck = true;
  bool _obscureText = true;

  bool _passCheck2 = true;
  bool _obscureText2 = true;
  bool _passCheck3 = true;
  bool _obscureText3 = true;
  final _passConfirmErr = 'Mật khẩu không khớp';

  String? _loginError;
  bool _isLoading = false;
  final _auth = AuthService();
  bool _emailCheck = true;
  final _emailErr = 'Email không hợp lệ';
  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    bool isLoggedIn = await _auth.isLoggedIn();
    if (isLoggedIn) {
      goToHome(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Color(0xffFF6645), Color(0xffFFC554)]),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20))),
              width: double.infinity,
              height: (MediaQuery.of(context).size.height) / 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image:
                                AssetImage('assets/image_app/login_logo.png'))),
                    height: (MediaQuery.of(context).size.height) / 4.5,
                    width: (MediaQuery.of(context).size.width) / 4.5,
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    height: 20,
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              _selectLogin = true;
                            });
                          },
                          child: Text(
                            'ĐĂNG NHẬP',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: _selectLogin
                                    ? Colors.white
                                    : Colors.white.withOpacity(0.4)),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              _selectLogin = false;
                            });
                          },
                          child: Text(
                            'ĐĂNG KÝ',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: _selectLogin
                                    ? Colors.white.withOpacity(0.4)
                                    : Colors.white),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            _selectLogin
                ? Container(
                    padding: const EdgeInsets.all(20),
                    width: double.infinity,
                    height: (MediaQuery.of(context).size.height) / 1.5,
                    child: Column(
                      children: [
                        rowText("Email"),
                        buildTextFromFiled1(_loginEmail),
                        rowText('Mật khẩu'),
                        Container(
                          margin: const EdgeInsets.only(bottom: 30),
                          width: double.infinity,
                          height: 75,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextFormField(
                                obscureText: _obscureText,
                                controller: _loginPass,
                                cursorColor: Colors.black.withOpacity(0.5),
                                decoration: InputDecoration(
                                    errorText: _passCheck ? null : _passErr,
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _obscureText = !_obscureText;
                                        });
                                      },
                                      icon: Icon(
                                        _obscureText
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                      ),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 10),
                                    focusedBorder: const UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Color(0xffD2D2D2)),
                                    ),
                                    enabledBorder: const UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Color(0xffD2D2D2)),
                                    ),
                                    hintText: "Nhập thông tin",
                                    hintStyle: const TextStyle(
                                        color: Color(0xffD2D2D2),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w300)),
                              ),
                            ],
                          ),
                        ),
                        if (_loginError != null)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              _loginError!,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                        _isLoading
                            ? const CircularProgressIndicator()
                            : InkWell(
                                onTap: () {
                                  setState(() {
                                    _loginError = null;

                                    if (_loginPass.text.length < 8) {
                                      _passCheck = false;
                                    } else {
                                      _passCheck = true;
                                    }

                                    if (_passCheck) {
                                      _login();
                                    }
                                  });
                                },
                                child: Container(
                                  width: 140,
                                  height: 40,
                                  decoration: BoxDecoration(
                                      gradient: const LinearGradient(colors: [
                                        Color(0xffFFC554),
                                        Color(0xffFF6645),
                                      ]),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: const Center(
                                    child: Text(
                                      "Đăng nhập",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                      ],
                    ),
                  )
                : Container(
                    padding: const EdgeInsets.all(20),
                    width: double.infinity,
                    height: (MediaQuery.of(context).size.height) / 1,
                    child: Column(
                      children: [
                        rowText("Email"),
                        buildTextFromFiled1(_signupEmail),
                        if (!_emailCheck)
                          Text(
                            _emailErr,
                            style: const TextStyle(color: Colors.red),
                          ),
                        rowText('Họ và tên'),
                        buildTextFromFiled1(_signupName),
                        rowText('Mật Khẩu'),
                        Container(
                          margin: const EdgeInsets.only(bottom: 30),
                          width: double.infinity,
                          height: 75,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextFormField(
                                obscureText: _obscureText2,
                                controller: _signupPass,
                                cursorColor: Colors.black.withOpacity(0.5),
                                decoration: InputDecoration(
                                    errorText: _passCheck2 ? null : _passErr,
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _obscureText2 = !_obscureText2;
                                        });
                                      },
                                      icon: Icon(
                                        _obscureText2
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                      ),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 10),
                                    focusedBorder: const UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Color(0xffD2D2D2)),
                                    ),
                                    enabledBorder: const UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Color(0xffD2D2D2)),
                                    ),
                                    hintText: "Nhập thông tin",
                                    hintStyle: const TextStyle(
                                        color: Color(0xffD2D2D2),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w300)),
                              ),
                            ],
                          ),
                        ),
                        rowText('Xác Nhận Mật Khẩu'),
                        Container(
                          margin: const EdgeInsets.only(bottom: 30),
                          width: double.infinity,
                          height: 75,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextFormField(
                                obscureText: _obscureText3,
                                controller: _signupConfirmPass,
                                cursorColor: Colors.black.withOpacity(0.5),
                                decoration: InputDecoration(
                                    errorText:
                                        _passCheck3 ? null : _passConfirmErr,
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _obscureText3 = !_obscureText3;
                                        });
                                      },
                                      icon: Icon(
                                        _obscureText3
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                      ),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 10),
                                    focusedBorder: const UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Color(0xffD2D2D2)),
                                    ),
                                    enabledBorder: const UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Color(0xffD2D2D2)),
                                    ),
                                    hintText: "Nhập thông tin",
                                    hintStyle: const TextStyle(
                                        color: Color(0xffD2D2D2),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w300)),
                              ),
                            ],
                          ),
                        ),
                        _isLoading
                            ? const CircularProgressIndicator()
                            : InkWell(
                                onTap: () {
                                  _signup();
                                },
                                child: Container(
                                  width: 140,
                                  height: 40,
                                  decoration: BoxDecoration(
                                      gradient: const LinearGradient(colors: [
                                        Color(0xffFFC554),
                                        Color(0xffFF6645),
                                      ]),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: const Center(
                                    child: Text(
                                      "Đăng ký",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                      ],
                    ),
                  )
          ],
        ),
      ),
    );
  }

  Container buildTextFromFiled1(TextEditingController controller) {
    return Container(
      margin: const EdgeInsets.only(bottom: 30),
      width: double.infinity,
      height: 30,
      child: TextFormField(
        cursorColor: Colors.black.withOpacity(0.5),
        controller: controller,
        decoration: const InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 7, horizontal: 10),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xffD2D2D2)),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xffD2D2D2)),
            ),
            hintText: "Nhập thông tin",
            hintStyle: TextStyle(
                color: Color(0xffD2D2D2),
                fontSize: 16,
                fontWeight: FontWeight.w300)),
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

  goToHome(BuildContext context) => Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
  void _signup() async {
    setState(() {
      String email = _signupEmail.text;
      _emailCheck = RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email);

      if (_signupPass.text.length < 8) {
        _passCheck2 = false;
      } else {
        _passCheck2 = true;
      }

      if (_signupConfirmPass.text != _signupPass.text) {
        _passCheck3 = false;
      } else {
        _passCheck3 = true;
      }
    });

    if (_emailCheck && _passCheck2 && _passCheck3) {
      setState(() {
        _isLoading = true;
      });

      try {
        final user = await _auth.createUserWithEmailAndPassword(
          _signupEmail.text,
          _signupPass.text,
        );

        if (user != null) {
          await _auth.updateUserName(_signupName.text);
          await _auth.saveLoginState(true);
          goToHome(context);
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });

        if (e is FirebaseAuthException) {
          if (e.code == 'email-already-in-use') {
          } else {}
        } else {}
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  _login() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final user = await _auth.loginUserWithEmailAndPassword(
        _loginEmail.text,
        _loginPass.text,
      );

      if (user != null) {
        await _auth.saveLoginState(true);
        goToHome(context);
      } else {
        setState(() {
          _loginError = "Invalid email or password.";
        });
      }
    } catch (e) {
      setState(() {
        _loginError = "An error occurred. Please try again.";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
