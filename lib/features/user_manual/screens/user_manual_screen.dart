import 'package:flutter/material.dart';

class UserManualScreen extends StatefulWidget {
  @override
  _UserManualScreenState createState() => _UserManualScreenState();
}

class _UserManualScreenState extends State<UserManualScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _manualPages = [
    {
      'image': 'lib/assets/images/user_manual1.png',
      'title': 'Chào mừng đến với ứng dụng',
      'description': 'Khám phá các tính năng dễ dàng và thuận tiện.',
    },
    {
      'image': 'lib/assets/images/user_manual2.png',
      'title': 'Kết quả học tập',
      'description':
          'Xem kết quả học tập qua từng học kỳ, chi tiết từng môn học.',
    },
    {
      'image': 'lib/assets/images/user_manual3.png',
      'title': 'Quản lý lịch thi',
      'description':
          'Theo dõi lịch thi và sự kiện quan trọng một cách nhanh chóng.',
    },
    {
      'image': 'lib/assets/images/user_manual_faq.png',
      'title': 'Câu hỏi thường gặp',
      'description': '''
1. Làm sao để đổi mật khẩu?
   - Vào menu > Cài đặt > Đổi mật khẩu.

2. Làm sao để xem thông báo cũ?
   - Vào mục "Thông báo" trong menu chính.

3. Làm sao để liên hệ với bộ phận hỗ trợ?
   - Gửi email tới support@example.com.
      ''',
    },
  ];

  void _nextPage() {
    if (_currentPage < _manualPages.length - 1) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _finishManual();
    }
  }

  void _finishManual() {
    Navigator.pop(context); // Quay về màn hình trước
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // PageView hiển thị từng bước hướng dẫn
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: _manualPages.length,
            itemBuilder: (context, index) {
              final page = _manualPages[index];
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Hình ảnh minh họa
                    Image.asset(
                      page['image']!,
                      height: 250,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(height: 20),

                    // Tiêu đề
                    Text(
                      page['title']!,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    SizedBox(height: 10),

                    // Mô tả nội dung
                    Text(
                      page['description']!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          // Nút "Skip"
          if (_currentPage < _manualPages.length - 1)
            Positioned(
              top: 40,
              right: 20,
              child: GestureDetector(
                onTap: _finishManual,
                child: Text(
                  'Bỏ qua',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

          // Điều hướng giữa các bước
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Column(
              children: [
                // Chỉ báo vị trí (dots)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _manualPages.length,
                    (index) => AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      margin: EdgeInsets.symmetric(horizontal: 4),
                      width: _currentPage == index ? 12 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color:
                            _currentPage == index ? Colors.blue : Colors.grey,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),

                // Nút Next/Finish
                ElevatedButton(
                  onPressed: _nextPage,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    _currentPage == _manualPages.length - 1
                        ? 'Hoàn thành'
                        : 'Tiếp tục',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
