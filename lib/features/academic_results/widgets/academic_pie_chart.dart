import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:vnu_student/core/constants/constants.dart';

class AcademicPieChart extends StatelessWidget {
  final Map<String, int> grades;

  AcademicPieChart({required this.grades});

  @override
  Widget build(BuildContext context) {
    // Chuyển đổi Map<String, int> sang Map<String, double>
    Map<String, double> dataMap =
        grades.map((key, value) => MapEntry(key, value.toDouble()));

    return PieChart(
      dataMap: dataMap,
      animationDuration: Duration(milliseconds: 800),
      chartType: ChartType.disc,
      chartRadius: MediaQuery.of(context).size.width / 3.5,
      colorList: _getColorList(),
      chartValuesOptions: ChartValuesOptions(
        showChartValues: true, // Hiển thị giá trị phần trăm
        showChartValuesInPercentage: true,
        chartValueStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      legendOptions: LegendOptions(
        showLegends: true, // Hiển thị chú thích
        legendPosition: LegendPosition.bottom,
      ),
    );
  }

  List<Color> _getColorList() {
    return [
      AppColors.pieChartGreen1,
      AppColors.pieChartGreen2,
      AppColors.pieChartGreen3,
      AppColors.pieChartGreen4,
      AppColors.pieChartGreen5,
      AppColors.pieChartGreen6,
      AppColors.pieChartGreen7,
      AppColors.pieChartGreen8,
    ];
  }
}
