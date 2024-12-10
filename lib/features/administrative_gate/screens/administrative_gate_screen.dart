import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

void click(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15), // Bo góc cho toàn bộ AlertDialog
        ),
        elevation: 10, // Tạo hiệu ứng độ cao để nổi bật
        content: Container(
          padding: const EdgeInsets.all(20), // Padding xung quanh nội dung
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15), // Bo góc cho Container
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3), // Nhẹ nhàng hơn cho bóng đổ
                spreadRadius: 2,
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Làm cho column không chiếm toàn bộ chiều cao
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // TextField phần yêu cầu tạo request
              TextField(
                decoration: InputDecoration(
                  hintText: 'Create a request',
                  hintStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(Icons.add, color: Color(0xFF13511C)),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),
              ),
              SizedBox(height: 20),
              
              // Phần upload tài liệu
              GestureDetector(
                onTap: () async {
                  FilePickerResult? result = await FilePicker.platform.pickFiles();
                  if (result != null) {
                    // Nếu có file được chọn, bạn có thể xử lý ở đây
                    String fileName = result.files.single.name;
                    print("File selected: $fileName");
                    // Hiển thị tên file cho người dùng
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('File selected: $fileName')),
                    );
                  } else {
                    // Không có file nào được chọn
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('No file selected')),
                    );
                  }
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  decoration: BoxDecoration(
                    color: Color(0xFF13511C),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.upload_file, color: Colors.white),
                      SizedBox(width: 10),
                      Text(
                        'Upload Document',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: Text(
              "Send",
              style: TextStyle(
                color: Color(0xFF13511C), // Màu nút phù hợp với icon
                fontWeight: FontWeight.bold, // Làm đậm chữ
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop(); // Đóng dialog
            },
          ),
        ],
      );
    },
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
                padding: const EdgeInsets.all(8.0),
                children: [
                  BuildRequestStatusTile(
                    title: 'In progress',
                    counts: 4,
                  ),
                  const SizedBox(height: 30),
                  BuildRequestStatusTile(
                    title: 'Done',
                    counts: 5,
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BuildRequestStatusTile extends StatefulWidget {
  final String title;
  final int counts;

  const BuildRequestStatusTile({
    super.key,
    required this.title,
    required this.counts,
  });

  @override
  State<BuildRequestStatusTile> createState() => _BuildRequestStatusTileState();
}

class _BuildRequestStatusTileState extends State<BuildRequestStatusTile> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: isExpanded ? Colors.red[300] : Colors.grey[200], // Nền chỉ cho title và icon
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: ListTile(
              title: Text(
                widget.title,
                style: TextStyle(
                  color: isExpanded ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: Icon(
                isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                color: isExpanded ? Colors.white : Colors.black54,
              ),
              onTap: () {
                setState(() {
                  isExpanded = !isExpanded;
                });
              },
            ),
          ),
          if (isExpanded)
  ListView.builder(
    shrinkWrap: true, // Để tránh lỗi layout
    physics: const NeverScrollableScrollPhysics(), // Ngăn ListView cuộn
    itemCount: 10,
    itemBuilder: (context, index) {
      return Container(
        padding: const EdgeInsets.only(left: 20.0),
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center, // Căn giữa dấu đầu dòng và văn bản
          children: [
            const Icon(
              Icons.fiber_manual_record, // Dấu đầu dòng
              size: 8, // Kích thước dấu đầu dòng
              color: Colors.black54, // Màu dấu đầu dòng
            ),
            const SizedBox(width: 12.0), // Khoảng cách giữa dấu đầu dòng và nội dung
            Expanded(
              child: Text(
                'Test ${index + 1}',
                style: const TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      );
    },
  ),

        ],
      ),

    );
  }
}
