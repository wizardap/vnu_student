import 'package:flutter/material.dart';
import 'package:vnu_student/core/constants/constants.dart';

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About', style: AppTextStyles.appBarTitle),
        backgroundColor: AppColors.backgroundColor,
      ),
      body: Container(
        color: AppColors.backgroundColor,
        padding: const EdgeInsets.all(AppSizes.padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('App Information'),
            SizedBox(height: AppSizes.smallPadding),
            _buildInfoTile('App Name', 'Student Management App'),
            _buildInfoTile('Version', '1.0.0'),
            _buildInfoTile('Developer', 'VNU Student Team'),

            Divider(height: AppSizes.padding * 2, color: AppColors.shadowGray),

            _buildSectionTitle('Contact Us'),
            SizedBox(height: AppSizes.smallPadding),
            _buildInfoTile('Email', 'support@example.com'),
            _buildInfoTile('Phone', '+84 123 456 789'),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTextStyles.header.copyWith(fontSize: 20),
    );
  }

  Widget _buildInfoTile(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.smallPadding / 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.tableData),
          Text(value, style: AppTextStyles.tableData.copyWith(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
