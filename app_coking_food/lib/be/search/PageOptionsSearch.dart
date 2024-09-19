import 'package:flutter/material.dart';

import 'buildSearch.dart';

// class PageOptionsSearch extends StatefulWidget {
//   final Future<List<Map<String, dynamic>>> futurePosts;
//
//   const PageOptionsSearch({super.key, required this.futurePosts});
//
//   @override
//   State<PageOptionsSearch> createState() => _PageOptionsSearchState();
// }
//
// class _PageOptionsSearchState extends State<PageOptionsSearch> {
//   final TextEditingController _searchController = TextEditingController();
//
//   List<String> themeFood = [
//     'Bữa sáng',
//     'Tráng miệng',
//     'Tiếp khách',
//     'Đồ chay',
//     'Canh',
//     'Đồ nướng',
//     'Bánh ngọt',
//     'Đồ uống',
//     'Nước lẩu',
//   ];
//
//   List<String> listTimeCook = ['15 - 30 phút', '30 - 45 phút', '1h - 1h30 p'];
//
//   List<String> peopleListCook = ['Dưới 2 người', '2 - 4 người', '4 - 6 người'];
//
//   String? selectedThemeFood;
//   String? selectedTimeCook;
//   String? selectedPeopleCook;
//
//   void _updateSearchField(String? value) {
//     setState(() {
//       _searchController.text = value ?? '';
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: const BoxDecoration(
//             gradient:
//                 LinearGradient(colors: [Color(0xff9e3825), Color(0xffa58237)])),
//         width: double.infinity,
//         height: double.infinity,
//         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   GestureDetector(
//                     onTap: () {
//                       Navigator.pop(context);
//                     },
//                     child: Container(
//                       width: 30,
//                       height: 30,
//                       decoration: const BoxDecoration(
//                         color: Colors.white,
//                         shape: BoxShape.circle,
//                       ),
//                       child: const Center(
//                           child: Icon(
//                         Icons.arrow_back_rounded,
//                         size: 20,
//                       )),
//                     ),
//                   ),
//                   Container(
//                     width: MediaQuery.of(context).size.width - 20 - 46 - 20,
//                     height: 46,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(12),
//                       gradient: const LinearGradient(
//                         colors: [Color(0xffFF6645), Color(0xffFFC554)],
//                         begin: Alignment.topLeft,
//                         end: Alignment.bottomRight,
//                       ),
//                     ),
//                     child: TextFormField(
//                       controller: _searchController,
//                       cursorColor: Colors.grey,
//                       decoration: InputDecoration(
//                         contentPadding: const EdgeInsets.symmetric(
//                           vertical: 5,
//                           horizontal: 10,
//                         ),
//                         border: InputBorder.none,
//                         enabledBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10),
//                           borderSide: const BorderSide(
//                             color: Colors.white,
//                           ),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10),
//                           borderSide: const BorderSide(
//                             color: Color(0xffD2D2D2),
//                           ),
//                         ),
//                         filled: true,
//                         fillColor: Colors.white,
//                         hintText: 'Tìm kiếm bài viết',
//                         hintStyle: const TextStyle(
//                           color: Color(0xffD2D2D2),
//                           fontSize: 16,
//                           fontWeight: FontWeight.w300,
//                         ),
//                         suffixIcon: Padding(
//                           padding: const EdgeInsets.all(10.0),
//                           child: GestureDetector(
//                             onTap: () {
//                               Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) => FilteredPostsWidget(
//                                       futurePosts: widget.futurePosts,
//                                       filterField:
//                                           'intro', // hoặc 'theme', 'peopleCook'
//                                       filterValue:
//                                           '15 - 30 phút', // giá trị bạn muốn lọc
//                                     ),
//                                   ));
//                             },
//                             child: const Icon(
//                               Icons.search,
//                               color: Color(0xffFF6645),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 20),
//               buildDropdownButtonFormField(
//                   selectedThemeFood, themeFood, 'Chọn mục'),
//               const SizedBox(height: 10),
//               buildDropdownButtonFormField(
//                   selectedTimeCook, listTimeCook, 'Thời gian nấu'),
//               const SizedBox(height: 10),
//               buildDropdownButtonFormField(
//                   selectedPeopleCook, peopleListCook, 'Số người ăn'),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   DropdownButtonFormField<String> buildDropdownButtonFormField(
//       String? selectedValue, List<String> contents, String hint) {
//     return DropdownButtonFormField<String>(
//       hint: Text(
//         hint,
//         style: const TextStyle(
//           color: Color(0xffD2D2D2),
//           fontWeight: FontWeight.w300,
//           fontSize: 12,
//         ),
//       ),
//       value: selectedValue,
//       items: contents.map((String item) {
//         return DropdownMenuItem<String>(
//           value: item,
//           child: Text(item),
//         );
//       }).toList(),
//       onChanged: (newValue) {
//         setState(() {
//           selectedValue = newValue;
//           _updateSearchField(newValue);
//         });
//       },
//       decoration: const InputDecoration(
//         focusedBorder: UnderlineInputBorder(
//           borderSide: BorderSide(color: Color(0xffD2D2D2)),
//         ),
//         enabledBorder: UnderlineInputBorder(
//           borderSide: BorderSide(color: Color(0xffD2D2D2)),
//         ),
//       ),
//     );
//   }
// }

class CustomSearchDelegate extends SearchDelegate {
  final Future<List<Map<String, dynamic>>> futurePosts;

  List<String> searchTerms = [
    'Dưới 2 người',
    '2 - 4 người',
    '4 - 6 người',
    '6-10 người',
    'Trên 10 người',
    '15 - 30 phút',
    '30 - 45 phút',
    '1h - 1h30 p',
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

  CustomSearchDelegate(
    this.futurePosts, {
    super.searchFieldLabel,
    super.searchFieldStyle,
    super.searchFieldDecorationTheme,
    super.keyboardType,
    super.textInputAction,
  });
  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xffFF6645),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withOpacity(0.5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: const Icon(Icons.clear))
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    List<String> matchQuery = [];
    for (var fruit in searchTerms) {
      if (fruit.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(fruit);
      }
    }
    return ListView.builder(
        itemCount: matchQuery.length,
        itemBuilder: (context, index) {
          var result = matchQuery[index];
          return ListTile(
            title: Text(result),
          );
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> matchQuery = [];
    for (var fruit in searchTerms) {
      if (fruit.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(fruit);
      }
    }
    return Container(
      decoration: const BoxDecoration(
          gradient:
              LinearGradient(colors: [Color(0xff9e3825), Color(0xffa58237)])),
      child: ListView.builder(
          itemCount: matchQuery.length,
          itemBuilder: (context, index) {
            var result = matchQuery[index];
            return ListTile(
              title: InkWell(
                  onTap: () {
                    _navigateToPage(context, result);
                  },
                  child: Text(
                    result,
                    style: const TextStyle(color: Colors.black),
                  )),
            );
          }),
    );
  }

  Future<void> _navigateToPage(BuildContext context, String result) async {
    switch (result) {
      case 'Dưới 2 người':
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FilteredPostsWidget(
                futurePosts: futurePosts,
                filterField: 'peopleCook',
                filterValue: 'Dưới 2 người' /*'15 - 30 phút'*/,
              ),
            ));

        break;
      case '2 - 4 người':
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FilteredPostsWidget(
                futurePosts: futurePosts,
                filterField: 'peopleCook',
                filterValue: '2-4 người' /*'15 - 30 phút'*/,
              ),
            ));

        break;
      case '4 - 6 người':
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FilteredPostsWidget(
                futurePosts: futurePosts,
                filterField: 'peopleCook',
                filterValue: '4-6 người' /*'15 - 30 phút'*/,
              ),
            ));

        break;
      case '6-10 người':
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FilteredPostsWidget(
                futurePosts: futurePosts,
                filterField: 'peopleCook',
                filterValue: '6-10 người' /*'15 - 30 phút'*/,
              ),
            ));

        break;
      case 'Trên 10 người':
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FilteredPostsWidget(
                futurePosts: futurePosts,
                filterField: 'peopleCook',
                filterValue: 'Trên 10 người' /*'15 - 30 phút'*/,
              ),
            ));

        break;
      case '15 - 30 phút':
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FilteredPostsWidget(
                futurePosts: futurePosts,
                filterField: 'timeCook',
                filterValue: '15 - 30 phút' /*'15 - 30 phút'*/,
              ),
            ));

        break;
      case '30 - 45 phút':
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FilteredPostsWidget(
                futurePosts: futurePosts,
                filterField: 'timeCook',
                filterValue: '30 - 45 phút' /*'15 - 30 phút'*/,
              ),
            ));
        break;
      case '1h - 1h30 p':
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FilteredPostsWidget(
                futurePosts: futurePosts,
                filterField: 'timeCook',
                filterValue: '1h - 1h30 p' /*'15 - 30 phút'*/,
              ),
            ));
        break;
      case 'Bữa sáng':
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FilteredPostsWidget(
                futurePosts: futurePosts,
                filterField: 'theme',
                filterValue: 'Bữa sáng' /*'15 - 30 phút'*/,
              ),
            ));
        break;
      case 'Tráng miệng':
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FilteredPostsWidget(
                futurePosts: futurePosts,
                filterField: 'theme',
                filterValue: 'Tráng miệng' /*'15 - 30 phút'*/,
              ),
            ));
        break;
      case 'Tiếp khách':
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FilteredPostsWidget(
                futurePosts: futurePosts,
                filterField: 'theme',
                filterValue: 'Tiếp khách' /*'15 - 30 phút'*/,
              ),
            ));
        break;
      case 'Đồ chay':
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FilteredPostsWidget(
                futurePosts: futurePosts,
                filterField: 'theme',
                filterValue: 'Đồ chay' /*'15 - 30 phút'*/,
              ),
            ));
        break;
      case 'Canh':
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FilteredPostsWidget(
                futurePosts: futurePosts,
                filterField: 'theme',
                filterValue: 'Canh' /*'15 - 30 phút'*/,
              ),
            ));
        break;
      case 'Đồ nướng':
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FilteredPostsWidget(
                futurePosts: futurePosts,
                filterField: 'theme',
                filterValue: 'Đồ nướng' /*'15 - 30 phút'*/,
              ),
            ));
        break;
      case 'Bánh ngọt':
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FilteredPostsWidget(
                futurePosts: futurePosts,
                filterField: 'theme',
                filterValue: 'Bánh ngọt' /*'15 - 30 phút'*/,
              ),
            ));
        break;
      case 'Đồ uống':
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FilteredPostsWidget(
                futurePosts: futurePosts,
                filterField: 'theme',
                filterValue: 'Đồ uống' /*'15 - 30 phút'*/,
              ),
            ));
        break;
      case 'Nước lẩu':
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FilteredPostsWidget(
                futurePosts: futurePosts,
                filterField: 'theme',
                filterValue: 'Nước lẩu' /*'15 - 30 phút'*/,
              ),
            ));
        break;

      default:
        break;
    }
  }
}
