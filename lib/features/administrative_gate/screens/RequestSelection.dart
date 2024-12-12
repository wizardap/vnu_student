import 'package:flutter/material.dart';

class RequestSelection extends StatefulWidget {
  final Function(String) onItemSelected;  // Callback function

  RequestSelection({required this.onItemSelected});  // Constructor
  @override
  _RequestSelectionState createState() => _RequestSelectionState();
}

class _RequestSelectionState extends State<RequestSelection> {
  String selectedItem = "Chứng nhận Sinh viên"; // Giá trị hiển thị mặc định
  List<String> items = ["Chứng nhận Sinh viên", "Học bổng", "Mất thẻ sinh viên", "Hoãn nghĩa vụ quân sự", "Đăng ký ở KTX", "Giấy giới thiệu thực tập", "Loại khác"]; // Danh sách các item

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        setState(() {
          selectedItem = value;
          widget.onItemSelected(selectedItem);
        });
      },
      itemBuilder: (context) => items.map((item) {
        return PopupMenuItem<String>(
          value: item,
          child: Text(
            item,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
        );
      }).toList(),
      color: Colors.white, // Thay đổi màu nền popup
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // Bo góc menu
      ),
      offset: Offset(0, 50), // Đặt vị trí popup bên dưới nút (x: 0, y: 50)
      child: Container(
        constraints: BoxConstraints(maxWidth: 212), // Giới hạn chiều rộng
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color:Color.fromARGB(116, 0, 0, 0),),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                selectedItem,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
            Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }
}