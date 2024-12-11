import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:vnu_student/features/administrative_gate/screens/RequestSelection.dart';

class CreateScreen extends StatefulWidget {
  @override
  _CreateScreenState createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  List<PlatformFile> selectedFiles = [];
  final TextEditingController vietnamese = TextEditingController(text: '0');
  final TextEditingController english = TextEditingController(text: '0');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("Create Request", style: TextStyle(color: Colors.black)),
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
          actions: [
            // Nút Save với kích thước nhỏ hơn
            GestureDetector(
              onTap: () async {
                // Logic khi bấm nút Save
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                    vertical: 6, horizontal: 12), // Padding nhỏ hơn
                decoration: BoxDecoration(
                  color: Color(0xFF13511C),
                  borderRadius:
                      BorderRadius.circular(6), // BorderRadius nhỏ hơn
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2), // Shadow nhẹ hơn
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.save,
                        color: Colors.white, size: 18), // Icon nhỏ hơn
                    SizedBox(width: 6), // Khoảng cách nhỏ hơn giữa icon và chữ
                    Text(
                      'Save',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14), // FontSize nhỏ hơn
                    ),
                  ],
                ),
              ),
            ),
            // Bạn có thể thêm các nút khác ở đây nếu cần
            SizedBox(width: 16), // Khoảng cách bên phải nút Save
          ],
        ),
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Dropdown ví dụ
                RequestSelection(),
                const SizedBox(height: 15),
                TextField(
                  onSubmitted: (text) {
                    print('User entered: $text');
                  },
                  decoration: InputDecoration(
                    labelText: 'Lý do',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // TextField 1

                    Expanded(
                      child: TextField(
                        controller: vietnamese,
                        decoration: InputDecoration(
                          labelText: 'Số bản tiếng Việt',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10), // Khoảng cách giữa hai TextField
                    // TextField 2
                    Expanded(
                      child: TextField(
                        controller: english,
                        decoration: InputDecoration(
                          labelText: 'Số bản tiếng Anh',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                // Nút chọn file
                GestureDetector(
                  onTap: () async {
                    FilePickerResult? result =
                        await FilePicker.platform.pickFiles(
                      allowMultiple: true, // Cho phép chọn nhiều file
                    );

                    if (result != null) {
                      // Cập nhật danh sách file vào trạng thái
                      setState(() {
                        selectedFiles = result.files;
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('No files selected')),
                      );
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                    decoration: BoxDecoration(
                      color: Color(0xFF13511C),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.upload_file, color: Colors.white),
                        SizedBox(width: 10),
                        Text(
                          'Upload Document',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                // Hiển thị danh sách file được chọn
                Expanded(
                  child: ListView.builder(
                    itemCount: selectedFiles.length,
                    itemBuilder: (context, index) {
                      final file = selectedFiles[index];
                      return Card(
                        margin:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        child: ListTile(
                          leading:
                              Icon(Icons.insert_drive_file, color: Colors.blue),
                          title: Text(file.name),
                          subtitle: Text(
                              '${(file.size / 1024).toStringAsFixed(2)} KB'),
                          trailing: IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              setState(() {
                                selectedFiles.removeAt(index);
                              });
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            )));
  }
}
