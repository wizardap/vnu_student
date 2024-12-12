import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:vnu_student/core/constants/constants.dart';
import 'detail_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedFilter = 0;
  String? userId;
  bool isLoading = true;
  bool isDataFetched = false;
  String? errorMessage;

  List<Map<String, dynamic>> items = [];

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  Future<void> _getCurrentUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        userId = user.uid;
      });
      if (!isDataFetched) {
        await _fetchDataFromFirestore();
      } else {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> _fetchDataFromFirestore() async {
    if (userId == null) return;

    try {
      List<Map<String, dynamic>> notifications = [];
      List<Map<String, dynamic>> news = [];

      // Fetch Notifications
      QuerySnapshot notificationSnapshot = await FirebaseFirestore.instance
          .collection('notifications')
          .where('userId', isEqualTo: userId)
          .get();

      notifications = _mapSnapshotToItems(notificationSnapshot, "Notification");

      // Fetch News
      QuerySnapshot newsSnapshot =
          await FirebaseFirestore.instance.collection('news').get();

      news = _mapSnapshotToItems(newsSnapshot, "News");

      setState(() {
        items = [...notifications, ...news];
        isLoading = false;
        isDataFetched = true;
      });
    } catch (error) {
      setState(() {
        errorMessage = error.toString();
        isLoading = false;
      });
    }
  }

  List<Map<String, dynamic>> _mapSnapshotToItems(
      QuerySnapshot snapshot, String type) {
    return snapshot.docs.map((doc) {
      Timestamp timestamp = doc['timestamp'];
      String formattedDate =
          DateFormat('yyyy-MM-dd – kk:mm').format(timestamp.toDate());

      return {
        "id": doc.id,
        "type": type,
        "title": doc['title'],
        "content": doc['content'],
        "details": doc['details'],
        "imageUrl": doc['imageUrl'],
        "timestamp": formattedDate,
        "department": doc['department'],
        "contactEmail": doc['contactEmail'],
        "contactPhone": doc['contactPhone'],
        "isRead": doc['isRead']
      };
    }).toList();
  }

  Future<void> _refreshData() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    await _fetchDataFromFirestore();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'Home',
          style: AppTextStyles.appBarTitleWhite,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          _buildAnimatedBackground(),
          isLoading
              ? Center(child: CircularProgressIndicator())
              : errorMessage != null
                  ? Center(child: Text('Error: $errorMessage'))
                  : Column(
                      children: [
                        SizedBox(height: kToolbarHeight + 30),
                        _buildCarouselSlider(),
                        SizedBox(height: 15),
                        _buildCategoryTabs(),
                        SizedBox(height: 10),
                        Expanded(child: _buildContentList()),
                      ],
                    ),
        ],
      ),
    );
  }

  Widget _buildAnimatedBackground() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.blueAccent.shade200, Colors.greenAccent.shade200],
        ),
      ),
    );
  }

  Widget _buildCarouselSlider() {
    if (items.isEmpty) {
      return SizedBox(
        height: 150,
        child: Center(
          child: Text(
            'No items available',
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
      );
    }

    return CarouselSlider(
      items: items.map((item) => _buildCarouselItem(item)).toList(),
      options: CarouselOptions(
        height: 150,
        autoPlay: true,
        enlargeCenterPage: true,
        viewportFraction: 0.85,
      ),
    );
  }

  Widget _buildCarouselItem(Map<String, dynamic> item) {
    return GestureDetector(
      onTap: () => _navigateToDetail(item),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          image: DecorationImage(
            image: NetworkImage(item['imageUrl']),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(
              colors: [Colors.black45, Colors.transparent],
              begin: Alignment.bottomCenter,
              end: Alignment.center,
            ),
          ),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                item['title'],
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildFilterButton("All", 0),
          _buildFilterButton("News", 1),
          _buildFilterButton("Notifications", 2),
        ],
      ),
    );
  }

  Widget _buildFilterButton(String title, int index) {
    bool isSelected = _selectedFilter == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = index;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        decoration: BoxDecoration(
          color: isSelected ? Colors.green : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: isSelected
              ? [BoxShadow(color: Colors.green.withOpacity(0.5), blurRadius: 8)]
              : [],
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Future<void> _markAsRead(String id, String type) async {
    String collection = type == "Notification" ? 'notifications' : 'news';

    await FirebaseFirestore.instance
        .collection(collection)
        .doc(id)
        .update({'isRead': true});

    setState(() {
      items.firstWhere((item) => item['id'] == id)['isRead'] = true;
    });
  }

  Widget _buildContentList() {
    List<Map<String, dynamic>> filteredItems = _selectedFilter == 0
        ? items
        : items
            .where((item) =>
                item["type"] ==
                (_selectedFilter == 1 ? "News" : "Notification"))
            .toList();

    return RefreshIndicator(
      onRefresh: _refreshData,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 15),
        itemCount: filteredItems.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            elevation: 3,
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: filteredItems[index]['imageUrl'] != null
                    ? NetworkImage(filteredItems[index]['imageUrl'])
                    : AssetImage('assets/images/default_image.png')
                        as ImageProvider,
                radius: 24,
              ),
              title: Text(
                filteredItems[index]['title'],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: filteredItems[index]['isRead']
                      ? Colors.grey
                      : Colors.black,
                ),
              ),
              subtitle: Text(filteredItems[index]['content']),
              trailing: filteredItems[index]['isRead']
                  ? Icon(Icons.check_circle, color: Colors.green)
                  : Icon(Icons.circle, color: Colors.grey),
              onTap: () {
                _markAsRead(
                    filteredItems[index]['id'], filteredItems[index]['type']);
                _navigateToDetail(filteredItems[index]);
              },
            ),
          );
        },
      ),
    );
  }

  void _navigateToDetail(Map<String, dynamic> item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailScreen(
          title: item['title'],
          content: item['content'],
          details: item['details'],
          imageUrl: item['imageUrl'],
          timestamp: item['timestamp'],
          department: item['department'],
          contactEmail: item['contactEmail'],
          contactPhone: item['contactPhone'],
        ),
      ),
    );
  }
}
