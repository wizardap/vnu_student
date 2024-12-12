import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vnu_student/core/constants/constants.dart';
import '../models/academic_result_model.dart'; // Import model
import '../widgets/overview_card.dart';
import '../widgets/academic_transcript_table.dart';
import 'package:fl_chart/fl_chart.dart'; // Để hiển thị Bar Chart trong pop-up

class AcademicResultsScreen extends StatefulWidget {
  @override
  _AcademicResultsScreenState createState() => _AcademicResultsScreenState();
}

class _AcademicResultsScreenState extends State<AcademicResultsScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _selectedSemester = "";
  String? userId;

  // Lấy dữ liệu từ Firestore
  Stream<List<AcademicResult>> _getAcademicResults() {
    final User? user = FirebaseAuth.instance.currentUser;
    final String userId = user?.uid ?? "";

    return _firestore
        .collection('academic_results')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) {
            final data = doc.data() as Map<String, dynamic>?;

            if (data == null) {
              return null;
            }

            // Chuyển đổi subjects từ List<dynamic> sang List<Subject>
            List<Subject> subjects = (data['subjects'] as List<dynamic>? ?? [])
                .asMap()
                .entries
                .map((entry) {
              final subjectData = entry.value as Map<String, dynamic>;
              return Subject(
                id: entry.key + 1,
                subjectName: subjectData['subjectName'] as String? ?? "Unknown",
                credit: subjectData['credit'] as int? ?? 0,
                grade: subjectData['grade'] as String? ?? "N/A",
              );
            }).toList();

            return AcademicResult(
              semester: data['semester'] as String? ?? "Unknown",
              gpa: (data['gpa'] as num?)?.toDouble() ?? 0.0,
              trainingPoints: data['trainingPoints'] as int? ?? 0,
              grades: Map<String, int>.from(data['gradeDistribution'] ?? {}),
              subjects: subjects,
              advice: List<String>.from(data['advice'] ?? []),
            );
          })
          .where((result) => result != null)
          .cast<AcademicResult>()
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Study Results",
          style: AppTextStyles.appBarTitle,
        ),
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        toolbarHeight: AppSizes.padding * 3.75,
      ),
      //backgroundColor: Colors.white,
      body: Container(
        color: AppColors.backgroundColor,
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.padding),
        child: StreamBuilder<List<AcademicResult>>(
          stream: _getAcademicResults(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Text(
                  "No academic results found.",
                  style: AppTextStyles.tableData,
                ),
              );
            }

            final academicResults = snapshot.data!;
            _selectedSemester = _selectedSemester.isEmpty
                ? academicResults.first.semester
                : _selectedSemester;

            final selectedResult = academicResults.firstWhere(
              (result) => result.semester == _selectedSemester,
              orElse: () => academicResults.first,
            );

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(academicResults.map((e) => e.semester).toList()),
                  SizedBox(height: AppSizes.padding),

                  // Tiêu đề "Overview"
                  Text("Overview", style: AppTextStyles.header),
                  SizedBox(height: AppSizes.smallPadding),

                  // OverviewCard
                  OverviewCard(
                    grades: selectedResult.grades,
                    gpa: selectedResult.gpa,
                    trainingPoints: selectedResult.trainingPoints,
                    onTap: () {
                      _showDetailedOverviewBottomSheet(
                        context,
                        selectedResult.grades,
                        selectedResult.gpa,
                        selectedResult.trainingPoints,
                        selectedResult.advice,
                      );
                    },
                  ),
                  SizedBox(height: AppSizes.padding),

                  // Tiêu đề "Academic Transcript"
                  Text("Academic Transcript", style: AppTextStyles.header),
                  SizedBox(height: AppSizes.smallPadding),

                  // AcademicTranscriptTable
                  AcademicTranscriptTable(subjects: selectedResult.subjects),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(List<String> semesters) {
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
                  _selectedSemester.split(" ")[0],
                  style: AppTextStyles.header.copyWith(fontSize: 24),
                ),
                Text(
                  "Semester ${_selectedSemester.split(" ")[1]}",
                  style: AppTextStyles.subHeader,
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppSizes.smallPadding,
                vertical: AppSizes.smallPadding / 2,
              ),
              decoration: BoxDecoration(
                color: AppColors.lightGray,
                borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadowGray,
                    blurRadius: AppSizes.shadowBlurRadius,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedSemester,
                  icon: Icon(Icons.arrow_drop_down, color: AppColors.iconGray),
                  style: AppTextStyles.dropdownItem,
                  items: semesters.map((semester) {
                    return DropdownMenuItem(
                      value: semester,
                      child: Text(semester),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedSemester = value!;
                    });
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showDetailedOverviewBottomSheet(
      BuildContext context,
      Map<String, int> grades,
      double gpa,
      int trainingPoints,
      List<String> advice) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(AppSizes.borderRadius)),
      ),
      builder: (context) {
        return DefaultTabController(
          length: 3,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.8,
            padding: EdgeInsets.all(AppSizes.padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Detailed Overview", style: AppTextStyles.header),
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
                Expanded(
                  child: TabBarView(
                    children: [
                      _buildOverviewTab(gpa, trainingPoints),
                      _buildDetailsTab(grades),
                      _buildSuggestionsTab(advice), // Truyền advice vào đây
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
  Widget _buildSuggestionsTab(List<String> advice) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Suggestions for Improvement:", style: AppTextStyles.header),
        SizedBox(height: AppSizes.smallPadding),
        advice.isNotEmpty
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: advice.map((suggestion) {
                  return Padding(
                    padding:
                        const EdgeInsets.only(bottom: AppSizes.smallPadding),
                    child: Text(
                      "- $suggestion",
                      style: AppTextStyles.tableData,
                    ),
                  );
                }).toList(),
              )
            : Text(
                "No suggestions available.",
                style: AppTextStyles.tableData,
              ),
      ],
    );
  }
}
