import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:vnu_student/features/user_manual/screens/user_manual_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  int? _previousIndex; // Lưu trạng thái màn hình trước khi mở menu
  bool _isMenuOpen = false;

  final List<Widget> _screens = [
    Center(child: Text('Home Screen')),
    Center(child: Text('Academic Results Screen')),
    Center(child: Text('Calendar Screen')),
    Center(child: Text('Ask Screen')),
    Center(child: Text('Administrative Gate Screen')),
  ];

  void _toggleMenu() {
    setState(() {
      if (_isMenuOpen) {
        // Đóng menu và quay lại màn hình trước đó
        _isMenuOpen = false;
        if (_previousIndex != null) {
          _currentIndex = _previousIndex!;
          _previousIndex = null; // Xóa trạng thái sau khi quay lại
        }
      } else {
        // Mở menu và lưu trạng thái màn hình hiện tại
        _previousIndex = _currentIndex;
        _isMenuOpen = true;
        _currentIndex = 5; // Màn hình menu
      }
    });
  }

  void _navigateToUserManual() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UserManualScreen()),
    ).then((_) {
      // Quay lại menu khi đóng màn hình hướng dẫn
      setState(() {
        _isMenuOpen = true;
        _currentIndex = 5; // Đặt lại menu là màn hình hiện tại
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      body: Stack(
        children: [
          // Nội dung chính
          _screens[_currentIndex != 5 ? _currentIndex : _previousIndex ?? 0],

          // Overlay làm mờ
          if (_isMenuOpen)
            GestureDetector(
              onTap: _toggleMenu,
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                color: Colors.black.withOpacity(0.5),
                child: Container(
                  color: Colors.black.withOpacity(0.2), // Hiệu ứng đơn giản hơn
                ),
              ),
            ),

          // Menu trượt từ phải
          AnimatedPositioned(
            duration: Duration(milliseconds: 400),
            curve: Curves.fastOutSlowIn,
            right: _isMenuOpen ? 0 : -screenWidth * 0.75,
            top: statusBarHeight,
            bottom: 0,
            width: screenWidth * 0.75,
            child: Material(
              elevation: 8,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                bottomLeft: Radius.circular(20),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header menu
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.green, Colors.lightGreen],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                        ),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Icon(Icons.person, color: Colors.green),
                          ),
                          SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Hello, User",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "user@example.com",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        padding: EdgeInsets.zero,
                        children: [
                          _buildMenuItem(
                            icon: Icons.settings,
                            text: 'Settings',
                            onTap: _toggleMenu,
                          ),
                          _buildMenuItem(
                            icon: Icons.info,
                            text: 'About',
                            onTap: _toggleMenu,
                          ),
                          _buildMenuItem(
                            icon: Icons.book,
                            text: 'User Manual',
                            onTap: () {
                              _navigateToUserManual();
                            },
                          ),
                          _buildMenuItem(
                            icon: Icons.logout,
                            text: 'Logout',
                            onTap: _toggleMenu,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),

      // Thanh điều hướng
      bottomNavigationBar: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        color: _isMenuOpen ? Colors.black.withOpacity(0.1) : Colors.white,
        child: BottomNavigationBar(
          currentIndex: _isMenuOpen ? 5 : _currentIndex,
          onTap: (index) {
            if (index == 5) {
              _toggleMenu();
            } else {
              setState(() {
                _currentIndex = index;
                _isMenuOpen = false;
                _previousIndex = null; // Xóa trạng thái nếu đổi màn hình
              });
            }
          },
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.school),
              label: 'Academic Results',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today),
              label: 'Calendar',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.question_answer),
              label: 'Ask',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.admin_panel_settings),
              label: 'Admin Gate',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.menu),
              label: 'Menu',
            ),
          ],
          selectedItemColor: Colors.green,
          unselectedItemColor: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.green),
      title: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
    );
  }
}
