import 'package:flutter/material.dart';
import 'package:vnu_student/core/constants/constants.dart';
import '../models/academic_result_model.dart'; // Import AcademicResult and Subject

class AcademicTranscriptTable extends StatelessWidget {
  final List<Subject> subjects;

  AcademicTranscriptTable({required this.subjects});

  @override
  Widget build(BuildContext context) {
    // Automatically add serial numbers if not present
    final List<Subject> subjectsWithIndex =
        subjects.asMap().entries.map((entry) {
      final index = entry.key + 1;
      final subject = entry.value;
      return Subject(
        id: subject.id != 0 ? subject.id : index,
        subjectName: subject.subjectName,
        credit: subject.credit,
        grade: subject.grade,
      );
    }).toList();

    return LayoutBuilder(
      builder: (context, constraints) {
        return Padding(
          padding: EdgeInsets.only(top: AppSizes.padding),
          child: Container(
            width: constraints.maxWidth,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppSizes.borderRadius),
              border: Border.all(color: AppColors.shadowGray, width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadowGray,
                  blurRadius: AppSizes.shadowBlurRadius,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildHeader(),
                ..._buildRows(context, subjectsWithIndex),
                _buildSummary(subjectsWithIndex),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primaryGreen,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppSizes.borderRadius),
          topRight: Radius.circular(AppSizes.borderRadius),
        ),
      ),
      child: Row(
        children: [
          _buildHeaderCell("No.", flex: 1),
          _buildHeaderCell("Subject Name", flex: 4),
          _buildHeaderCell("Credits", flex: 2),
          _buildHeaderCell("Grade", flex: 2),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(String text, {required int flex}) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.smallPadding),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: AppTextStyles.tableHeader.copyWith(color: AppColors.white),
        ),
      ),
    );
  }

  List<Widget> _buildRows(BuildContext context, List<Subject> subjects) {
    return subjects.map((subject) {
      final isLast = subject.id == subjects.length;
      return GestureDetector(
        onTap: () => _showSubjectDetail(context, subject),
        child: Container(
          decoration: BoxDecoration(
            color: subject.id % 2 == 0
                ? AppColors.white
                : AppColors.lightGray.withOpacity(0.5),
            borderRadius: isLast
                ? BorderRadius.only(
                    bottomLeft: Radius.circular(AppSizes.borderRadius),
                    bottomRight: Radius.circular(AppSizes.borderRadius),
                  )
                : BorderRadius.zero,
          ),
          child: Row(
            children: [
              _buildDataCell(subject.id.toString(), flex: 1),
              _buildDataCell(subject.subjectName, flex: 4),
              _buildDataCell(subject.credit.toString(), flex: 2),
              _buildDataCell(subject.grade, flex: 2),
            ],
          ),
        ),
      );
    }).toList();
  }

  Widget _buildDataCell(String text, {required int flex}) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.symmetric(
            vertical: AppSizes.padding / 3, horizontal: AppSizes.smallPadding),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: AppTextStyles.tableData,
        ),
      ),
    );
  }

  Widget _buildSummary(List<Subject> subjects) {
    final totalCredits = subjects.fold<int>(0, (sum, s) => sum + s.credit);
    final totalSubjects = subjects.length;

    return Container(
      padding: EdgeInsets.all(AppSizes.padding),
      decoration: BoxDecoration(
        color: AppColors.primaryGreen,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(AppSizes.borderRadius),
          bottomRight: Radius.circular(AppSizes.borderRadius),
        ),
        border: Border.all(color: AppColors.shadowGray, width: 1.5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Total Subjects: $totalSubjects",
            style: AppTextStyles.tableHeader.copyWith(color: AppColors.white),
          ),
          Text(
            "Total Credits: $totalCredits",
            style: AppTextStyles.tableHeader.copyWith(color: AppColors.white),
          ),
        ],
      ),
    );
  }

  void _showSubjectDetail(BuildContext context, Subject subject) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(subject.subjectName),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("No.: ${subject.id}"),
              Text("Credits: ${subject.credit}"),
              Text("Grade: ${subject.grade}"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Close"),
            ),
          ],
        );
      },
    );
  }
}
