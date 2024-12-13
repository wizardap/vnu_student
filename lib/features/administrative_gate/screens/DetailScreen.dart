import 'package:flutter/material.dart';
import 'package:vnu_student/core/constants/constants.dart';

class DetailScreen extends StatelessWidget {
  final Map<String, dynamic> items;

  DetailScreen({Key? key, required this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Show Detail',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow("Status", items['status']),
            const SizedBox(height: 5),
            _buildInfoRow("Type", items['type']),
            const SizedBox(height: 5),
            _buildInfoRow("Reason", items['reason']),
            const SizedBox(height: 5),
            _buildInfoRow("Quantity of The Vietnamese Version", items['vietnamese']),
            const SizedBox(height: 5),
            _buildInfoRow("Quantity of The English Version", items['english'] ?? 'N/A'),
            const SizedBox(height: 5),
            Text(
              "Files:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            // This SizedBox here will take up the remaining space
            Expanded(
              child: SizedBox(
                height: double.infinity, // Makes the SizedBox take up all the available space
                child: ListView.builder(
                  itemCount: items['file'].length,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> file = items['file'][index];
                    return Card(
                      color: Colors.grey.withOpacity(0.3),
                      elevation: 0,
                      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: Icon(Icons.insert_drive_file, color: AppColors.primaryGreen),
                        title: Text(file['file_name'], style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        subtitle: Text('${(file['file_size'] / 1024).toStringAsFixed(2)} KB', style: TextStyle(fontSize: 14)),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // A helper function to create a row for each key-value pair
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(
            "$label: ",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          Expanded(
            child: Text(
              value ?? 'N/A',
              style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
