import 'package:flutter/material.dart';
import 'package:vnu_student/features/academic_results/screen/academic_results_screen.dart';
import 'package:vnu_student/features/home/screens/home_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    AcademicResultsScreen(),
    CalendarScreen(),
    AskScreen(),
    AdministrativeGateScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        showSelectedLabels: false, // Ẩn label khi được chọn
        showUnselectedLabels: false, // Ẩn label khi không được chọn
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
        ],
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}





class CalendarScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Calendar Screen'));
  }
}

class AskScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Ask Screen'));
  }
}

class AdministrativeGateScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Administrative Gate Screen'));
  }
}
