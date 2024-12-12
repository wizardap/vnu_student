import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import '../../../core/constants/constants.dart';

class OverviewCard extends StatelessWidget {
  final Map<String, int> grades;
  final double gpa;
  final int trainingPoints;
  final VoidCallback onTap;

  OverviewCard({
    required this.grades,
    required this.gpa,
    required this.trainingPoints,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Kiểm tra nếu grades rỗng
    bool hasGrades = grades.isNotEmpty;

    Map<String, double> gradesDouble =
        hasGrades ? grades.map((key, value) => MapEntry(key, value.toDouble())) : {};

    List<Color> gradeColors = [
      AppColors.pieChartGreen1,
      AppColors.pieChartGreen2,
      AppColors.pieChartGreen3,
      AppColors.pieChartGreen4,
      AppColors.pieChartGreen5,
      AppColors.pieChartGreen6,
      AppColors.pieChartGreen7,
      AppColors.pieChartGreen8,
    ];

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(AppSizes.padding),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppSizes.borderRadius),
          border: Border.all(color: AppColors.shadowGray, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowGray,
              blurRadius: AppSizes.shadowBlurRadius,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              flex: 2,
              child: hasGrades
                  ? PieChart(
                      dataMap: gradesDouble,
                      animationDuration: Duration(milliseconds: 800),
                      chartType: ChartType.disc,
                      chartRadius: MediaQuery.of(context).size.width / 3.5,
                      colorList: gradeColors,
                      chartValuesOptions: ChartValuesOptions(
                        showChartValues: false,
                      ),
                      legendOptions: LegendOptions(
                        showLegends: false,
                      ),
                    )
                  : Center(
                      child: Text(
                        "No grade data available"+grades.isNotEmpty.toString(),
                        style: AppTextStyles.tableData,
                        textAlign: TextAlign.center,
                      ),
                    ),
            ),
            SizedBox(width: AppSizes.smallPadding),
            Flexible(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "GPA: $gpa",
                    style: AppTextStyles.overviewStat,
                  ),
                  Text(
                    "Training Points: $trainingPoints",
                    style: AppTextStyles.tableData,
                  ),
                  SizedBox(height: AppSizes.smallPadding / 2),
                  if (hasGrades)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: grades.entries.map((entry) {
                        int colorIndex = grades.keys.toList().indexOf(entry.key) % gradeColors.length;
                        return Row(
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              color: gradeColors[colorIndex],
                              margin: EdgeInsets.only(right: AppSizes.smallPadding),
                            ),
                            Text(
                              "${entry.key} points: ${entry.value}",
                              style: AppTextStyles.tableData,
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
      ),
    );
  }
}
