import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
Uri _url = Uri.parse('https://flutter.dev');

class HandBookScreen extends StatelessWidget {
  // Danh sách biểu tượng và nhãn
  final List<Map<String, dynamic>> items = [
  {
    'icon': Icons.history,
    'label': 'History and Tradition',
    'url': Uri.parse('http://handbook.uet.vnu.edu.vn/lịch%20sử%20-%20truyền%20thống/'),
  },
  {
    'icon': Icons.attach_money,
    'label': 'Tuition Policy',
    'url': Uri.parse('http://handbook.uet.vnu.edu.vn/Học phí - Chế độ chính sách/'),
  },
  {
    'icon': Icons.card_giftcard,
    'label': 'Scholarship Policy',
    'url': Uri.parse('http://handbook.uet.vnu.edu.vn/Học bổng/'),
  },
  {
    'icon': Icons.rule,
    'label': 'Rules and Regulations',
    'url': Uri.parse('http://handbook.uet.vnu.edu.vn/Nội quy - quy chế/'),
  },
  {
    'icon': Icons.attach_file,
    'label': 'Useful Information Portals',
    'url': Uri.parse('http://handbook.uet.vnu.edu.vn/các cổng thông tin hữu ích/'),
  },
  {
    'icon': Icons.work_outline,
    'label': 'Job Opportunities',
    'url': Uri.parse('https://vieclam.uet.vnu.edu.vn'), // Đảm bảo URL hợp lệ
  },
  {
    'icon': Icons.handshake,
    'label': 'Student Exchange',
    'url': Uri.parse('http://handbook.uet.vnu.edu.vn/Trao đổi sinh viên/'),
  },
  {
    'icon': Icons.apartment,
    'label': 'Dormitory',
    'url': Uri.parse('http://handbook.uet.vnu.edu.vn/Ký túc xá/'),
  },
];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Handbook',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
        ),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Container(
        color: const Color.fromARGB(255, 255, 255, 255),
        padding: const EdgeInsets.all(20.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return Card(
              color: const Color(0xFF13511C),
              elevation: 2.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: InkWell(
                onTap: () {
                  // Gọi hàm mở URL từ bên ngoài
                  _url = item['url'];
                  _launchUrl();
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      item['icon'],
                      size: 48.0,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      item['label'],
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                      textAlign: TextAlign.center,
                    ),
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
// Hàm mở URL, kiểm tra và chuyển đổi nếu cần
Future<void> _launchUrl() async {
  print(_url);
  if (!await launchUrl(_url)) {
    throw Exception('Could not launch $_url');
  }
}