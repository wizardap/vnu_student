import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:vnu_student/core/constants/constants.dart';


class AcademicPieChart extends StatelessWidget {
  final Map<String, double> grades;

  AcademicPieChart({required this.grades});

  @override
  Widget build(BuildContext context) {
    return PieChart(
      dataMap: grades,
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
    );
  }
}
