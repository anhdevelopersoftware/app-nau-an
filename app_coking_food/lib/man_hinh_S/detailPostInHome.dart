import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../be/be-provider/be_provider.dart';

class DetailPost extends StatelessWidget {
  final String imageUrlTopic;
  final String? imageAvatar;
  final String nickname;
  final String nameFood;
  final List<dynamic> ingredients;
  final List<dynamic> steps;
  final List<dynamic> imageStep;
  final Map<String, dynamic> item;
  const DetailPost(
      {super.key,
      required this.imageUrlTopic,
      required this.imageAvatar,
      required this.nickname,
      required this.nameFood,
      required this.ingredients,
      required this.steps,
      required this.imageStep,
      required this.item});
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WishListPost>(context);
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding:
            const EdgeInsets.only(left: 15, right: 15, bottom: 10, top: 30),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.black,
                      )),
                  const Text(
                    'Chi tiết bài viết',
                    style: TextStyle(
                        color: Color(0xff000000),
                        fontSize: 18,
                        fontWeight: FontWeight.w500),
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          provider.ListFavPost.contains(item)
                              ? provider.removeList(provider.ListFavPost, item)
                              : provider.addList(provider.ListFavPost, item);
                        },
                        child: Icon(
                          provider.listFavPostIds.contains(item['idTime'])
                              ? Icons.favorite
                              : Icons.favorite_outline,
                          color:
                              provider.listFavPostIds.contains(item['idTime'])
                                  ? Colors.red
                                  : Colors.grey,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          provider.ListSavePost.contains(item)
                              ? /*provider.removeList(provider.ListSavePost, item)*/ null
                              : provider.addList(provider.ListSavePost, item);
                        },
                        child: Icon(
                          provider.listSavePostIds.contains(item['idTime'])
                              ? Icons.bookmark
                              : Icons.bookmark_border,
                          color:
                              provider.listSavePostIds.contains(item['idTime'])
                                  ? Colors.yellow
                                  : Colors.grey,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          String appLink =
                              'https://play.google.com/store/apps/details?id=com.sdcompany.luxury.app_coking_food';
                          Share.share('Check out this awesome app: $appLink');
                        },
                        child: Icon(
                          Icons.share_rounded,
                          color: Colors.black.withOpacity(0.7),
                        ),
                      )
                    ],
                  ),
                ],
              ),
              s10(),
              Container(
                width: double.infinity,
                height: 300,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(10)),
                child: CachedNetworkImage(
                  imageUrl: imageUrlTopic,
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      CircleAvatar(
                        radius: 15,
                        backgroundColor: Colors.grey[300],
                        backgroundImage: null == imageAvatar
                            ? null
                            : NetworkImage(imageAvatar!),
                        child: imageAvatar == null
                            ? null
                            : const Icon(Icons.person,
                                color: Colors.grey, size: 20),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                        height: 30,
                        child: Center(
                          child: Text(
                            nickname,
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
                  const Text(
                    'Tác giả',
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Color(0xffD2D2D2)),
                  )
                ],
              ),
              s10(),
              Text(
                nameFood,
                style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                    color: Colors.black),
              ),
              s10(),
              const Text(
                'Nguyên liệu',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff00B1C9)),
              ),
              s10(),
              Container(
                padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color(0xffF6F6F6),
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: ingredients.length,
                  itemBuilder: (context, index) {
                    final ingredient = ingredients[index];
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          ingredient['name'],
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          '${ingredient['quantity']}  ${ingredient['unit']}',
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              s10(),
              const Text(
                'Cách thực hiện',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff00B1C9)),
              ),
              s10(),
              Container(
                padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                width: double.infinity,
                decoration: BoxDecoration(
                    color: const Color(0xffF6F6F6),
                    borderRadius: BorderRadius.circular(10)),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: steps.length,
                  itemBuilder: (context, index) {
                    final step = steps[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Bước ${index + 1} ',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        s10(),
                        Text(
                          '$step',
                          style: const TextStyle(
                              fontWeight: FontWeight.w300, fontSize: 14),
                        ),
                        s10(),
                      ],
                    );
                  },
                ),
              ),
              s10(),
              const Text(
                'Hình ảnh mô tả',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff00B1C9)),
              ),
              s10(),
              Container(
                padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                width: double.infinity,
                decoration: BoxDecoration(
                    color: const Color(0xffF6F6F6),
                    borderRadius: BorderRadius.circular(10)),
                child: imageStep == null || imageStep.isEmpty
                    ? const Center(
                        child: Text(
                          'Không có hình ảnh mô tả',
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    : ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: imageStep.length,
                        itemBuilder: (context, index) {
                          final imageUrl = imageStep[index];
                          return CachedNetworkImage(
                            imageUrl: imageUrl,
                            imageBuilder: (context, imageProvider) => Container(
                              height: 200,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) =>
                                const SizedBox(
                                    height: 200,
                                    child: Center(child: Icon(Icons.error))),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) =>
                            const Divider(),
                      ),
              ),
              s10(),
            ],
          ),
        ),
      ),
    );
  }

  SizedBox s10() {
    return const SizedBox(
      height: 10,
    );
  }
}
