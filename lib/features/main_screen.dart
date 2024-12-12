import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vnu_student/features/about/about_screen.dart';
import 'package:vnu_student/features/academic_results/screen/academic_result_screen.dart';
import 'package:vnu_student/features/administrative_gate/screens/administrative_gate_screen.dart';
import 'package:vnu_student/features/ask/screens/ask_screen.dart';
import 'package:vnu_student/features/calendar/screens/calendar_screen.dart';
import 'package:vnu_student/features/handbook/handbook_screen.dart';
import 'package:vnu_student/features/home/screens/home_screen.dart';
import 'package:vnu_student/features/user_manual/screens/user_manual_screen.dart';
import 'package:vnu_student/features/login/login_screen.dart';
import 'package:vnu_student/core/constants/constants.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  int? _previousIndex;
  bool _isMenuOpen = false;

  final List<Widget> _screens = [
    HomeScreen(),
    AcademicResultsScreen(),
    CalendarScreen(),
    AskScreen(),
    AdministrativeGateScreen(),
  ];

  void _toggleMenu() {
    setState(() {
      if (_isMenuOpen) {
        _isMenuOpen = false;
        if (_previousIndex != null) {
          _currentIndex = _previousIndex!;
          _previousIndex = null;
        }
      } else {
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
      setState(() {
        _isMenuOpen = true;
        _currentIndex = 5;
      });
    });
  }

  void _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Stack(
        children: [
          _screens[_currentIndex != 5 ? _currentIndex : _previousIndex ?? 0],
          if (_isMenuOpen)
            GestureDetector(
              onTap: _toggleMenu,
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                color: Colors.black.withOpacity(0.5),
                child: Container(
                  color: Colors.black.withOpacity(0.2),
                ),
              ),
            ),
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
                          Expanded(
                            // Thêm Expanded để giới hạn chiều rộng
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Hello, ${FirebaseAuth.instance.currentUser?.email ?? 'User'}",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow
                                      .ellipsis, // Cắt bớt nội dung dài
                                  maxLines: 1, // Chỉ hiển thị 1 dòng
                                ),
                                Text(
                                  "Welcome!",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                  overflow: TextOverflow
                                      .ellipsis, // Cắt bớt nếu quá dài
                                  maxLines: 1, // Chỉ hiển thị 1 dòng
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        padding: EdgeInsets.zero,
                        children: [
                          _buildMenuItem(
                            icon: Icons.info,
                            text: 'About',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AboutScreen()),
                              );
                            },
                          ),
                          _buildMenuItem(
                            icon: Icons.menu_book,
                            text: 'Handbook',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HandBookScreen()),
                              );
                            },
                          ),
                          _buildMenuItem(
                            icon: Icons.book,
                            text: 'User Manual',
                            onTap: _navigateToUserManual,
                          ),
                          _buildMenuItem(
                            icon: Icons.logout,
                            text: 'Logout',
                            onTap: _logout,
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
      bottomNavigationBar: AnimatedContainer(
        
        duration: Duration(milliseconds: 300),
        color: _isMenuOpen ? Colors.black.withOpacity(0.1) : Colors.white,
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          currentIndex: _isMenuOpen ? 5 : _currentIndex,
          onTap: (index) {
            if (index == 5) {
              _toggleMenu();
            } else {
              setState(() {
                _currentIndex = index;
                _isMenuOpen = false;
                _previousIndex = null;
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
          selectedItemColor: Color(0xFF13511C),
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
