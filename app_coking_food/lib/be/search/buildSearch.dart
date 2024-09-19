import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
// import 'package:provider/provider.dart';

import '../../man_hinh_S/detailPostInHome.dart';
// import '../be-provider/be_provider.dart';


// Navigator.push(
// context,
// MaterialPageRoute(
// builder: (context) => FilteredPostsWidget(
// futurePosts: searchPost,
// filterField:
// 'intro', // hoặc 'theme', 'peopleCook'
// filterValue:
// '15 - 30 phút', // giá trị bạn muốn lọc
// ),
// ));
class FilteredPostsWidget extends StatelessWidget {
  final Future<List<Map<String, dynamic>>> futurePosts;
  final String? filterField;
  final String? filterValue;

  const FilteredPostsWidget({
    Key? key,
    required this.futurePosts,
    this.filterField,
    this.filterValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange.withOpacity(0.2),
        title: Text(filterValue ?? 'Filtered Posts'),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.all(20),
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: futurePosts,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Text('No posts available');
            } else {
              List<Map<String, dynamic>> posts = snapshot.data!;

              PostFilter postFilter = PostFilter(posts);
              List<Map<String, dynamic>> filteredPosts = postFilter.filter(
                field: filterField,
                value: filterValue,
              );

              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 0.65,
                  crossAxisCount: 2,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                ),
                itemCount: filteredPosts.length,
                itemBuilder: (context, index) {
                  final item = filteredPosts[index];
                  return SizedBox(
                    width: 190,
                    height: (190 / 0.65),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailPost(
                              imageUrlTopic: item['topicImage'] ?? '',
                              imageAvatar: item['authorAvatar'] ?? '',
                              nickname: item['authorName'] ?? '',
                              nameFood: item['name'] ?? '',
                              ingredients: item['ingredients'] ?? '',
                              steps: item['steps'] ?? '',
                              imageStep: item['stepImages'] ?? '',
                              item: item,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.9),
                              spreadRadius: 0.2,
                              blurRadius: 1,
                              offset: const Offset(0, 3),
                            ),
                          ],
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(10),
                            topLeft: Radius.circular(10),
                          ),
                        ),
                        child: Column(
                          children: [
                            Container(
                              width: 183,
                              height: (183 / 0.7) / 2,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(10),
                                  topLeft: Radius.circular(10),
                                ),
                              ),
                              child: CachedNetworkImage(
                                imageUrl: item['topicImage'] ?? '',
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.only(
                                          topRight: Radius.circular(10),
                                          topLeft: Radius.circular(10),
                                        ),
                                        image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                placeholder: (context, url) =>
                                const Center(child: CircularProgressIndicator()),
                                errorWidget: (context, url, error) => Container(
                                  width: 183,
                                  height: 138,
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(10),
                                      topLeft: Radius.circular(10),
                                    ),
                                  ),
                                  child: const Center(child: Icon(Icons.error)),
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                              width: 183,
                              height: (183 / 0.9) / 2,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 120,
                                        height: 30,
                                        child: Text(
                                          item['name'] ?? '',
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
                                        width: 140,
                                        height: 30,
                                        child: Text(
                                          item['intro'] ?? '',
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
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      CircleAvatar(
                                        radius: 15,
                                        backgroundColor: Colors.grey[300],
                                        backgroundImage: item['authorAvatar'] != null
                                            ? NetworkImage(item['authorAvatar'])
                                            : null,
                                      ),
                                      SizedBox(
                                        width: 100,
                                        height: 30,
                                        child: Center(
                                          child: Text(
                                            item['authorName'] ?? '',
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              color: Color(0xff000000),
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14,
                                            ),
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
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}

class PostFilter {
  final List<Map<String, dynamic>> posts;

  PostFilter(this.posts);

  List<Map<String, dynamic>> filter({
    String? field,
    String? value,
  }) {
    return posts.where((post) {
      bool matches = true;

      if (field != null && value != null && value.isNotEmpty) {
        matches = matches && post.containsKey(field) && post[field] == value;
      }

      return matches;
    }).toList();
  }
}