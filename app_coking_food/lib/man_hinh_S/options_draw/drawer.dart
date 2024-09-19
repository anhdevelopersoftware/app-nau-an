import 'dart:io';

import 'package:app_coking_food/man_hinh_S/options_draw/post_firebase/Share_Post.dart';
import 'package:app_coking_food/man_hinh_S/options_draw/ve_chung_toi.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../authen/au_be.dart';
import '../../authen/login.dart';
import '../../be/be-provider/be_provider.dart';
import '../../be/customer_desginer.dart';
import 'ChangePass.dart';
import 'InfoUsser.dart';
import 'ListPostLikeBuilder.dart';
import 'MyPost.dart';
import 'chinh_Sach_And_Bao_Mat.dart';

class drawer extends StatefulWidget {
  final Future<List<Map<String, dynamic>>> publicPostsFuture;
  final Future<List<Map<String, dynamic>>> privatePostsFuture;

  const drawer(
      {super.key,
      required this.publicPostsFuture,
      required this.privatePostsFuture});
  @override
  State<drawer> createState() => _drawerState();
}

class _drawerState extends State<drawer> {
  final AuthService _authService = AuthService();
  String? _imageUrl;
  File? _imageFile;
  late Future<String?> _userNameFuture;
  late WishListPost wishListPost;

  @override
  void initState() {
    super.initState();
    _userNameFuture = _authService.getUserName();
    _loadUserProfileImage();
    wishListPost = Provider.of<WishListPost>(context, listen: false);
    wishListPost.fetchListsFromFirebase();
  }

  Future<void> _loadUserProfileImage() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    String imagePath = 'user_info_data/$userId/profile_image.jpg';
    try {
      final ref = FirebaseStorage.instance.ref().child(imagePath);
      _imageUrl = await ref.getDownloadURL();
      setState(() {});
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
   // final provider = Provider.of<WishListPost>(context);
    return Drawer(
      width: (MediaQuery.of(context).size.width) * (2 / 3),
      child: Padding(
        padding: const EdgeInsets.only(top: 40 /*,left: 15,right: 15*/),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'MENU',
                      style: TextStyle(
                          color: Color(0xff000000),
                          fontWeight: FontWeight.w500,
                          fontSize: 16),
                    ),
                    GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(Icons.close)),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                padding: const EdgeInsets.all(10),
                height: 40,
                width: double.infinity,
                decoration: const BoxDecoration(color: Color(0xffFFEECD)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.grey[300],
                          backgroundImage: _imageUrl != null
                              ? NetworkImage(_imageUrl!)
                              : null,
                          child: _imageFile != null || _imageUrl == null
                              ? const Icon(Icons.person,
                                  color: Colors.grey, size: 20)
                              : null,
                        ),
                        FutureBuilder<String?>(
                          future: _userNameFuture,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const SizedBox(
                                height: 20,
                                width: 20,
                                child: Center(
                                    child: CircularProgressIndicator(
                                  strokeWidth: 1.5,
                                )),
                              );
                            }
                            if (snapshot.hasError) {
                              return const Text(
                                'Error',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: Colors.white),
                              );
                            }
                            String? userName = snapshot.data;
                            return SizedBox(
                              width: (MediaQuery.of(context).size.width) / 3,
                              child: Text(
                                userName ?? 'Tên người dùng',
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    color: Color(0xff000000),
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    GestureDetector(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return Dialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Container(
                                    width: 290,
                                    height: 200,
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'Đăng xuất',
                                          style: TextStyle(
                                              color: Color(0xff000000),
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        const Divider(),
                                        const Text(
                                          'Bạn có chắc chắn muốn đăng xuất ?',
                                          style: TextStyle(fontSize: 16),
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(height: 24),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.pop(context);
                                              },
                                              child: Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      gradient:
                                                          const LinearGradient(
                                                              colors: [
                                                            Color(0xffFF6645),
                                                            Color(0xffFFC554)
                                                          ])),
                                                  height: 40,
                                                  width: 100,
                                                  child: Center(
                                                      child: Container(
                                                    height: 35,
                                                    width: 94.95,
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(7.5)),
                                                    child: const Center(
                                                      child: GradientText(
                                                        gradient:
                                                            LinearGradient(
                                                          colors: [
                                                            Color(0xffFF6645),
                                                            Color(0xffFFC554)
                                                          ],
                                                          begin: Alignment
                                                              .bottomLeft,
                                                          end: Alignment
                                                              .topRight,
                                                        ),
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                        text: 'Hủy',
                                                      ),
                                                    ),
                                                  ))),
                                            ),
                                            GestureDetector(
                                              onTap: () async {
                                                await _authService.signout();
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            LoginPage()));
                                              },
                                              child: Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      gradient:
                                                          const LinearGradient(
                                                              colors: [
                                                            Color(0xffFF6645),
                                                            Color(0xffFFC554)
                                                          ])),
                                                  height: 40,
                                                  width: 100,
                                                  child: const Center(
                                                    child: Text(
                                                      'Đồng ý',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 15.8),
                                                    ),
                                                  )),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              });
                        },
                        child: const Icon(
                          Icons.logout_outlined,
                          color: Color(0xffFF3535),
                        ))
                  ],
                ),
              ),
              ingredient('Thông tin cá nhân', const InfoUser()),
              ingredient(
                  'Bài viết của tôi',
                  MyPost(
                    privatePostsFuture: widget.privatePostsFuture,
                    publicPostsFuture: widget.publicPostsFuture,
                  )),
              // ingredient(
              //     'Bài viết đã thích',
              //   Consumer<WishListPost>(
              //     builder: (context, provider, child) {
              //       return ListPostLike(
              //         icon: const Icon(
              //           Icons.favorite_outline,
              //           size: 150,
              //           color: Colors.grey,
              //         ),
              //         posts: provider.ListFavPost,
              //         title: 'Bài viết đã thích',
              //       );
              //     },
              //   ),
              //     // ListPostLike(
              //     //   icon: const Icon(
              //     //     Icons.favorite_outline,
              //     //     size: 150,
              //     //     color: Colors.grey,
              //     //   ),
              //     //   posts: provider.ListFavPost,
              //     //   title: 'Bài viết đã thích',
              //     // )
              // ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context); // Đóng Drawer
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ListPostLike(
                        posts: Provider.of<WishListPost>(context, listen: false).ListFavPost,
                        title: 'Bài viết đã thích',
                        icon: const Icon(
                          Icons.favorite_outline,
                          size: 150,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  );
                },
                child: Container(
                  color: Colors.white.withOpacity(0),
                  margin: const EdgeInsets.only(top: 10),
                  child: const Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'Bài viết đã thích',
                              style: TextStyle(
                                  color: Color(0xff000000),
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        endIndent: 10,
                        indent: 10,
                      )
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context); // Đóng Drawer
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ListPostLike(
                        posts: Provider.of<WishListPost>(context, listen: false).ListSavePost,
                        title: 'Bài viết đã lưu',
                        icon: const Icon(
                          Icons.bookmark_border,
                          size: 150,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  );
                },
                child: Container(
                  color: Colors.white.withOpacity(0),
                  margin: const EdgeInsets.only(top: 10),
                  child: const Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'Bài viết đã lưu',
                              style: TextStyle(
                                  color: Color(0xff000000),
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        endIndent: 10,
                        indent: 10,
                      )
                    ],
                  ),
                ),
              ),
              // ingredient(
              //     'Bài viết đã lưu',
              //   Consumer<WishListPost>(
              //     builder: (context, provider, child) {
              //       return ListPostLike(
              //         icon: const Icon(
              //           Icons.bookmark_border,
              //           size: 150,
              //           color: Colors.grey,
              //         ),
              //         posts: provider.ListSavePost,
              //         title: 'Bài viết đã lưu',
              //       );
              //     },
              //   ),
              //     // ListPostLike(
              //     //   icon: const Icon(
              //     //     Icons.bookmark_border,
              //     //     size: 150,
              //     //     color: Colors.grey,
              //     //   ),
              //     //   posts: provider.ListSavePost,
              //     //   title: 'Bài viết đã lưu',
              //     // )
              // ),
              ingredient('Chính sách và bảo mật', const ChinhSachAndBaoMat()),
              ingredient('Về chúng tôi', const InfoMy()),
              GestureDetector(
                onTap: () {
                  String appLink =
                      'https://play.google.com/store/apps/details?id=com.sdcompany.luxury.app_coking_food';
                  Share.share('Check out this awesome app: $appLink');
                },
                child: Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: const Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'Chia sẽ ứng dụng',
                              style: TextStyle(
                                  color: Color(0xff000000),
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        endIndent: 10,
                        indent: 10,
                      )
                    ],
                  ),
                ),
              ),
              ingredient('Đổi mật khẩu', const ChangerPass()),
              ingredient('Chia sẽ bài viết ', SharePost()),
            ],
          ),
        ),
      ),
    );
  }

  GestureDetector ingredient(String content, Widget widgetPage) {
    return
      GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (content) => widgetPage));
      },
      child: Container(
        color: Colors.white.withOpacity(0),
        margin: const EdgeInsets.only(top: 10),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    content,
                    style: const TextStyle(
                        color: Color(0xff000000),
                        fontWeight: FontWeight.w400,
                        fontSize: 16),
                  ),
                ],
              ),
            ),
            const Divider(
              endIndent: 10,
              indent: 10,
            )
          ],
        ),
      ),
    );
  }
}
