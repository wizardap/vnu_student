import 'package:flutter/material.dart';

class DetailScreen extends StatelessWidget {
  final String title;
  final String content;
  final String details;
  final String imageUrl;
  final String timestamp;
  final String department;
  final String contactEmail;
  final String contactPhone;

  DetailScreen({
    required this.title,
    required this.content,
    required this.details,
    required this.imageUrl,
    required this.timestamp,
    required this.department,
    required this.contactEmail,
    required this.contactPhone,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Article'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ảnh minh họa
            if (imageUrl.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Image.network(
                    imageUrl,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

            // Phần tiêu đề và ngày giờ
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    timestamp,
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  Divider(height: 30, thickness: 1),
                ],
              ),
            ),

            // Nội dung tóm tắt
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                content,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),

            SizedBox(height: 10),

            // Nội dung chi tiết
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                details,
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
            ),

            SizedBox(height: 30),

            // Thông tin liên hệ và phòng ban
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              color: Colors.grey.shade100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(),
                  Text(
                    'Department: $department',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.email, color: Colors.blue),
                      SizedBox(width: 10),
                      Text(
                        contactEmail,
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.phone, color: Colors.green),
                      SizedBox(width: 10),
                      Text(
                        contactPhone,
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
