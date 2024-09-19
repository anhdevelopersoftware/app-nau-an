import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class SharePost extends StatefulWidget {
  @override
  State<SharePost> createState() => _SharePostState();
}

class _SharePostState extends State<SharePost> {
  bool statusButtonSave = true;
  bool statusButtonRelease = true;
  bool isSaving = false;
  bool isPublishing = false;

  List<String> themeFood = [
    'Bữa sáng',
    'Tráng miệng',
    'Tiếp khách',
    'Đồ chay',
    'Canh',
    'Đồ nướng',
    'Bánh ngọt',
    'Đồ uống',
    'Nước lẩu',
  ];
  String? selectedValueThemeFood;
  TextEditingController nameFood = TextEditingController();

  TextEditingController introShort = TextEditingController();
  String? timeCook;
  List<String> listTimeCook = ['15 - 30 phút', '30 - 45 phút', '1h - 1h30 p'];
  List<String> peopleListTimeCook = [
    'Dưới 2 người',
    '2-4 người',
    '4-6 người',
    '6-10 người',
    'Trên 10 người'
  ];
  String? peopleCook;
  List<Ingredient> ingredients = [
    Ingredient(
        nameController: TextEditingController(),
        quantityController: TextEditingController(),
        unit: TextEditingController())
  ];
  List<TextEditingController> steps = [TextEditingController()];
  XFile? topicImage;
  List<XFile> stepImages = [];
  List<List<XFile>> stepImagesList = [[]];
  @override
  void dispose() {
    nameFood.dispose();
    introShort.dispose();
    for (var ingredient in ingredients) {
      ingredient.nameController.dispose();
      ingredient.quantityController.dispose();
    }
    for (var step in steps) {
      step.dispose();
    }
    super.dispose();
  }

  void addIngredient() {
    setState(() {
      ingredients.add(Ingredient(
          nameController: TextEditingController(),
          quantityController: TextEditingController(),
          unit: TextEditingController()));
    });
  }

  void removeIngredient(int index) {
    setState(() {
      if (ingredients.length > 1) {
        ingredients.removeAt(index);
      }
    });
  }

  void addStep() {
    setState(() {
      steps.add(TextEditingController());
      stepImagesList.add([]);
    });
  }

  void removeStep(int index) {
    setState(() {
      if (steps.length > 1) {
        steps.removeAt(index);
        stepImagesList.removeAt(index);
      }
    });
  }

  Future<void> pickImage(ImageSource source, bool isTopicImage,
      [int? stepIndex]) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        if (isTopicImage) {
          topicImage = pickedFile;
        } else if (stepIndex != null) {
          if (stepImagesList.length <= stepIndex) {
            stepImagesList.add([]);
          }
          stepImagesList[stepIndex].add(pickedFile);
        }
      });
    }
  }

// Hàm tải lên ảnh lên Firebase Storage
  Future<String> uploadImageToFirebase(XFile image, String path) async {
    try {
      final ref = FirebaseStorage.instance.ref().child(path);
      await ref.putFile(File(image.path));
      return await ref.getDownloadURL();
    } catch (e) {
      showSnackBarTop('Error uploading image: $e');
      throw e;
    }
  }

// Hàm đăng bài viết lên Firestore
  String? idTime;
  Future<void> post(bool isPublic) async {
    try {
      setState(() {
        if (isPublic) {
          isPublishing = true;
        } else {
          isSaving = true;
        }
      });

      String? topicImageUrl;
      if (topicImage != null) {
        topicImageUrl = await uploadImageToFirebase(
          topicImage!,
          'data_SharePost/${FirebaseAuth.instance.currentUser!.uid}/topic_images/${topicImage!.name}',
        );
      }

      List<String> stepImageUrls = [];
      for (var stepImageList in stepImagesList) {
        for (var stepImage in stepImageList) {
          final url = await uploadImageToFirebase(
            stepImage,
            'data_SharePost/${FirebaseAuth.instance.currentUser!.uid}/step_images/${stepImage.name}',
          );
          stepImageUrls.add(url);
        }
      }

      final postCollection = isPublic ? 'public_posts' : 'private_posts';
      final postRef =
          FirebaseFirestore.instance.collection(postCollection).doc();

      await postRef.set({
        'theme': selectedValueThemeFood,
        'name': nameFood.text,
        'intro': introShort.text,
        'timeCook': timeCook,
        'peopleCook': peopleCook,
        'ingredients': ingredients
            .map((e) => {
                  'name': e.nameController.text,
                  'quantity': e.quantityController.text,
                  'unit': e.unit.text,
                })
            .toList(),
        'steps': steps.map((e) => e.text).toList(),
        'stepImages': stepImageUrls,
        'topicImage': topicImageUrl,
        'isPublic': isPublic,
        'authorId': FirebaseAuth.instance.currentUser!.uid,
        'idTime': idTime,
      });

      showTopSnackBar(
        Overlay.of(context),
        const CustomSnackBar.success(
          message: 'Đăng bài thành công!',
        ),
      );

      if (isPublic) {
        try {
          await deletePrivatePost(postRef.id);
        } catch (e) {
          ////.*('Error deleting private post: $e');
        }
      }
    } catch (e) {
      ////.*('Error posting: $e');
    } finally {
      setState(() {
        if (isPublic) {
          isPublishing = false;
        } else {
          isSaving = false;
        }
      });
    }
  }

  Future<void> deletePrivatePost(String postId) async {
    try {
      final privatePostRef =
          FirebaseFirestore.instance.collection('private_posts').doc(postId);
      await privatePostRef.delete();
      // //.*('Private post deleted successfully.');
    } catch (e) {
      ////.*('Error deleting private post: $e');
      throw e;
    }
  }

  showSnackBarTop(String text) {
    showTopSnackBar(
      Overlay.of(context),
      CustomSnackBar.error(
        message: text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String id =
        "${now.second}-${now.minute}-${now.hour}-${now.day}-${now.month}-${now.year}";
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Thêm bài viết',
          style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: Color(0xff000000)),
        ),
        actions: [
          isPublishing
              ? Container(
                  margin: const EdgeInsets.only(right: 10),
                  height: 32,
                  width: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: const Center(
                      child: CircularProgressIndicator(
                    strokeWidth: 1.5,
                  )))
              : GestureDetector(
                  onTap: () async {
                    setState(() {
                      isPublishing = true;
                      isSaving = false;
                      idTime = id;
                    });
                    statusButtonRelease ? null : await post(true);
                    Navigator.pop(context);
                  },
                  child: Stack(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(right: 10),
                        height: 32,
                        width: 80,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(9),
                            gradient: const LinearGradient(colors: [
                              Color(0xff45BCFF),
                              Color(0xff547AFF),
                            ])),
                        child: const Center(
                          child: Text(
                            "Xuất bản",
                            style: TextStyle(
                                color: Color(0xffFFFFFF),
                                fontWeight: FontWeight.w500,
                                fontSize: 14),
                          ),
                        ),
                      ),
                      statusButtonRelease
                          ? Container(
                              height: 32,
                              width: 80,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(9),
                                  color: Colors.white.withOpacity(0.5)),
                            )
                          : Container(
                              height: 32,
                              width: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(9),
                              ),
                            )
                    ],
                  ),
                ),
          isSaving
              ? Container(
                  margin: const EdgeInsets.only(right: 10),
                  height: 32,
                  width: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: const Center(
                      child: CircularProgressIndicator(
                    strokeWidth: 1.5,
                  )))
              : GestureDetector(
                  onTap: () async {
                    setState(() {
                      isSaving = true;
                      isPublishing = false;
                    });
                    if (!statusButtonSave) {
                      await post(false);
                      setState(() {
                        statusButtonRelease = false;
                        statusButtonSave = true;
                      });
                    }
                  },
                  child: Stack(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(right: 10),
                        height: 32,
                        width: 80,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(9),
                            gradient: const LinearGradient(colors: [
                              Color(0xffFFC554),
                              Color(0xffFF6645),
                            ])),
                        child: const Center(
                          child: Text(
                            "Lưu lại",
                            style: TextStyle(
                                color: Color(0xffFFFFFF),
                                fontWeight: FontWeight.w500,
                                fontSize: 14),
                          ),
                        ),
                      ),
                      statusButtonSave
                          ? Container(
                              height: 32,
                              width: 80,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(9),
                                  color: Colors.white.withOpacity(0.5)),
                            )
                          : Container(
                              height: 32,
                              width: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(9),
                              ),
                            )
                    ],
                  ),
                ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 40,
                child: Text(
                  'Giới thiệu chung',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff00B1C9)),
                ),
              ),
              const SizedBox(
                height: 40,
                child: Text(
                  'Ảnh chủ đề',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                      color: Color(0xff000000)),
                ),
              ),
              GestureDetector(
                onTap: () {
                  pickImage(ImageSource.gallery, true);
                  setState(() {
                    statusButtonSave = false;
                  });
                },
                child: Container(
                  width: double.infinity,
                  height: 300,
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 20,
                          offset: const Offset(0, 3),
                        )
                      ],
                      borderRadius: BorderRadius.circular(10),
                      color: const Color(0xffF6F6F6)),
                  child: topicImage != null
                      ? Image.file(File(topicImage!.path), fit: BoxFit.cover)
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 70,
                              width: 70,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.grey,
                                image: const DecorationImage(
                                    image: AssetImage(
                                        'assets/image_app/image_data!_post.png')),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Text(
                              'Chọn ảnh',
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  color: Color(0xff909090)),
                            )
                          ],
                        ),
                ),
              ),
              textStart('Chủ đề'),
              buildDropdownButtonFormField(
                selectedValueThemeFood,
                themeFood,
                (newValue) {
                  setState(() {
                    selectedValueThemeFood = newValue;
                  });
                },
              ),
              textStart('Tên món ăn'),
              buildTextFromFiled1(nameFood),
              textStart('Giới thiệu ngắn'),
              buildTextFromFiled1(introShort),
              textStart('Thời gian nấu '),
              buildDropdownButtonFormField(
                timeCook,
                listTimeCook,
                (newValue) {
                  setState(() {
                    timeCook = newValue;
                  });
                },
              ),
              textStart('Khẩu phần người ăn '),
              buildDropdownButtonFormField(
                peopleCook,
                peopleListTimeCook,
                (newValue) {
                  setState(() {
                    peopleCook = newValue;
                  });
                },
              ),
              const SizedBox(
                height: 10,
              ),
              const SizedBox(
                height: 40,
                child: Text(
                  'Nguyên liệu',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff00B1C9)),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: ingredients.length,
                itemBuilder: (context, index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 25,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Nguyên liệu ${index + 1}',
                              style: const TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w500),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close, color: Colors.red),
                              onPressed: () {
                                removeIngredient(index);
                              },
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: ingredients[index].nameController,
                              decoration: const InputDecoration(
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xffD2D2D2)),
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xffD2D2D2)),
                                  ),
                                  hintText: 'Tên nguyên liệu',
                                  hintStyle: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w300,
                                      color: Color(0xffD2D2D2))),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          SizedBox(
                            width: 100,
                            child: TextFormField(
                              keyboardAppearance: Brightness.dark,
                              controller: ingredients[index].quantityController,
                              decoration: const InputDecoration(
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xffD2D2D2)),
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xffD2D2D2)),
                                  ),
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 10),
                                  hintText: 'Số lượng',
                                  hintStyle: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w300,
                                      color: Color(0xffD2D2D2))),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          SizedBox(
                            width: 70,
                            child: TextFormField(
                              keyboardAppearance: Brightness.dark,
                              controller: ingredients[index].unit,
                              decoration: const InputDecoration(
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xffD2D2D2)),
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xffD2D2D2)),
                                  ),
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 10),
                                  hintText: 'Đơn vị',
                                  hintStyle: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w300,
                                      color: Color(0xffD2D2D2))),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 30),
                    width: 132,
                    height: 40,
                    decoration: BoxDecoration(
                        color: const Color(0xff00DA8B),
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                      child: TextButton(
                        onPressed: addIngredient,
                        child: const Text(
                          '+ Thêm lựa chọn',
                          style: TextStyle(
                              color: Color(0xffFFFFFF),
                              fontWeight: FontWeight.w500,
                              fontSize: 12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 40,
                child: Text(
                  'Cách thực hiện',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff00B1C9)),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ...steps.map((stepController) {
                final index = steps.indexOf(stepController);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Bước ${index + 1}',
                          style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w500),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.red),
                          onPressed: () => removeStep(index),
                        ),
                      ],
                    ),
                    Container(
                      height: 40,
                      padding: const EdgeInsets.only(left: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: TextField(
                        controller: stepController,
                        decoration: const InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xffD2D2D2)),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xffD2D2D2)),
                          ),
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 12, horizontal: 5),
                          hintText: 'Nhập mô tả bước',
                          hintStyle: TextStyle(
                              color: Color(0xff909090),
                              fontWeight: FontWeight.w400,
                              fontSize: 14),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const SizedBox(height: 5),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          ...stepImagesList[index].map((stepImage) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Image.file(
                                File(stepImage.path),
                                height: 100,
                                width: 100,
                                fit: BoxFit.cover,
                              ),
                            );
                          }),
                          GestureDetector(
                            onTap: () =>
                                pickImage(ImageSource.gallery, false, index),
                            child: Container(
                              height: 80,
                              width: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: const Color(0xffF6F6F6),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 45,
                                    width: 45,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      image: const DecorationImage(
                                          image: AssetImage(
                                              'assets/image_app/image_data!_post.png')),
                                    ),
                                  ),
                                  const Text(
                                    'Chọn ảnh',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14,
                                        color: Color(0xff909090)),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                );
              }),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 30),
                    width: 132,
                    height: 40,
                    decoration: BoxDecoration(
                        color: const Color(0xff00DA8B),
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                      child: TextButton(
                        onPressed: addStep,
                        child: const Text(
                          '+ Thêm lựa chọn',
                          style: TextStyle(
                              color: Color(0xffFFFFFF),
                              fontWeight: FontWeight.w500,
                              fontSize: 12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
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

  DropdownButtonFormField<String> buildDropdownButtonFormField(
      String? selectedValue,
      List<String> contents,
      ValueChanged<String?> onChanged) {
    return DropdownButtonFormField<String>(
      hint: const Text(
        'Chọn thông tin',
        style: TextStyle(
            color: Color(0xffD2D2D2),
            fontWeight: FontWeight.w300,
            fontSize: 16),
      ),
      value: selectedValue,
      items: contents.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: (newValue) {
        onChanged(newValue);
      },
      decoration: const InputDecoration(
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xffD2D2D2)),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xffD2D2D2)),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      ),
    );
  }

  SizedBox textStart(String content) {
    return SizedBox(
      height: 40,
      child: Row(
        children: [
          Text(
            content,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
          const Text(
            ' *',
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(0xffFF3535)),
          )
        ],
      ),
    );
  }
}

class Ingredient {
  TextEditingController nameController;
  TextEditingController quantityController;
  TextEditingController unit;

  Ingredient(
      {required this.nameController,
      required this.quantityController,
      required this.unit});
}
