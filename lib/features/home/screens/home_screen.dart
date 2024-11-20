import 'package:flutter/material.dart';
import 'package:vnu_student/core/constants/constants.dart';
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
        title: Text(
          'Home',
          style: AppTextStyles.appBarTitle,
        ),
        backgroundColor: AppColors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.textBlack),
      ),
      body: Column(
        children: [
          // Nút lọc
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSizes.padding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildFilterButton("All", 0, Icons.all_inclusive),
                _buildFilterButton("News", 1, Icons.article),
                _buildFilterButton("Notifications", 2, Icons.notifications),
              ],
            ),
          ),
          // Tìm kiếm
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.padding, vertical: AppSizes.smallPadding),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadowGray.withOpacity(0.3),
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
                  hintStyle: AppTextStyles.searchHint,
                  prefixIcon: Icon(Icons.search, color: AppColors.iconGray),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: AppSizes.padding,
                      vertical: AppSizes.smallPadding),
                ),
              ),
            ),
          ),

          // Danh sách tin tức/thông báo
          Expanded(
            child: AnimatedSwitcher(
              duration: Duration(milliseconds: 300),
              child: filteredItems.isNotEmpty
                  ? ListView.builder(
                      key: ValueKey<int>(_selectedFilter),
                      itemCount: filteredItems.length,
                      itemBuilder: (context, index) {
                        return _buildNotificationItem(
                          title: filteredItems[index]["title"]!,
                          subtitle: filteredItems[index]["content"]!,
                          type: filteredItems[index]["type"]!,
                        );
                      },
                    )
                  : Center(
                      child: Text(
                        "No items found",
                        style: AppTextStyles.subHeader,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget nút lọc
  Widget _buildFilterButton(String title, int filterIndex, IconData icon) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = filterIndex;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        padding: EdgeInsets.symmetric(
            horizontal: AppSizes.padding, vertical: AppSizes.smallPadding),
        margin: EdgeInsets.symmetric(horizontal: AppSizes.smallPadding / 2),
        decoration: BoxDecoration(
          color: _selectedFilter == filterIndex
              ? AppColors.primaryGreen
              : AppColors.lightGray,
          borderRadius: BorderRadius.circular(AppSizes.borderRadius),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: _selectedFilter == filterIndex
                  ? AppColors.white
                  : AppColors.textBlack,
            ),
            SizedBox(width: AppSizes.smallPadding / 2),
            Text(
              title,
              style: _selectedFilter == filterIndex
                  ? AppTextStyles.tabSelected
                  : AppTextStyles.tabUnselected,
            ),
          ],
        ),
      ),
    );
  }

  // Widget hiển thị một item trong danh sách thông báo/tin tức
  Widget _buildNotificationItem({
    required String title,
    required String subtitle,
    required String type,
  }) {
    return Card(
      margin: EdgeInsets.symmetric(
          vertical: AppSizes.smallPadding,
          horizontal: AppSizes.padding), // Margin từ constants
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.borderRadius),
      ),
      elevation: AppSizes.cardElevation, // Độ nổi của card
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.lightGray,
          child: Icon(
            type == "News" ? Icons.article : Icons.notifications,
            color: AppColors.iconGray,
          ),
        ),
        title: Text(
          title,
          style: AppTextStyles.notificationTitle,
        ),
        subtitle: Text(
          subtitle,
          style: AppTextStyles.notificationSubtitle,
        ),
        trailing: Icon(Icons.arrow_forward, color: AppColors.iconGray),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailScreen(
                title: title,
                content: subtitle,
              ),
            ),
          );
        },
      ),
    );
  }
}
