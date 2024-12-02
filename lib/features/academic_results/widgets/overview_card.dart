import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import '../../../core/constants/constants.dart';

class OverviewCard extends StatelessWidget {
  final Map<String, int> grades;
  final double gpa;
  final int trainingPoints;
  final VoidCallback onTap; // Hàm được gọi khi nhấn vào OverviewCard

  OverviewCard({
    required this.grades,
    required this.gpa,
    required this.trainingPoints,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Map<String, double> gradesDouble =
        grades.map((key, value) => MapEntry(key, value.toDouble()));

    return GestureDetector(
      onTap: onTap, // Kích hoạt pop-up
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
              child: PieChart(
                dataMap: gradesDouble,
                animationDuration: Duration(milliseconds: 800),
                chartType: ChartType.disc,
                chartRadius: MediaQuery.of(context).size.width / 3.5,
                colorList: [
                  AppColors.pieChartGreen1,
                  AppColors.pieChartGreen2,
                  AppColors.pieChartGreen3,
                ],
                chartValuesOptions: ChartValuesOptions(
                  showChartValues: false,
                ),
                legendOptions: LegendOptions(
                  showLegends: false,
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: grades.entries.map((entry) {
                      return Row(
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            color: entry.key == "A+"
                                ? AppColors.pieChartGreen1
                                : entry.key == "A"
                                    ? AppColors.pieChartGreen2
                                    : AppColors.pieChartGreen3,
                            margin:
                                EdgeInsets.only(right: AppSizes.smallPadding),
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
