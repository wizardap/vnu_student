import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'detail_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedFilter = 0;
  int _currentCarouselIndex = 0;
  String? userId;

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
      _fetchDataFromFirestore();
    }
  }

  Future<void> _fetchDataFromFirestore() async {
    if (userId == null) return;

    List<Map<String, dynamic>> notifications = [];
    List<Map<String, dynamic>> news = [];

    // Lấy thông báo từ Firestore
    QuerySnapshot notificationSnapshot = await FirebaseFirestore.instance
        .collection('notifications')
        .where('userId', isEqualTo: userId)
        .get();

    notifications = notificationSnapshot.docs.map((doc) {
      return {
        "id": doc.id,
        "type": "Notification",
        "title": doc['title'],
        "content": doc['content'],
        "image": doc['imageUrl'],
        "isRead": doc['isRead']
      };
    }).toList();

    // Lấy tin tức từ Firestore
    QuerySnapshot newsSnapshot =
        await FirebaseFirestore.instance.collection('news').get();

    news = newsSnapshot.docs.map((doc) {
      return {
        "id": doc.id,
        "type": "News",
        "title": doc['title'],
        "content": doc['content'],
        "image": doc['imageUrl'],
        "isRead": doc['isRead']
      };
    }).toList();

    setState(() {
      items = [...notifications, ...news];
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'Home',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          _buildAnimatedBackground(),
          Column(
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
    return CarouselSlider(
      items: items.map((item) {
        return GestureDetector(
          onTap: () {
            _markAsRead(item['id'], item['type']);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailScreen(
                  title: item['title'],
                  content: item['content'],
                  details: item['details'], // Truyền thêm chi tiết
                  imageUrl: item['image'], // Truyền đường dẫn ảnh
                  author: item['author'], // Truyền tác giả
                  attachments:
                      item['attachments'], // Truyền danh sách file đính kèm
                ),
              ),
            );
          },
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              image: DecorationImage(
                image: NetworkImage(item['image']),
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
      }).toList(),
      options: CarouselOptions(
        height: 150,
        autoPlay: true,
        enlargeCenterPage: true,
        viewportFraction: 0.85,
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

  Widget _buildContentList() {
    List<Map<String, dynamic>> filteredItems = _selectedFilter == 0
        ? items
        : items
            .where((item) =>
                item["type"] ==
                (_selectedFilter == 1 ? "News" : "Notification"))
            .toList();

    return ListView.builder(
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
              backgroundImage: NetworkImage(filteredItems[index]['image']),
              radius: 24,
            ),
            title: Text(
              filteredItems[index]['title'],
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color:
                    filteredItems[index]['isRead'] ? Colors.grey : Colors.black,
              ),
            ),
            subtitle: Text(filteredItems[index]['content']),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              _markAsRead(
                  filteredItems[index]['id'], filteredItems[index]['type']);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailScreen(
                    title: filteredItems[index]['title'],
                    content: filteredItems[index]['content'],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
