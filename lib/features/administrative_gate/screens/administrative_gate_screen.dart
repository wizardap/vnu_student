import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vnu_student/features/administrative_gate/screens/BuildRequestStatusTile.dart';
import 'package:vnu_student/features/administrative_gate/screens/CreateScreen.dart';

class AdministrativeGateScreen extends StatefulWidget {
  _AdministrativeGateScreen createState() => _AdministrativeGateScreen();
}

class _AdministrativeGateScreen extends State<AdministrativeGateScreen> {
  String? userId;
  List<Map<String, dynamic>> inProgress = [];
  List<Map<String, dynamic>> done = [];
  void initState() {
    super.initState();
    _getCurrentUser();
  }
  void updateState() {
    setState(() {
      _fetchDataFromFirestore();
    });
  }
  Future<void> _getCurrentUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        userId = user.uid;
      });
      _fetchDataFromFirestore();
    }
  }

  Future<void> _fetchDataFromFirestore() async {
    if (userId == null) return;

    // Lấy thông báo từ Firestore
    QuerySnapshot InProgress = await FirebaseFirestore.instance
        .collection('administrative_gate')
        .where('userId', isEqualTo: userId)
        .where('status', isEqualTo: 'In progress')
        .get();

    // Lấy tin tức từ Firestore
    QuerySnapshot Done = await FirebaseFirestore.instance
        .collection('administrative_gate')
        .where('userId', isEqualTo: userId)
        .where('status', isEqualTo: 'Done')
        .get();

    setState(() {
      inProgress = InProgress.docs.map((doc) {
        return {
          "type": doc['type'],
          "reason": doc['reason'],
        };
      }).toList();
      done = Done.docs.map((doc) {
        return {
          "type": doc['type'],
          "reason": doc['reason'],
        };
      }).toList();
      print(done);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Administrative Gate',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreateScreen(userId: userId, callback: updateState),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: Row(
                  children: [
                    Icon(Icons.add, color: Color(0xFF13511C)),
                    SizedBox(width: 10),
                    Text(
                      'Create a request',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            Text(
              "Requests status",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(8.0),
                children: [
                  BuildRequestStatusTile(
                    title: 'In progress',
                    items: inProgress,
                  ),
                  const SizedBox(height: 20),
                  BuildRequestStatusTile(
                    title: 'Done',
                    items: done,
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
