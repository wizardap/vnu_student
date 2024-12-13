import 'package:flutter/material.dart';
import 'package:vnu_student/core/constants/constants.dart';

class UserManualScreen extends StatefulWidget {
  @override
  _UserManualScreenState createState() => _UserManualScreenState();
}

class _UserManualScreenState extends State<UserManualScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _manualPages = [
    {
      'image': 'lib/assets/images/user_manual1.png',
      'title': 'Welcome to the app',
      'description': 'Explore features easily and conveniently.',
    },
    {
      'image': 'lib/assets/images/user_manual2.png',
      'title': 'Academic Results',
      'description': 'View academic results by semester, details of each subject.',
    },
    {
      'image': 'lib/assets/images/user_manual3.png',
      'title': 'Exam Schedule Management',
      'description': 'Track exam schedules and important events quickly.',
    },
    {
      'image': 'lib/assets/images/user_manual4.png',
      'title': 'Frequently Asked Questions',
      'description': 'Ask and follow up on questions sent to the university.',
    },
    {
      'image': 'lib/assets/images/user_manual5.png',
      'title': 'Administrative Portal',
      'description': 'Create and track administrative requests sent to the university.',
    },
  ];

  void _nextPage() {
    if (_currentPage < _manualPages.length - 1) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _finishManual();
    }
  }

  void _finishManual() {
    Navigator.pop(context); // Go back to the previous screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Stack(
        children: [
          // PageView displaying each guide step
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: _manualPages.length,
            itemBuilder: (context, index) {
              final page = _manualPages[index];
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Image illustration
                    Container(
  decoration: BoxDecoration(
    border: Border.all(color: Colors.grey.withOpacity(0.5), width: 1), // Thêm viền nếu muốn
  ),
  child: Image.asset(
    page['image']!,
    height: 500,
    fit: BoxFit.contain,
  ),
),

                    SizedBox(height: 20),

                    // Title
                    Text(
                      page['title']!,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryGreen,
                      ),
                    ),
                    SizedBox(height: 10),

                    // Description
                    Text(
                      page['description']!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          // "Skip" button
          if (_currentPage < _manualPages.length - 1)
            Positioned(
              top: 40,
              right: 20,
              child: GestureDetector(
                onTap: _finishManual,
                child: Text(
                  'Skip',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.primaryGreen,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

          // Navigation between steps
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Column(
              children: [
                // Position indicator (dots)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _manualPages.length,
                    (index) => AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      margin: EdgeInsets.symmetric(horizontal: 4),
                      width: _currentPage == index ? 12 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color:
                            _currentPage == index ? AppColors.primaryGreen : Colors.grey,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),

                // Next/Finish button
                ElevatedButton(
                  onPressed: _nextPage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF13511C), // Màu nền xanh cho nút Submit
                  ),
                  child: Text(
                    _currentPage == _manualPages.length - 1
                        ? 'Finish'
                        : 'Continue',
                    style: TextStyle(fontSize: 16, color: Colors.white, // Chữ trắng trên nền xanh
                fontWeight: FontWeight.bold,),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
