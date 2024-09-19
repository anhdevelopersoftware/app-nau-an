import "package:flutter/material.dart";

import "../be/search/buildSearch.dart";

class allMonAn extends StatelessWidget {
  final Future<List<Map<String, dynamic>>> futurePosts;
  allMonAn({super.key, required this.futurePosts});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Tất cả chủ đề",
          style: TextStyle(
            color: Color(0xff000000),
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: [
            _buildChip(context,"Bữa sáng"),
            _buildChip(context,"Tráng miệng"),
            _buildChip(context,"Tiếp khách"),
            _buildChip(context,"Đồ chay"),
            _buildChip(context,"Canh"),
            _buildChip(context,"Đồ nướng"),
            _buildChip(context,"Đồ nướng"),
            _buildChip(context,"Bánh ngọt"),
            _buildChip(context,"Đồ uống"),
            _buildChip(context,"Nước lẩu"),
          ],
        ),
      ),
    );
  }

  GestureDetector _buildChip(BuildContext  context,String content) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FilteredPostsWidget(
                futurePosts: futurePosts,
                filterField: "theme", // hoặc "theme", "peopleCook"
                filterValue: content/*"15 - 30 phút"*/, // giá trị bạn muốn lọc
              ),
            ));
      },
      child: IntrinsicWidth(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          height: 30,
          decoration: BoxDecoration(
            color: const Color(0xffFFE5B3),
            borderRadius: BorderRadius.circular(38),
          ),
          child: Center(
            child: Text(
              content,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: Color(0xffD77400),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
