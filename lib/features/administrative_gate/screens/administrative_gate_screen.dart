import 'package:flutter/material.dart';

void main() {
  runApp(const AdministrativeGateApp());
}

class AdministrativeGateApp extends StatelessWidget {
  const AdministrativeGateApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AdministrativeGateScreen(),
    );
  }
}

void click(BuildContext context){
    showDialog(context: context,
     builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20), // Bo góc cho toàn bộ AlertDialog
        ),
          content: Container(
              decoration: BoxDecoration(
                color: Colors.white, // Màu nền
                borderRadius: BorderRadius.circular(10), // Bo góc
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5), // Màu đổ bóng
                    spreadRadius: 2, // Độ lan tỏa
                    blurRadius: 5, // Độ mờ của bóng
                    offset: Offset(0, 3), // Hướng bóng (x, y)
                  ),
                ],
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Create a request', // Văn bản gợi ý
                  hintStyle: TextStyle(color: Colors.grey), // Màu chữ gợi ý
                  prefixIcon: Icon(Icons.add, color: Color(0xFF13511C)), // Icon ở bên trái
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none, // Xóa viền mặc định
                    borderRadius: BorderRadius.circular(20), // Bo góc viền
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15), // Khoảng cách bên trong
                ),
              ),
            ),
            actions: [
            TextButton(
              child: Text("Send"),
              onPressed: () {
                Navigator.of(context).pop(); // Đóng dialog
              },
            ),
          ],
      );
     }
     );
}

class AdministrativeGateScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Administrative Gate',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 60, // Đặt chiều cao AppBar để không chiếm nhiều không gian
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            // Create Request Button
            InkWell(
            onTap: () => click(context),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white, // Màu nền
                borderRadius: BorderRadius.circular(20), // Bo góc
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5), // Màu đổ bóng
                    spreadRadius: 2, // Độ lan tỏa
                    blurRadius: 5, // Độ mờ của bóng
                    offset: Offset(0, 3), // Hướng bóng (x, y)
                  ),
                ],
              ),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Row(
                children: [
                  Icon(Icons.add, color: Color(0xFF13511C)), // Icon bên trái
                  SizedBox(width: 10), // Khoảng cách giữa icon và text
                  Text(
                    'Create a request',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ],
              ),
            ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: EdgeInsets.only(left: 0.0), // Tạo khoảng cách 30px bên trái
              child: Text(
                "Requests status",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            // Requests Status List
            Expanded(
              child: ListView(
                children: [
                  _buildRequestStatusTile('In progress', 4),
                  const SizedBox(height: 30),
                  _buildRequestStatusTile('Done', 5),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
  Widget _buildRequestStatusTile(String title, int itemCount) {
  return Theme(
    data: ThemeData().copyWith(dividerColor: Colors.transparent), // Tắt divider toàn bộ
    child: ExpansionTile(
      title: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        decoration: BoxDecoration(
          color: const Color(0xFF13511C),
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      iconColor: const Color.fromRGBO(211, 158, 84, 1),
      collapsedIconColor: const Color.fromRGBO(211, 158, 84, 1),
      children: List.generate(
        itemCount,
        (index) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          margin: const EdgeInsets.only(bottom: 8.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(
              color: Colors.grey,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              const CircleAvatar(
                radius: 5,
                backgroundColor: Colors.black,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title + index.toString(),
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
            
          ),
          
        ),
      ),
    ),
  );
}
