import 'package:flutter/material.dart';

class ChinhSachAndBaoMat extends StatelessWidget {
  const ChinhSachAndBaoMat({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              height: 100,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xffFF6645), Color(0xffFFC554)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      )),
                  const Text(
                    'Điều khoản và chính sách',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                  const SizedBox(
                    height: 40,
                    width: 40,
                  )
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(15),
                      topLeft: Radius.circular(15))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  t1('''Chính sách Sử dụng'''),
                  t2('''1. Điều khoản sử dụng:'''),
                  t('''Người dùng phải tuân thủ các điều khoản sử dụng được quy định trong ứng dụng Dạy Nấu Ăn. Việc sử dụng ứng dụng được coi là đồng ý với các điều khoản và điều kiện này.'''),
                  t2('''2. Nội dung và bản quyền:'''),
                  t('''Các tài liệu, nội dung giảng dạy, hình ảnh, và video trong ứng dụng Dạy Nấu Ăn thuộc bản quyền của nhà phát triển. Người dùng không có quyền sao chép, phân phối, hoặc sử dụng lại các tài liệu này mà không có sự cho phép bằng văn bản từ nhà phát triển.'''),
                  t2('''3. Trách nhiệm của người dùng:'''),
                  t('''Người dùng phải chịu trách nhiệm về hành vi sử dụng và đảm bảo không gây hại đến hệ thống, dịch vụ, hoặc người dùng khác trong quá trình sử dụng ứng dụng.'''),
                  t2('''4. Phản hồi và hỗ trợ:'''),
                  t('''Ứng dụng Dạy Nấu Ăn luôn chào đón phản hồi từ người dùng để cải thiện dịch vụ và giải quyết các vấn đề phát sinh. Người dùng có thể liên hệ với nhà phát triển qua các kênh hỗ trợ được cung cấp trong ứng dụng.'''),
                  t2('''5. Thay đổi chính sách:'''),
                  t('''Chính sách bảo mật và chính sách sử dụng có thể được cập nhật hoặc điều chỉnh theo thời gian để phù hợp với các yêu cầu pháp lý hoặc thay đổi trong hoạt động của ứng dụng. Mọi thay đổi sẽ được thông báo và có hiệu lực sau khi được công bố.'''),
                  const Divider(),
                  t1('''Chính Sách Bảo Mật'''),
                  t2('''1. Thông Tin Thu Thập'''),
                  t('''Ứng dụng Dạy Nấu Ăn thu thập thông tin cá nhân từ người dùng như tên, địa chỉ email, và các thông tin liên quan đến việc sử dụng ứng dụng (như thời gian truy cập, hoạt động sử dụng).'''),
                  t2('''2. Sử Dụng Thông Tin'''),
                  t('''Thông tin cá nhân được sử dụng để cung cấp dịch vụ cho người dùng, bao gồm việc cung cấp nội dung giảng dạy, quản lý tài khoản người dùng, và cải thiện trải nghiệm người dùng.'''),
                  t2('''3. Bảo Mật Thông Tin'''),
                  t('''Ứng dụng cam kết bảo vệ thông tin cá nhân của người dùng bằng cách triển khai các biện pháp bảo mật vật lý và kỹ thuật để ngăn chặn truy cập trái phép, sử dụng sai mục đích, hoặc tiết lộ thông tin cá nhân.'''),
                  t2('''4. Chia Sẻ Thông Tin'''),
                  t('''Thông tin cá nhân của người dùng sẽ không được chia sẻ, bán hoặc tiết lộ cho bên thứ ba nếu không có sự đồng ý của người dùng, trừ khi cần thiết để tuân thủ các quy định pháp luật hiện hành hoặc khi có yêu cầu từ cơ quan chức năng có thẩm quyền.'''),
                  t2('''5. Điều chỉnh thông tin:'''),
                  t('''Người dùng có quyền truy cập, sửa đổi, hoặc xóa thông tin cá nhân của mình từ ứng dụng. Để làm điều này, người dùng có thể truy cập vào phần cài đặt hoặc liên hệ với nhà phát triển ứng dụng để được hỗ trợ.'''),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Text t1(String title) {
    return Text(
      title,
      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
    );
  }

  Text t2(String title) {
    return Text(
      title,
      style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 18),
    );
  }

  Text t(String content) {
    return Text(
      content,
      style: const TextStyle(fontWeight: FontWeight.w300, fontSize: 16),
    );
  }
}
