import 'package:app_coking_food/man_hinh_S/options_draw/post_firebase/Share_Post.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../detailPostInHome.dart';

class MyPost extends StatefulWidget {
  final Future<List<Map<String, dynamic>>> publicPostsFuture;
  final Future<List<Map<String, dynamic>>> privatePostsFuture;

  const MyPost(
      {super.key,
      required this.publicPostsFuture,
      required this.privatePostsFuture});
  @override
  State<MyPost> createState() => _MyPostState();
}

class _MyPostState extends State<MyPost> {
  bool select = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bài viết của tôi'),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SharePost()));
            },
            child: Container(
              width: 100,
              height: 32,
              decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [
                    Color(0xffFFC554),
                    Color(0xffFF6645),
                  ]),
                  borderRadius: BorderRadius.circular(8.35)),
              child: const Center(
                  child: Text(
                '+ Thêm',
                style: TextStyle(
                    color: Color(0xffFFFFFF),
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              )),
            ),
          ),
          const SizedBox(
            width: 10,
          )
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 30,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          select = true;
                        });
                      },
                      child: Text(
                        'Chưa xuất bản',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: select
                                ? const Color(0xff000000)
                                : const Color(0xffD2D2D2)),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          select = false;
                        });
                      },
                      child: Text(
                        'Đã xuất bản',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: select
                                ? const Color(0xffD2D2D2)
                                : const Color(0xff000000)),
                      ),
                    )
                  ],
                ),
              ),
              select
                  ? SizedBox(
                      width: (MediaQuery.of(context).size.width) - 20,
                      height: (MediaQuery.of(context).size.height) - 70,
                      child: FutureBuilder<List<Map<String, dynamic>>>(
                        future: widget.privatePostsFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            if (snapshot.error.toString().contains('403')) {
                              return const Center(
                                child: Text(
                                    'Access denied. Please check your permissions.'),
                              );
                            } else {
                              return Center(
                                  child: Text('Error: ${snapshot.error}'));
                            }
                            // return Center(
                            //     child: Text('Error: ${snapshot.error}'));
                          } else if (!snapshot.hasData ||
                              snapshot.data!.isEmpty) {
                            return const Center(
                                child: Text('No posts available'));
                          } else {
                            List<Map<String, dynamic>> posts = snapshot.data!;
                            return GridView.builder(
                              //shrinkWrap: true,
                              //physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                childAspectRatio: 0.65,
                                crossAxisCount: 2,
                                crossAxisSpacing: 10.0,
                                mainAxisSpacing: 10.0,
                              ),
                              itemCount: posts.length,
                              itemBuilder: (context, index) {
                                final item = posts[index];
                                return Container(
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
                                      ),
                                    ],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    children: [
                                      Container(
                                        width: 183,
                                        height: (183 / 0.7) / 2,
                                        decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            topRight: Radius.circular(10),
                                          ),
                                        ),
                                        child: CachedNetworkImage(
                                          imageUrl: item['topicImage'],
                                          imageBuilder:
                                              (context, imageProvider) =>
                                                  GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      DetailPost(
                                                    imageUrlTopic: posts[index]
                                                        ['topicImage']!,
                                                    imageAvatar: posts[index]
                                                        ['authorAvatar'],
                                                    //imageAvatar: posts[index]['authorAvatar']==null?'https://firebasestorage.googleapis.com/v0/b/app-coking-food.appspot.com/o/data_image%2Fperson.jpg?alt=media&token=1230c16b-85a4-4dfa-b6af-aa1c7d2ea9dc':posts[index]['authorAvatar'],
                                                    nickname: posts[index]
                                                        ['authorName']!,
                                                    nameFood: posts[index]
                                                        ['name']!,
                                                    ingredients: posts[index]
                                                        ['ingredients']!,
                                                    steps: posts[index]
                                                        ['steps']!,
                                                    imageStep: posts[index]
                                                        ['stepImages'],
                                                    item: posts[index],
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    const BorderRadius.only(
                                                  topLeft: Radius.circular(10),
                                                  topRight: Radius.circular(10),
                                                ),
                                                image: DecorationImage(
                                                  image: imageProvider,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          ),
                                          placeholder: (context, url) =>
                                              const Center(
                                                  child:
                                                      CircularProgressIndicator()),
                                          errorWidget: (context, url, error) =>
                                              GestureDetector(
                                            onTap: () {
                                              showTopSnackBar(
                                                Overlay.of(context),
                                                const CustomSnackBar.success(
                                                  message:
                                                      'Bài này của bạn đã được đăng thành công rồi!',
                                                ),
                                              );
                                            },
                                            child: Container(
                                              width: 183,
                                              height: 138,
                                              decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(10),
                                                  topRight: Radius.circular(10),
                                                ),
                                              ),
                                              child: const Center(
                                                  child: Icon(Icons.error)),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        width: 183,
                                        height: (183 / 0.8) / 2,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              //height: 30,
                                              width: 120,
                                              child: Text(
                                                posts[index]['name'],
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16,
                                                ),
                                                softWrap: true,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            SizedBox(
                                              //height: 30,
                                              width: 100,
                                              child: Text(
                                                posts[index]['intro'],
                                                style: const TextStyle(
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 13,
                                                ),
                                                softWrap: true,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
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
                                                  backgroundImage: item[
                                                              'authorAvatar'] ==
                                                          null
                                                      ? null
                                                      : NetworkImage(
                                                          item['authorAvatar']),
                                                ),
                                                SizedBox(
                                                  //height: 30,
                                                  width: 100,
                                                  child: Center(
                                                    child: Text(
                                                      item['authorName'],
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
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          }
                        },
                      ),
                    )
                  : SizedBox(
                      width: (MediaQuery.of(context).size.width) - 20,
                      height: (MediaQuery.of(context).size.height) - 70,
                      child: FutureBuilder<List<Map<String, dynamic>>>(
                        future: widget.publicPostsFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          } else if (!snapshot.hasData ||
                              snapshot.data!.isEmpty) {
                            return const Center(
                                child: Text('No posts available'));
                          } else {
                            List<Map<String, dynamic>> posts = snapshot.data!;
                            return GridView.builder(
                              //shrinkWrap: true,
                              //physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                childAspectRatio: 0.65,
                                crossAxisCount: 2,
                                crossAxisSpacing: 10.0,
                                mainAxisSpacing: 10.0,
                              ),
                              itemCount: posts.length,
                              itemBuilder: (context, index) {
                                final item = posts[index];
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DetailPost(
                                          imageUrlTopic: posts[index]
                                              ['topicImage']!,
                                          imageAvatar: posts[index]
                                              ['authorAvatar'],
                                          //imageAvatar: posts[index]['authorAvatar']==null?'https://firebasestorage.googleapis.com/v0/b/app-coking-food.appspot.com/o/data_image%2Fperson.jpg?alt=media&token=1230c16b-85a4-4dfa-b6af-aa1c7d2ea9dc':posts[index]['authorAvatar'],
                                          nickname: posts[index]['authorName']!,
                                          nameFood: posts[index]['name']!,
                                          ingredients: posts[index]
                                              ['ingredients']!,
                                          steps: posts[index]['steps']!,
                                          imageStep: posts[index]['stepImages'],
                                          item: posts[index],
                                        ),
                                      ),
                                    );
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
                                        ),
                                      ],
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      children: [
                                        Container(
                                          width: 183,
                                          height: (183 / 0.7) / 2,
                                          decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              topRight: Radius.circular(10),
                                            ),
                                          ),
                                          child: CachedNetworkImage(
                                            imageUrl: item['topicImage'],
                                            imageBuilder:
                                                (context, imageProvider) =>
                                                    Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    const BorderRadius.only(
                                                  topLeft: Radius.circular(10),
                                                  topRight: Radius.circular(10),
                                                ),
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
                                            errorWidget:
                                                (context, url, error) =>
                                                    Container(
                                              width: 183,
                                              height: 138,
                                              decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(10),
                                                  topRight: Radius.circular(10),
                                                ),
                                              ),
                                              child: const Center(
                                                  child: Icon(Icons.error)),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.all(10),
                                          width: 183,
                                          height: (183 / 0.8) / 2,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                //height: 30,
                                                width: 120,
                                                child: Text(
                                                  posts[index]['name'],
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 16,
                                                  ),
                                                  softWrap: true,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              SizedBox(
                                                //height: 30,
                                                width: 100,
                                                child: Text(
                                                  posts[index]['intro'],
                                                  style: const TextStyle(
                                                    color: Colors.grey,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 13,
                                                  ),
                                                  softWrap: true,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          }
                        },
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }
}

// class DetailMyPost extends StatelessWidget {
//   final String imageUrlTopic;
//   final String? imageAvatar;
//   final String nickname;
//   final String nameFood;
//   final List<dynamic> ingredients;
//   final List<dynamic> steps;
//   final List<dynamic> imageStep;
//   final Map<String, dynamic> item;
//   const DetailMyPost(
//       {super.key,
//       required this.imageUrlTopic,
//       required this.imageAvatar,
//       required this.nickname,
//       required this.nameFood,
//       required this.ingredients,
//       required this.steps,
//       required this.imageStep,
//       required this.item});
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         width: double.infinity,
//         height: double.infinity,
//         padding:
//             const EdgeInsets.only(left: 15, right: 15, bottom: 10, top: 30),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   GestureDetector(
//                       onTap: () {
//                         Navigator.pop(context);
//                       },
//                       child: const Icon(
//                         Icons.arrow_back_ios,
//                         color: Colors.black,
//                       )),
//                   const Text(
//                     'Chi tiết bài viết',
//                     style: TextStyle(
//                         color: Color(0xff000000),
//                         fontSize: 18,
//                         fontWeight: FontWeight.w500),
//                   ),
//                 ],
//               ),
//               s10(),
//               Container(
//                 width: double.infinity,
//                 height: 300,
//                 decoration:
//                     BoxDecoration(borderRadius: BorderRadius.circular(10)),
//                 child: CachedNetworkImage(
//                   imageUrl: imageUrlTopic,
//                   imageBuilder: (context, imageProvider) => Container(
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(10),
//                       image: DecorationImage(
//                         image: imageProvider,
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                   ),
//                   placeholder: (context, url) =>
//                       const Center(child: CircularProgressIndicator()),
//                   errorWidget: (context, url, error) => const Icon(Icons.error),
//                 ),
//               ),
//               const SizedBox(
//                 height: 15,
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     crossAxisAlignment: CrossAxisAlignment.end,
//                     children: [
//                       CircleAvatar(
//                         radius: 15,
//                         backgroundColor: Colors.grey[300],
//                         backgroundImage: null == imageAvatar
//                             ? null
//                             : NetworkImage(imageAvatar!),
//                         child: imageAvatar == null
//                             ? null
//                             : const Icon(Icons.person,
//                                 color: Colors.grey, size: 20),
//                       ),
//                       const SizedBox(
//                         width: 10,
//                       ),
//                       SizedBox(
//                         width: 100,
//                         height: 30,
//                         child: Center(
//                           child: Text(
//                             nickname,
//                             overflow: TextOverflow.ellipsis,
//                             style: const TextStyle(
//                                 color: Color(0xff000000),
//                                 fontWeight: FontWeight.w400,
//                                 fontSize: 14),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const Text(
//                     'Tác giả',
//                     style: TextStyle(
//                         fontWeight: FontWeight.w500,
//                         fontSize: 14,
//                         color: Color(0xffD2D2D2)),
//                   )
//                 ],
//               ),
//               s10(),
//               SizedBox(
//                 //height: 30,
//                 width: 100,
//                 child: Text(
//                   nameFood,
//                   style: const TextStyle(
//                       fontWeight: FontWeight.w500,
//                       fontSize: 18,
//                       color: Colors.black),
//                 ),
//               ),
//               s10(),
//               const SizedBox(
//                 //height: 30,
//                 width: 100,
//                 child: Text(
//                   'Nguyên liệu',
//                   style: TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.w500,
//                       color: Color(0xff00B1C9)),
//                 ),
//               ),
//               s10(),
//               Container(
//                 padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(10),
//                   color: const Color(0xffF6F6F6),
//                 ),
//                 child: ListView.builder(
//                   shrinkWrap: true,
//                   physics: const NeverScrollableScrollPhysics(),
//                   itemCount: ingredients.length,
//                   itemBuilder: (context, index) {
//                     final ingredient = ingredients[index];
//                     return Row(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           ingredient['name'],
//                           style: const TextStyle(
//                             color: Colors.black,
//                             fontWeight: FontWeight.w400,
//                             fontSize: 16,
//                           ),
//                         ),
//                         Text(
//                           '${ingredient['quantity']}  ${ingredient['unit']}',
//                           style: const TextStyle(
//                             color: Colors.black,
//                             fontWeight: FontWeight.w400,
//                             fontSize: 14,
//                           ),
//                         ),
//                       ],
//                     );
//                   },
//                 ),
//               ),
//               s10(),
//               const Text(
//                 'Cách thực hiện',
//                 style: TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w500,
//                     color: Color(0xff00B1C9)),
//               ),
//               s10(),
//               Container(
//                 padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                     color: const Color(0xffF6F6F6),
//                     borderRadius: BorderRadius.circular(10)),
//                 child: ListView.builder(
//                   shrinkWrap: true,
//                   physics: const NeverScrollableScrollPhysics(),
//                   itemCount: steps.length,
//                   itemBuilder: (context, index) {
//                     final step = steps[index];
//                     return Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'Bước ${index + 1} ',
//                           style: const TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w400,
//                           ),
//                         ),
//                         s10(),
//                         Text(
//                           '$step',
//                           style: const TextStyle(
//                               fontWeight: FontWeight.w300, fontSize: 14),
//                         ),
//                         s10(),
//                       ],
//                     );
//                   },
//                 ),
//               ),
//               s10(),
//               const Text(
//                 'Hình ảnh mô tả',
//                 style: TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w500,
//                     color: Color(0xff00B1C9)),
//               ),
//               s10(),
//               Container(
//                 padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                     color: const Color(0xffF6F6F6),
//                     borderRadius: BorderRadius.circular(10)),
//                 child: imageStep == null || imageStep.isEmpty
//                     ? const Center(
//                   child: Text(
//                     'Không có hình ảnh mô tả',
//                     style: TextStyle(color: Colors.grey),
//                   ),
//                 )
//                     : ListView.separated(
//                   shrinkWrap: true,
//                   physics: const NeverScrollableScrollPhysics(),
//                   itemCount: steps.length,
//                   itemBuilder: (context, index) {
//                     final imageUrl = imageStep[index];
//                     return CachedNetworkImage(
//                       imageUrl: imageUrl,
//                       imageBuilder: (context, imageProvider) => Container(
//                         height: 200,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(10),
//                           image: DecorationImage(
//                             image: imageProvider,
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                       ),
//                       placeholder: (context, url) =>
//                           const Center(child: CircularProgressIndicator()),
//                       errorWidget: (context, url, error) => const SizedBox(
//                           height: 200, child: Center(child: Icon(Icons.error))),
//                     );
//                   },
//                   separatorBuilder: (BuildContext context, int index) =>
//                       const Divider(),
//                 ),
//               ),
//               s10(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   SizedBox s10() {
//     return const SizedBox(
//       height: 10,
//     );
//   }
// }
