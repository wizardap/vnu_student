import 'package:flutter/material.dart';
import 'package:vnu_student/core/constants/constants.dart';
import '../widgets/overview_card.dart';
import '../widgets/academic_transcript_table.dart';
import 'package:fl_chart/fl_chart.dart'; // Để hiển thị Bar Chart trong pop-up

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
      "grades": {"A+": 15, "A": 10, "B+": 5},
      "subjects": [
        {"stt": 1, "name": "Tín hiệu và hệ thống", "credits": 3, "grade": "A"},
        {"stt": 2, "name": "Toán rời rạc", "credits": 4, "grade": "A+"},
        {"stt": 3, "name": "Hóa học đại cương", "credits": 3, "grade": "B+"},
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
          style: AppTextStyles.appBarTitle,
        ),
        backgroundColor: AppColors.white,
        elevation: 0,
        toolbarHeight: AppSizes.padding * 3.75,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.padding),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              SizedBox(height: AppSizes.padding),

              // Tiêu đề OverviewCard
              Text(
                "Overview",
                style: AppTextStyles.header,
              ),
              SizedBox(height: AppSizes.smallPadding),

              // Sử dụng OverviewCard widget
              OverviewCard(
                grades: grades,
                gpa: selectedData["gpa"],
                trainingPoints: selectedData["trainingPoints"],
                onTap: () {
                  _showDetailedOverviewBottomSheet(context, grades,
                      selectedData["gpa"], selectedData["trainingPoints"]);
                },
              ),

              SizedBox(height: AppSizes.padding),

              // Tiêu đề AcademicTranscriptTable
              Text(
                "Academic Transcript",
                style: AppTextStyles.header,
              ),
              SizedBox(height: AppSizes.smallPadding),

              // Sử dụng AcademicTranscriptTable widget
              AcademicTranscriptTable(subjects: subjects),
            ],
          ),
        ),
      ),
    );
  }

  // Header chọn học kỳ
  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: AppSizes.smallPadding / 2),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "2024-2025",
                  style: AppTextStyles.header,
                ),
                Text(
                  "Semester I",
                  style: AppTextStyles.subHeader,
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.smallPadding,
                  vertical: AppSizes.smallPadding / 2),
              decoration: BoxDecoration(
                color: AppColors.lightGray,
                borderRadius: BorderRadius.circular(AppSizes.borderRadius),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedSemester,
                  items: _semesters.map((semester) {
                    return DropdownMenuItem(
                      value: semester,
                      child: Text(
                        semester,
                        style: AppTextStyles.dropdownItem,
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedSemester = value!;
                    });
                  },
                  icon: Icon(
                    Icons.arrow_drop_down,
                    color: AppColors.textBlack,
                    size: 24,
                  ),
                  dropdownColor: AppColors.lightGray,
                  borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showDetailedOverviewBottomSheet(BuildContext context,
      Map<String, int> grades, double gpa, int trainingPoints) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(AppSizes.borderRadius)),
      ),
      builder: (context) {
        return DefaultTabController(
          length: 3, // Số lượng tab
          child: Container(
            height: MediaQuery.of(context).size.height * 0.8,
            padding: EdgeInsets.all(AppSizes.padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tiêu đề và Tabs
                Text(
                  "Detailed Overview",
                  style: AppTextStyles.header,
                ),
                SizedBox(height: AppSizes.smallPadding),
                TabBar(
                  labelColor: AppColors.primaryGreen,
                  unselectedLabelColor: AppColors.textBlack,
                  indicatorColor: AppColors.primaryGreen,
                  tabs: [
                    Tab(text: "Overview"),
                    Tab(text: "Details"),
                    Tab(text: "Suggestions"),
                  ],
                ),
                SizedBox(height: AppSizes.padding),

                // Nội dung Tabs
                Expanded(
                  child: TabBarView(
                    children: [
                      // Tab Overview
                      _buildOverviewTab(gpa, trainingPoints),

                      // Tab Details
                      _buildDetailsTab(grades),

                      // Tab Suggestions
                      _buildSuggestionsTab(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

// Tab Overview
  Widget _buildOverviewTab(double gpa, int trainingPoints) {
    final totalCredits = 120;
    final completedCredits = 45;
    final progressPercentage = (completedCredits / totalCredits) * 100;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("GPA: $gpa", style: AppTextStyles.overviewStat),
            Text("Training Points: $trainingPoints",
                style: AppTextStyles.tableData),
          ],
        ),
        SizedBox(height: AppSizes.padding),

        // Tiến độ học tập
        Text("Progress Towards Graduation:", style: AppTextStyles.header),
        SizedBox(height: AppSizes.smallPadding),
        LinearProgressIndicator(
          value: progressPercentage / 100,
          color: AppColors.primaryGreen,
          backgroundColor: AppColors.lightGray,
          minHeight: 8,
        ),
        SizedBox(height: AppSizes.smallPadding),
        Text(
          "${progressPercentage.toStringAsFixed(1)}% completed ($completedCredits/$totalCredits credits)",
          style: AppTextStyles.tableData,
        ),
      ],
    );
  }

// Tab Details
  Widget _buildDetailsTab(Map<String, int> grades) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Grade Distribution:", style: AppTextStyles.header),
        SizedBox(height: AppSizes.smallPadding),
        Expanded(
          child: PieChart(
            PieChartData(
              sections: grades.entries.map((entry) {
                double percentage =
                    (entry.value / grades.values.reduce((a, b) => a + b)) * 100;
                return PieChartSectionData(
                  color: entry.key == "A+"
                      ? AppColors.pieChartGreen1
                      : entry.key == "A"
                          ? AppColors.pieChartGreen2
                          : AppColors.pieChartGreen3,
                  value: entry.value.toDouble(),
                  title: "${percentage.toStringAsFixed(1)}%",
                  radius: 80,
                  titleStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                  ),
                );
              }).toList(),
              centerSpaceRadius: 50,
              sectionsSpace: 2,
            ),
          ),
        ),
        SizedBox(height: AppSizes.padding),

        // Chú thích
        Wrap(
          spacing: AppSizes.smallPadding,
          children: grades.keys.map((key) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 12,
                  height: 12,
                  color: key == "A+"
                      ? AppColors.pieChartGreen1
                      : key == "A"
                          ? AppColors.pieChartGreen2
                          : AppColors.pieChartGreen3,
                  margin: EdgeInsets.only(right: 4),
                ),
                Text(
                  key,
                  style: AppTextStyles.tableData,
                ),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }

// Tab Suggestions
  Widget _buildSuggestionsTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Suggestions for Improvement:", style: AppTextStyles.header),
        SizedBox(height: AppSizes.smallPadding),
        Text(
          "- Focus on subjects with lower grades.\n"
          "- Attend extra classes or tutoring sessions.\n"
          "- Maintain consistent study habits.\n"
          "- Set a target GPA and track progress regularly.",
          style: AppTextStyles.tableData,
        ),
      ],
    );
  }
}
