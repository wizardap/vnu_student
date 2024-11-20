import 'package:flutter/material.dart';
import 'package:vnu_student/core/constants/constants.dart';

class AcademicTranscriptTable extends StatelessWidget {
  final List<Map<String, dynamic>> subjects;

  AcademicTranscriptTable({required this.subjects});

  @override
  Widget build(BuildContext context) {
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
                ..._buildRows(),
                _buildSummary(),
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
          _buildHeaderCell("STT", flex: 2),
          _buildHeaderCell("Tên môn học", flex: 4),
          _buildHeaderCell("Số tín chỉ", flex: 2),
          _buildHeaderCell("Điểm chữ", flex: 2),
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
          style: AppTextStyles.tableHeader,
        ),
      ),
    );
  }

  List<Widget> _buildRows() {
    return subjects.asMap().entries.map((entry) {
      final isLast = entry.key == subjects.length - 1;
      return GestureDetector(
        onTap: () {
          // Logic khi nhấn vào dòng (nếu cần)
        },
        child: Container(
          decoration: BoxDecoration(
            color: entry.key % 2 == 0
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
              _buildDataCell(entry.value["stt"].toString(), flex: 2),
              _buildDataCell(entry.value["name"], flex: 4),
              _buildDataCell(entry.value["credits"].toString(), flex: 2),
              _buildDataCell(entry.value["grade"], flex: 2),
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

  Widget _buildSummary() {
    final totalCredits = subjects.fold<int>(0, (sum, s) => sum + (s["credits"] as int));
    final totalSubjects = subjects.length;

    return Container(
      padding: EdgeInsets.all(AppSizes.padding),
      decoration: BoxDecoration(
        color: AppColors.lightGray.withOpacity(0.2),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(AppSizes.borderRadius),
          bottomRight: Radius.circular(AppSizes.borderRadius),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Total Subjects: $totalSubjects",
            style: AppTextStyles.tableData,
          ),
          Text(
            "Total Credits: $totalCredits",
            style: AppTextStyles.tableData,
          ),
        ],
      ),
    );
  }
}

