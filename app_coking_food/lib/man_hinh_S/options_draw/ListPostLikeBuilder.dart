import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../be/be-provider/be_provider.dart';
import '../detailPostInHome.dart';

class ListPostLike extends StatelessWidget {
  final List<Map<String, dynamic>> posts;
  final String title;
  final Icon icon;
  const ListPostLike(
      {super.key,
      required this.posts,
      required this.title,
      required this.icon});
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WishListPost>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: posts.isEmpty
          ? Container(
              width: double.infinity,
              height: double.infinity,
              padding: const EdgeInsets.all(10),
              child: Center(
                child: Stack(
                  children: [
                    Center(
                      child: icon,
                    ),
                    const Center(
                      child: Icon(
                        Icons.close,
                        size: 60,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : Container(
              width: double.infinity,
              height: double.infinity,
              padding: const EdgeInsets.all(10),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 0.6,
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
                                    imageUrlTopic: posts[index]['topicImage']!,
                                    imageAvatar: posts[index]['authorAvatar'],
                                    nickname: posts[index]['authorName']!,
                                    nameFood: posts[index]['name']!,
                                    ingredients: posts[index]['ingredients']!,
                                    steps: posts[index]['steps']!,
                                    imageStep: posts[index]['stepImages'],
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
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(10),
                                      topLeft: Radius.circular(10)),
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              placeholder: (context, url) => const Center(
                                  child: CircularProgressIndicator()),
                              errorWidget: (context, url, error) => Container(
                                  width: 183,
                                  height: 138,
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(10),
                                        topLeft: Radius.circular(10)),
                                  ),
                                  child:
                                      const Center(child: Icon(Icons.error))),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(
                                top: 10, left: 10, right: 10),
                            width: 183,
                            height: (183 / 0.7) / 2,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      posts[index]['name'],
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16),
                                      softWrap: true,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      posts[index]['intro'],
                                      style: const TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 13),
                                      softWrap: true,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        provider.ListFavPost.contains(
                                                posts[index])
                                            ? provider.removeList(
                                                provider.ListFavPost,
                                                posts[index])
                                            : provider.addList(
                                                provider.ListFavPost,
                                                posts[index]);
                                      },
                                      child: Icon(
                                        provider.listFavPostIds.contains(
                                                posts[index]['idTime'])
                                            ? Icons.favorite
                                            : Icons.favorite_outline,
                                        color: provider.listFavPostIds.contains(
                                                posts[index]['idTime'])
                                            ? Colors.red
                                            : Colors.grey,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        provider.ListSavePost.contains(
                                                posts[index])
                                            ? /*provider.removeList(provider.ListSavePost, posts[index])*/ null
                                            : provider.addList(
                                                provider.ListSavePost,
                                                posts[index]);
                                      },
                                      child: Icon(
                                        provider.listSavePostIds.contains(
                                                posts[index]['idTime'])
                                            ? Icons.bookmark
                                            : Icons.bookmark_border,
                                        color: provider.listSavePostIds
                                                .contains(
                                                    posts[index]['idTime'])
                                            ? Colors.yellow
                                            : Colors.grey,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        String appLink =
                                            'https://play.google.com/store/apps/details?id=com.sdcompany.luxury.app_coking_food';
                                        Share.share(
                                            'Check out this awesome app: $appLink');
                                      },
                                      child: Icon(
                                        Icons.share_rounded,
                                        color: Colors.black.withOpacity(0.7),
                                      ),
                                    )
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    CircleAvatar(
                                      radius: 15,
                                      backgroundColor: Colors.grey[300],
                                      backgroundImage:
                                          posts[index]['authorAvatar'] == null
                                              ? null
                                              : NetworkImage(
                                                  posts[index]['authorAvatar']),
                                    ),
                                    SizedBox(
                                      height: 30,
                                      width: 100,
                                      child: Center(
                                        child: Text(
                                          posts[index]['authorName'],
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              color: Color(0xff000000),
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14),
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
              ),
            ),
    );
  }
}
