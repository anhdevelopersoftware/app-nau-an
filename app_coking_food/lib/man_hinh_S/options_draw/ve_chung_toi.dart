import 'package:flutter/material.dart';

class InfoMy extends StatelessWidget {
  const InfoMy({super.key});

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
                    'Về chúng tôi',
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
                  t1('Chúng tôi'),
                  t('''Chào mừng bạn đến với ứng dụng Dạy Nấu Ăn! Chúng tôi cam kết mang đến cho bạn những trải nghiệm học nấu ăn đầy thú vị và bổ ích. Với sứ mệnh chia sẻ kiến thức ẩm thực và tạo cộng đồng yêu nấu ăn, chúng tôi tự hào giới thiệu đến bạn những tính năng và nội dung đa dạng:'''),
                  t2('''Nội dung phong phú'''),
                  t('''Ứng dụng Dạy Nấu Ăn cung cấp hàng ngàn công thức nấu ăn từ khắp nơi trên thế giới, từ các món ăn gia đình đơn giản đến những món đặc sản phức tạp. Bạn có thể tự đăng bài, chia sẻ công thức của mình và khám phá những món ăn mới mỗi ngày. Chúng tôi luôn cập nhật và bổ sung nội dung mới để bạn có thể thử nghiệm và trải nghiệm.'''),
                  t2('''Cộng đồng yêu nấu ăn'''),
                  t('''Ứng dụng Dạy Nấu Ăn không chỉ là nơi để học nấu ăn mà còn là cộng đồng để chia sẻ kinh nghiệm, giao lưu với những người đam mê ẩm thực. Bạn có thể tham gia vào các nhóm thảo luận, thực hiện các cuộc thử thách nấu ăn và chia sẻ những bài đăng của riêng mình.'''),
                  t2('''Bảo mật và độ tin cậy'''),
                  t('''Chúng tôi luôn đặt sự bảo mật và độ tin cậy lên hàng đầu. Tất cả thông tin cá nhân của bạn đều được bảo vệ một cách an toàn và chỉ được sử dụng theo đúng các điều khoản đã được công bố. Chúng tôi cam kết cung cấp cho bạn một môi trường học tập và giao tiếp an toàn.'''),
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
