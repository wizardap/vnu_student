import 'package:flutter/material.dart';

// Màu sắc
class AppColors {
  static const Color backgroundColor = Colors.white;
  static const Color primaryGreen = Color(0xFF13511C); // Màu xanh header bảng
  static const Color lightGray = Color(0xFFD9D9D9); // Màu xám nhạt
  static const Color shadowGray = Colors.black12; // Màu bóng mờ
  static const Color textBlack = Colors.black87; // Màu chữ chính
  static const Color textWhite = Colors.white; // Màu chữ chính
  static const Color white = Colors.white; // Màu trắng
  static const Color pieChartGreen1 = Color(0xCC0C7623); // Màu #0C7623, 80%
  static const Color pieChartGreen2 = Color(0xCC32A44B); // Màu #32A44B, 80%
  static const Color pieChartGreen3 = Color(0xCC53C26B); // Màu #53C26B, 80%
  static const Color pieChartGreen4 = Color(0xCC74D28B); // Màu #74D28B, 80%
  static const Color pieChartGreen5 = Color(0xCC95E2AB); // Màu #95E2AB, 80%
  static const Color pieChartGreen6 = Color(0xCCA6F2BB); // Màu #A6F2BB, 80%
  static const Color pieChartGreen7 = Color(0xCCB7F2CB); // Màu #B7F2CB, 80%
  static const Color pieChartGreen8 = Color(0xCCD8F2DB); // Màu #D8F2DB, 80%
  static const Color iconGray = Colors.grey; // Màu biểu tượng xám
  static const Color primaryButtonColor = Color(0xDCAEE8);
}

// Font chữ
class AppTextStyles {
  static const TextStyle appBarTitle = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.bold,
    color: AppColors.textBlack,
  );
  static const TextStyle appBarTitleWhite = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.bold,
    color: AppColors.textWhite,
  );

  static const TextStyle header = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.textBlack,
  );

  static const TextStyle subHeader = TextStyle(
    fontSize: 16,
    color: Colors.grey,
  );

  static const TextStyle tableHeader = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
  );

  static const TextStyle tableData = TextStyle(
    fontSize: 14,
    color: AppColors.textBlack,
  );

  static const TextStyle overviewStat = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle dropdownItem = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.textBlack,
  );

  static const TextStyle notificationTitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.textBlack,
  );

  static const TextStyle notificationSubtitle = TextStyle(
    fontSize: 14,
    color: Colors.grey,
  );

  static const TextStyle tabSelected = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
  );

  static const TextStyle tabUnselected = TextStyle(
    fontSize: 14,
    color: AppColors.textBlack,
  );

  static const TextStyle searchHint = TextStyle(
    fontSize: 16,
    color: AppColors.iconGray,
  );
  static const TextStyle buttonText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: AppColors.textBlack,
  );
}

// Kích thước & khoảng cách
class AppSizes {
  static const double borderRadius = 12.0;
  static const double buttonBorderRadius = 12.0;
  static const double padding = 16.0;
  static const double smallPadding = 8.0;
  static const double shadowBlurRadius = 8.0;
  static const double cardElevation = 4.0;
}

class ButtonStyles {
  static ButtonStyle get primaryStyle {
    return ElevatedButton.styleFrom(
      backgroundColor: AppColors.lightGray,
      fixedSize: const Size(double.infinity, 50),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.buttonBorderRadius),
      ),
      padding: const EdgeInsets.all(AppSizes.padding),
      iconColor: AppColors.textBlack,
    );
  }
}
