import 'package:flutter/material.dart';

class DetailScreen extends StatelessWidget {
  final String title;
  final String content;
  final String? details;
  final String? imageUrl;
  final String? author;
  final List<String>? attachments;

  DetailScreen({
    required this.title,
    required this.content,
    this.details,
    this.imageUrl,
    this.author,
    this.attachments,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            if (imageUrl != null)
              Image.network(imageUrl!, height: 200, fit: BoxFit.cover),
            SizedBox(height: 10),
            Text(title, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text(content, style: TextStyle(fontSize: 16)),
            if (details != null) ...[
              SizedBox(height: 10),
              Text(details!, style: TextStyle(fontSize: 14, color: Colors.grey)),
            ],
            if (author != null) ...[
              SizedBox(height: 10),
              Text("Author: $author", style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic)),
            ],
            if (attachments != null && attachments!.isNotEmpty) ...[
              SizedBox(height: 10),
              Text("Attachments:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ...attachments!.map((file) => ListTile(
                    title: Text(file),
                    leading: Icon(Icons.attach_file),
                  )),
            ],
          ],
        ),
      ),
    );
  }
}
