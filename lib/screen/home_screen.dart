import 'package:flutter/material.dart';
import 'detail_screen.dart'; // Import màn hình chi tiết

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedFilter = 0; // 0: All, 1: News, 2: Notifications

  // Dữ liệu giả lập
  final List<Map<String, String>> items = [
    {
      "type": "News",
      "title": "New Semester Starts!",
      "content": "Prepare for the upcoming semester."
    },
    {
      "type": "Notification",
      "title": "Tuition Fee Reminder",
      "content": "Pay your tuition fee before Dec 1st."
    },
    {
      "type": "News",
      "title": "Library Open Hours",
      "content": "Library will extend its hours during exams."
    },
    {
      "type": "Notification",
      "title": "Exam Schedule Released",
      "content": "Check the portal for the latest schedule."
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Lọc dữ liệu dựa trên loại đã chọn
    List<Map<String, String>> filteredItems = _selectedFilter == 0
        ? items
        : items
            .where((item) =>
                item["type"] ==
                (_selectedFilter == 1 ? "News" : "Notification"))
            .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Column(
        children: [
          // Nút lọc
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Nút "All"
              GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedFilter = 0;
                  });
                },
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color:
                        _selectedFilter == 0 ? Colors.green : Colors.grey[300],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.all_inclusive,
                          color: _selectedFilter == 0
                              ? Colors.white
                              : Colors.black),
                      SizedBox(width: 4),
                      Text(
                        "All",
                        style: TextStyle(
                            color: _selectedFilter == 0
                                ? Colors.white
                                : Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
              // Nút "News"
              GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedFilter = 1;
                  });
                },
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color:
                        _selectedFilter == 1 ? Colors.green : Colors.grey[300],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.article,
                          color: _selectedFilter == 1
                              ? Colors.white
                              : Colors.black),
                      SizedBox(width: 4),
                      Text(
                        "News",
                        style: TextStyle(
                            color: _selectedFilter == 1
                                ? Colors.white
                                : Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
              // Nút "Notifications"
              GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedFilter = 2;
                  });
                },
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color:
                        _selectedFilter == 2 ? Colors.green : Colors.grey[300],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.notifications,
                          color: _selectedFilter == 2
                              ? Colors.white
                              : Colors.black),
                      SizedBox(width: 4),
                      Text(
                        "Notifications",
                        style: TextStyle(
                            color: _selectedFilter == 2
                                ? Colors.white
                                : Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // Tìm kiếm
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3), // Đổ bóng nhẹ
                  ),
                ],
              ),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    filteredItems = items
                        .where((item) =>
                            item['title']!
                                .toLowerCase()
                                .contains(value.toLowerCase()) ||
                            item['content']!
                                .toLowerCase()
                                .contains(value.toLowerCase()))
                        .toList();
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search...',
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),
              ),
            ),
          ),

          // Danh sách tin tức/thông báo
          Expanded(
            child: AnimatedSwitcher(
              duration: Duration(milliseconds: 300),
              child: ListView.builder(
                key: ValueKey<int>(_selectedFilter),
                itemCount: filteredItems.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: AssetImage(
                          filteredItems[index]["type"] == "News"
                              ? 'assets/news.png'
                              : 'assets/notification.png',
                        ),
                      ),
                      title: Text(filteredItems[index]["title"]!),
                      subtitle: Text(filteredItems[index]["content"]!),
                      trailing: Icon(Icons.arrow_forward),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailScreen(
                              title: filteredItems[index]["title"]!,
                              content: filteredItems[index]["content"]!,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
