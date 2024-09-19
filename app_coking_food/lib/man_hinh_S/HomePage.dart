import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../authen/au_be.dart';
import '../authen/login.dart';
import '../be/be-provider/be_provider.dart';
import '../be/customer_desginer.dart';
import '../be/search/PageOptionsSearch.dart';
import '../be/search/buildSearch.dart';
import 'all_them_monan.dart';
import 'detailPostInHome.dart';
import 'options_draw/ChangePass.dart';
import 'options_draw/InfoUsser.dart';
import 'options_draw/ListPostLikeBuilder.dart';
import 'options_draw/MyPost.dart';
import 'options_draw/chinh_Sach_And_Bao_Mat.dart';

import 'options_draw/post_firebase/Share_Post.dart';
import 'options_draw/ve_chung_toi.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    super.initState();
    Provider.of<WishListPost>(context, listen: false).fetchListsFromFirebase();
    _publicPostsFuture = fetchPublicPosts();
    _loadPosts();
    _userNameFuture = _authService.getUserName();
    _loadUserProfileImage();
    wishListPost = Provider.of<WishListPost>(context, listen: false);
    wishListPost.fetchListsFromFirebase();
    searchPost = fetchPublicPosts();
  }

  Future<List<Map<String, dynamic>>> fetchPublicPosts() async {
    List<Map<String, dynamic>> publicPosts = [];
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('public_posts')
          .where('isPublic', isEqualTo: true)
          .get();

      publicPosts = querySnapshot.docs.map((doc) {
        return {
          'authorId': doc['authorId'],
          'topicImage': doc['topicImage'],
          'ingredients': doc['ingredients'],
          'intro': doc['intro'],
          'isPublic': doc['isPublic'],
          'name': doc['name'],
          'stepImages': doc['stepImages'],
          'steps': doc['steps'],
          'theme': doc['theme'],
          'timeCook': doc['timeCook'],
          'peopleCook': doc['peopleCook'],
          'idTime': doc['idTime']
        };
      }).toList();

      for (var post in publicPosts) {
        try {
          DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
              .collection('users')
              .doc(post['authorId'])
              .get();

          if (userSnapshot.exists) {
            post['authorName'] = userSnapshot['name'];
            post['authorAvatar'] = userSnapshot['imageUrl'];
          } else {
            post['authorName'] = null;
            post['authorAvatar'] = null;
          }
        } catch (e) {
          //showSnackBarTop('Error fetching user data: $e');
        }
      }
    } catch (e) {
      showSnackBarTop('Error fetching public posts: $e');
    }
    return publicPosts;
  }
  Future<List<Map<String, dynamic>>> getPosts(
      String collection, String userId) async {
    List<Map<String, dynamic>> posts = [];
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection(collection)
          .where('authorId', isEqualTo: userId)
          .get();

      posts = querySnapshot.docs.map((doc) {
        return {
          'authorId': doc['authorId'],
          'topicImage': doc['topicImage'],
          'ingredients': doc['ingredients'],
          'intro': doc['intro'],
          'isPublic': doc['isPublic'],
          'name': doc['name'],
          'stepImages': doc['stepImages'],
          'steps': doc['steps']
        };
      }).toList();

      for (var post in posts) {
        try {
          DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
              .collection('users')
              .doc(post['authorId'])
              .get();

          if (userSnapshot.exists) {
            post['authorName'] = userSnapshot['name'];
            post['authorAvatar'] = userSnapshot['imageUrl'];
          } else {
            post['authorName'] = null;
            post['authorAvatar'] = null;
          }
        } catch (e) {
          //showSnackBarTop('Error fetching user data: $e');
        }
      }
    } catch (e) {
      showSnackBarTop('Error getting posts from $collection: $e');
    }
    return posts;
  }

  Future<List<Map<String, dynamic>>>? _publicPostsFuture;

  late Future<List<Map<String, dynamic>>> ListpublicPostsFuture;
  late Future<List<Map<String, dynamic>>> ListprivatePostsFuture;
  late Future<List<Map<String, dynamic>>> searchPost;

  void _loadPosts() {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    ListpublicPostsFuture = getPosts('public_posts', userId);
    ListprivatePostsFuture = getPosts('private_posts', userId);

  }



  showSnackBarTop(String text) {
    showTopSnackBar(
      Overlay.of(context),
      CustomSnackBar.error(
        message: text,
      ),
    );
  }

  final AuthService _authService = AuthService();
  String? _imageUrl;
  File? _imageFile;
  late Future<String?> _userNameFuture;
  late WishListPost wishListPost;

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
    final provider = Provider.of<WishListPost>(context);
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: Drawer(
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
                                                            BorderRadius
                                                                .circular(10),
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
                                                                  .circular(
                                                                      7.5)),
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
                                                            BorderRadius
                                                                .circular(10),
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
                      privatePostsFuture: ListprivatePostsFuture,
                      publicPostsFuture: ListpublicPostsFuture,
                    )),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ListPostLike(
                          posts:
                              Provider.of<WishListPost>(context, listen: false)
                                  .ListFavPost,
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
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ListPostLike(
                          posts:
                              Provider.of<WishListPost>(context, listen: false)
                                  .ListSavePost,
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
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              height: 150,
              width: double.infinity,
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Color(0xffFF6645), Color(0xffFFC554)]),
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 33.6,
                        width: 128,
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(
                                    'assets/image_app/home_search_app.png'),
                                fit: BoxFit.cover)),
                      ),
                      InkWell(
                        onTap: () {
                          _scaffoldKey.currentState?.openEndDrawer();
                        },
                        child: Builder(
                          builder: (BuildContext context) {
                            return Container(
                              width: 30,
                              height: 30,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(
                                      'assets/image_app/menu_home.png'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          showSearch(
                              context: context,
                              delegate: CustomSearchDelegate(_publicPostsFuture!));
                        },
                        child: Container(
                          width:
                              MediaQuery.of(context).size.width - 20 - 46 - 20,
                          height: 46,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.white),
                          child: const Center(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.search,
                                  color: Color(0xffFF6645),
                                ),
                                Text(
                                  'Tìm kiếm bài viết',
                                  style: TextStyle(
                                    color: Color(0xffD2D2D2),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w300,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => allMonAn(
                                        futurePosts: _publicPostsFuture!,
                                      )));
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                image: const DecorationImage(
                                    image: AssetImage(
                                        'assets/image_app/tuy_chon.png'),
                                    fit: BoxFit.cover)),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height - 150,
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        textBlack('Chủ đề bài viết'),
                        InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => allMonAn(
                                            futurePosts: _publicPostsFuture!,
                                          )));
                            },
                            child: textBlue('Tất cả'))
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          buildGestureDetector('Bữa sáng'),
                          buildGestureDetector('Tráng miệng'),
                          buildGestureDetector('Tiếp khách'),
                          buildGestureDetector('Đồ chay'),
                          buildGestureDetector('Canh'),
                          buildGestureDetector('Đồ nướng'),
                          buildGestureDetector('Đồ nướng'),
                          buildGestureDetector('Bánh ngọt'),
                          buildGestureDetector('Đồ uống'),
                          buildGestureDetector('Nước lẩu'),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        textBlack('Bài viết nổi bật'),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    FutureBuilder<List<Map<String, dynamic>>>(
                      future: _publicPostsFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return const Text('No posts available');
                        } else {
                          List<Map<String, dynamic>> posts = snapshot.data!;
                          return GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              childAspectRatio: 0.65,
                              crossAxisCount: 2,
                              crossAxisSpacing: 10.0,
                              mainAxisSpacing: 10.0,
                            ),
                            itemCount: posts.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => DetailPost(
                                                imageUrlTopic: posts[index]
                                                    ['topicImage']!,
                                                imageAvatar: posts[index]['authorAvatar'],
                                                //imageAvatar: posts[index]['authorAvatar']==null?'https://firebasestorage.googleapis.com/v0/b/app-coking-food.appspot.com/o/data_image%2Fperson.jpg?alt=media&token=1230c16b-85a4-4dfa-b6af-aa1c7d2ea9dc':posts[index]['authorAvatar'],
                                                nickname: posts[index]
                                                    ['authorName']!,
                                                nameFood: posts[index]['name']!,
                                                ingredients: posts[index]
                                                    ['ingredients']!,
                                                steps: posts[index]['steps']!,
                                                imageStep: posts[index]
                                                    ['stepImages'],
                                                item: posts[index],
                                              )));
                                },
                                child: Container(
                                  width: 183,
                                  height: (183 / 0.6),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.3),
                                        spreadRadius: 0.2,
                                        blurRadius: 1,
                                        offset: const Offset(0, 3),
                                      )
                                    ],
                                    borderRadius: const BorderRadius.only(
                                        topRight: Radius.circular(10),
                                        topLeft: Radius.circular(10)),
                                  ),
                                  child: Column(
                                    children: [
                                      Container(
                                        width: 183,
                                        height: (183 / 0.7) / 2,
                                        decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(10),
                                              topLeft: Radius.circular(10)),
                                        ),
                                        child: CachedNetworkImage(
                                          imageUrl: posts[index]['topicImage'],
                                          imageBuilder:
                                              (context, imageProvider) =>
                                                  Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  const BorderRadius.only(
                                                      topRight:
                                                          Radius.circular(10),
                                                      topLeft:
                                                          Radius.circular(10)),
                                              image: DecorationImage(
                                                image: imageProvider,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          placeholder: (context, url) =>
                                              const Center(
                                                  child:
                                                      CircularProgressIndicator()),
                                          errorWidget: (context, url, error) =>
                                              Container(
                                                  width: 183,
                                                  height: 138,
                                                  decoration:
                                                      const BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            topRight: Radius
                                                                .circular(10),
                                                            topLeft:
                                                                Radius.circular(
                                                                    10)),
                                                  ),
                                                  child: const Center(
                                                      child:
                                                          Icon(Icons.error))),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.only(
                                            top: 10, left: 10, right: 10),
                                        width: 183,
                                        height: (183 / 0.8) / 2,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: 120,
                                                  //height: 30,
                                                  child: Text(
                                                    posts[index]['name'],
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 16),
                                                    softWrap: true,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 100,
                                                  //height: 15,
                                                  child: Text(
                                                    posts[index]['intro'],
                                                    style: const TextStyle(
                                                        color: Colors.grey,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 13),
                                                    softWrap: true,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    // Kiểm tra nếu posts[index] đã có trong ListFavPost thì xóa đi, ngược lại thêm vào
                                                    provider.ListFavPost.contains(posts[index])
                                                        ? provider.removeList(provider.ListFavPost, posts[index])
                                                        : provider.addList(provider.ListFavPost, posts[index]);

                                                    // In ra để kiểm tra
                                                   // print(provider.listFavPostIds.contains(posts[index]['idTime']));
                                                  },
                                                  child: Icon(
                                                    // Thay đổi icon và màu sắc dựa trên việc phần tử có trong list yêu thích hay không
                                                    provider.listFavPostIds.contains(posts[index]['idTime'])
                                                        ? Icons.favorite
                                                        : Icons.favorite_outline,
                                                    color: provider.listFavPostIds.contains(posts[index]['idTime'])
                                                        ? Colors.red
                                                        : Colors.grey,
                                                  ),
                                                ),

                                                // GestureDetector(
                                                //   onTap: () {
                                                //     provider.ListFavPost
                                                //             .contains(
                                                //                 posts[index]
                                                //                     ['idTime'])
                                                //         ? provider.removeList(
                                                //             provider
                                                //                 .ListFavPost,
                                                //             posts[index])
                                                //         : provider.addList(
                                                //             provider
                                                //                 .ListFavPost,
                                                //             posts[index]);
                                                //
                                                //     print(provider.listFavPostIds.contains(posts[index]['idTime']));
                                                //     // print(posts[index]['idTime']);
                                                //     // print(provider.ListFavPost[index]['idTime']);
                                                //
                                                //
                                                //     // for (int i  = 0 ; i<provider.ListFavPost.length;i++){
                                                //     //   print(provider.ListFavPost[i]['idTime']);
                                                //     // }
                                                //   },
                                                //   child: Icon(
                                                //     provider.ListFavPost
                                                //             .contains(
                                                //                 posts[index]
                                                //                     ['idTime'])
                                                //         ? Icons.favorite
                                                //         : Icons
                                                //             .favorite_outline,
                                                //     color: provider.ListFavPost
                                                //             .contains(
                                                //                 posts[index]
                                                //                     ['idTime'])
                                                //         ? Colors.red
                                                //         : Colors.grey,
                                                //   ),
                                                // ),
                                                GestureDetector(
                                                  onTap: () {
                                                    // Kiểm tra nếu posts[index] đã có trong ListFavPost thì xóa đi, ngược lại thêm vào
                                                    provider.ListSavePost.contains(posts[index])
                                                        ? /*provider.removeList(provider.ListSavePost, posts[index])*/null
                                                        : provider.addList(provider.ListSavePost, posts[index]);

                                                    // In ra để kiểm tra
                                                    // print(provider.listFavPostIds.contains(posts[index]['idTime']));
                                                  },
                                                  child: Icon(
                                                    // Thay đổi icon và màu sắc dựa trên việc phần tử có trong list yêu thích hay không
                                                    provider.listSavePostIds.contains(posts[index]['idTime'])
                                                        ? Icons.bookmark
                                                        : Icons.bookmark_border,
                                                    color: provider.listSavePostIds.contains(posts[index]['idTime'])
                                                        ? Colors.yellow
                                                        : Colors.grey,
                                                  ),
                                                ),
                                                // GestureDetector(
                                                //   onTap: () {
                                                //     provider.ListSavePost
                                                //             .contains(
                                                //                 posts[index]
                                                //                     ['idTime'])
                                                //         ? /*provider.removeList(
                                                //             provider
                                                //                 .ListSavePost,
                                                //             posts[index])*/null
                                                //         : provider.addList(
                                                //             provider
                                                //                 .ListSavePost,
                                                //             posts[index]);
                                                //   },
                                                //   child: Icon(
                                                //     provider.ListSavePost
                                                //             .contains(
                                                //                 posts[index]
                                                //                     ['idTime'])
                                                //         ? Icons.bookmark
                                                //         : Icons.bookmark_border,
                                                //     color: provider.ListSavePost
                                                //             .contains(
                                                //                 posts[index]
                                                //                     ['idTime'])
                                                //         ? Colors.yellow
                                                //         : Colors.grey,
                                                //   ),
                                                // ),
                                                GestureDetector(
                                                  onTap: () {
                                                    String appLink =
                                                        'https://play.google.com/store/apps/details?id=com.sdcompany.luxury.app_coking_food';
                                                    Share.share(
                                                        'Check out this awesome app: $appLink');
                                                  },
                                                  child: Icon(
                                                    Icons.share_rounded,
                                                    color: Colors.black
                                                        .withOpacity(0.7),
                                                  ),
                                                )
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                CircleAvatar(
                                                  radius: 15,
                                                  backgroundColor:
                                                      Colors.grey[300],
                                                  backgroundImage: posts[index][
                                                              'authorAvatar'] ==
                                                          null
                                                      ? null
                                                      : NetworkImage(
                                                          posts[index]
                                                              ['authorAvatar']),
                                                ),
                                                SizedBox(
                                                  height: 30,
                                                  child: Center(
                                                    child: SizedBox(
                                                      width: 100,
                                                      //height: 30,
                                                      child: Text(
                                                        posts[index]
                                                            ['authorName'],
                                                        overflow:
                                                            TextOverflow.ellipsis,
                                                        style: const TextStyle(
                                                            color:
                                                                Color(0xff000000),
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontSize: 14),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        }
                      },
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  GestureDetector ingredient(String content, Widget widgetPage) {
    return GestureDetector(
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

  GestureDetector buildGestureDetector(String content) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FilteredPostsWidget(
                futurePosts: _publicPostsFuture!,
                filterField: 'theme',
                filterValue: content /*'15 - 30 phút'*/,
              ),
            ));
      },
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        height: 30,
        decoration: BoxDecoration(
            color: const Color(0xffFFE5B3),
            borderRadius: BorderRadius.circular(38)),
        child: Center(
            child: Text(
          content,
          style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: Color(0xffD77400)),
        )),
      ),
    );
  }

  Text textBlue(String text) {
    return Text(
      text,
      style: const TextStyle(
          color: Color(0xff00B1C9), fontSize: 14, fontWeight: FontWeight.w400),
    );
  }

  Text textBlack(String text) {
    return Text(
      text,
      style: const TextStyle(
          fontWeight: FontWeight.w500, fontSize: 16, color: Color(0xff000000)),
    );
  }
}
