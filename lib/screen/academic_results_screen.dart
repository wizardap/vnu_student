import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class AcademicResultsScreen extends StatefulWidget {
  @override
  _AcademicResultsScreenState createState() => _AcademicResultsScreenState();
}

class _AcademicResultsScreenState extends State<AcademicResultsScreen> {
  String _selectedSemester = "Học kỳ I 2024-2025";

  final List<String> _semesters = [
    "Học kỳ I 2024-2025",
    "Học kỳ II 2024-2025",
    "Học kỳ I 2023-2024",
  ];

  final Map<String, dynamic> _data = {
    "Học kỳ I 2024-2025": {
      "gpa": 3.2,
      "trainingPoints": 80,
      "grades": {"A+": 15, "A": 5, "B+": 30},
      "subjects": [
        {"stt": 1, "name": "Tín hiệu và hệ thống", "credits": 3, "grade": "A"},
        {"stt": 2, "name": "Tín hiệu và hệ thống", "credits": 3, "grade": "A"},
        {"stt": 3, "name": "Tín hiệu và hệ thống", "credits": 3, "grade": "A"},
        {"stt": 4, "name": "Tín hiệu và hệ thống", "credits": 3, "grade": "A"},
        {"stt": 5, "name": "Tín hiệu và hệ thống", "credits": 3, "grade": "A"},
        {"stt": 6, "name": "Tín hiệu và hệ thống", "credits": 3, "grade": "A"},
        {"stt": 7, "name": "Tín hiệu và hệ thống", "credits": 3, "grade": "A"},
        {"stt": 1, "name": "Tín hiệu và hệ thống", "credits": 3, "grade": "A"},
        {"stt": 2, "name": "Tín hiệu và hệ thống", "credits": 3, "grade": "A"},
        {"stt": 3, "name": "Tín hiệu và hệ thống", "credits": 3, "grade": "A"},
        {"stt": 4, "name": "Tín hiệu và hệ thống", "credits": 3, "grade": "A"},
        {"stt": 5, "name": "Tín hiệu và hệ thống", "credits": 3, "grade": "A"},
        {"stt": 6, "name": "Tín hiệu và hệ thống", "credits": 3, "grade": "A"},
        {"stt": 7, "name": "Tín hiệu và hệ thống", "credits": 3, "grade": "A"},
      ],
    },
  };

  @override
  Widget build(BuildContext context) {
    final selectedData = _data[_selectedSemester];
    final grades = selectedData["grades"];
    final subjects = selectedData["subjects"];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Study Results",
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0, // Xóa bóng dưới AppBar
        toolbarHeight:
            60, // Đặt chiều cao AppBar để không chiếm nhiều không gian
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              SizedBox(height: 16),

              // Tiêu đề cho _buildOverview
              Text(
                "Overview",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 8),
              _buildOverview(selectedData, grades),

              SizedBox(height: 16),

              // Tiêu đề cho _buildTranscriptTable
              Text(
                "Academic Transcript",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              // Giảm khoảng cách giữa tiêu đề và bảng
              SizedBox(height: 4),
              _buildTranscriptTable(subjects),
            ],
          ),
        ),
      ),
    );
  }

  // Tiêu đề và Dropdown chọn học kỳ
  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 8),
        // Năm học và học kỳ
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "2024-2025",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Semester I",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
            // Dropdown chọn học kỳ
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Color(0xFFD9D9D9), // Màu nền xám nhạt
                borderRadius: BorderRadius.circular(12), // Bo góc cho Dropdown
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedSemester,
                  items: _semesters.map((semester) {
                    return DropdownMenuItem(
                      value: semester,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xFFD9D9D9), // Màu nền xám nhạt
                          borderRadius:
                              BorderRadius.circular(8), // Bo góc cho từng mục
                        ),
                        padding: EdgeInsets.symmetric(
                            vertical: 8), // Padding từng mục
                        child: Text(
                          semester,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedSemester = value!;
                    });
                  },
                  icon: Icon(
                    Icons.arrow_drop_down, // Biểu tượng mũi tên
                    color: Colors.black,
                    size: 24,
                  ),
                  dropdownColor: Color(0xFFD9D9D9), // Nền xám cho menu Dropdown
                  borderRadius:
                      BorderRadius.circular(12), // Bo góc menu Dropdown
                  menuMaxHeight: 200, // Giới hạn chiều cao menu
                ),
              ),
            )
          ],
        ),
      ],
    );
  }

  Widget _buildOverview(Map<String, dynamic> data, Map<String, int> grades) {
    Map<String, double> gradesDouble =
        grades.map((key, value) => MapEntry(key, value.toDouble()));

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            flex: 2,
            child: PieChart(
              dataMap: gradesDouble,
              animationDuration: Duration(milliseconds: 800),
              chartType: ChartType.disc,
              chartRadius: MediaQuery.of(context).size.width / 3.5,
              colorList: [
                Color(0xCC0C7623), // #0C7623, 80%
                Color(0xCC32A44B), // #32A44B, 80%
                Color(0xCC53C26B), // #53C26B, 80%
              ],
              chartValuesOptions: ChartValuesOptions(
                showChartValues: false,
              ),
              legendOptions: LegendOptions(
                showLegends: false,
              ),
            ),
          ),
          SizedBox(width: 8),
          Flexible(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "GPA: ${data["gpa"]}",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Training Points: ${data["trainingPoints"]}",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: grades.entries.map((entry) {
                    return Row(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          color: entry.key == "A+"
                              ? Color(0xCC0C7623) // #0C7623
                              : entry.key == "A"
                                  ? Color(0xCC32A44B) // #32A44B
                                  : Color(0xCC53C26B), // #53C26B
                          margin: EdgeInsets.only(right: 8),
                        ),
                        Text(
                          "${entry.key} points: ${entry.value}",
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTranscriptTable(List<Map<String, dynamic>> subjects) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Container(
            width: constraints.maxWidth,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.black12,
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                // Header bảng
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xFF13511C),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                  ),
                  child: Row(
                    children: [
                      _buildHeaderCell("STT", flex: 2), // Tăng flex cho STT
                      _buildHeaderCell("Tên môn học", flex: 4),
                      _buildHeaderCell("Số tín chỉ", flex: 2),
                      _buildHeaderCell("Điểm chữ", flex: 2),
                    ],
                  ),
                ),
                // Các hàng dữ liệu
                ...subjects.asMap().entries.map((entry) {
                  final isLast = entry.key == subjects.length - 1;
                  return Container(
                    decoration: BoxDecoration(
                      color:
                          entry.key % 2 == 0 ? Colors.white : Color(0xFFF8F9FA),
                      borderRadius: isLast
                          ? BorderRadius.only(
                              bottomLeft: Radius.circular(12),
                              bottomRight: Radius.circular(12),
                            )
                          : BorderRadius.zero,
                    ),
                    child: Row(
                      children: [
                        _buildDataCell(entry.value["stt"].toString(), flex: 2),
                        _buildDataCell(entry.value["name"], flex: 4),
                        _buildDataCell(entry.value["credits"].toString(),
                            flex: 2),
                        _buildDataCell(entry.value["grade"], flex: 2),
                      ],
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeaderCell(String text, {required int flex}) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Colors.white, // Màu chữ trắng cho header
          ),
        ),
      ),
    );
  }

  Widget _buildDataCell(String text, {required int flex}) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }
}
