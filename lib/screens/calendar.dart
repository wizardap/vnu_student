import 'package:flutter/material.dart';
import '../core/constants/constants.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final ScrollController _horizontalScrollController = ScrollController();
  final ScrollController _horizontalHeaderScrollController = ScrollController();
  DateTime _selectedDate = DateTime.now();
  DateTime curMonday = DateTime.now(); // Ngày đầu tuần hiện tại
  final double hourCellHeight = 60; // Chiều cao mỗi ô giờ
  final double dayCellWidth = 120; // Chiều rộng mỗi ô ngày
  final List<String> daysOfWeek = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday"
  ];
  final List<String> monthsOfYear = [
    "None",
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];

  // Dữ liệu sự kiện (dayIndex, startHour, duration)
  List<Map<String, dynamic>> events = [
    {
      'dayIndex': 2,
      'startHour': 10,
      'duration': 2,
      'headerValue': "Sự kiện 1"
    }, // Event trên Wednesday
    {
      'dayIndex': 4,
      'startHour': 15,
      'duration': 1,
      'headerValue': "Sự kiện 2"
    }, // Event trên Friday
    {
      'dayIndex': 1,
      'startHour': 8,
      'duration': 3,
      'headerValue': "Sự kiện 3"
    }, // Event trên Tuesday
  ];

  @override
  void initState() {
    super.initState();
    _horizontalScrollController.addListener(() {
      if (_horizontalHeaderScrollController.offset !=
          _horizontalScrollController.offset) {
        _horizontalHeaderScrollController
            .jumpTo(_horizontalScrollController.offset);
      }
    });
  }

  @override
  void dispose() {
    _horizontalScrollController.dispose();
    _horizontalHeaderScrollController.dispose();
    super.dispose();
  }

  DateTime getStartOfWeek(DateTime date) {
    // Tính toán ngày đầu tuần (thứ Hai)
    int difference = date.weekday - DateTime.monday;
    return date.subtract(Duration(days: difference));
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        curMonday = getStartOfWeek(_selectedDate);
      });
    }
  }

  // Lấy ngày của một ngày trong tuần
  int getDay(int dayIndex, DateTime curMonday) {
    return curMonday.add(Duration(days: dayIndex)).day;
  }

  // Lấy tháng của một ngày trong tuần
  int getMonth(int dayIndex, DateTime curMonday) {
    return curMonday.add(Duration(days: dayIndex)).month;
  }

  // Lấy năm của một ngày trong tuần
  int getYear(int dayIndex, DateTime curMonday) {
    return curMonday.add(Duration(days: dayIndex)).year;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
        titleTextStyle: AppTextStyles.appBarTitle,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              _buildSetUpParamHeader(),
              _buildHeader(daysOfWeek, dayCellWidth),
              _buildCalendarContent(
                  hourCellHeight, dayCellWidth, daysOfWeek, events),
            ],
          ),
          Positioned(
            top: 10,
            left: 10,
            child: ElevatedButton(
              onPressed: () => _selectDate(context),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(10),
              ),
              child: Text(
                curMonday.year == getYear(6, curMonday) ?
                (curMonday.month == getMonth(6, curMonday) ?
                "${monthsOfYear[curMonday.month]}, ${curMonday.year}" :
                "${monthsOfYear[curMonday.month]} - ${monthsOfYear[getMonth(6, curMonday)]}, ${curMonday.year}") : 
                "${monthsOfYear[curMonday.month]}, ${curMonday.year} - ${monthsOfYear[getMonth(6, curMonday)]}, ${getYear(6, curMonday)}",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(List<String> daysOfWeek, double dayCellWidth) {
    return SizedBox(
      height: 80,
      child: Row(
        children: [
          Container(
            width: 60, // Ô trống ở góc trên bên trái
            height: 80,
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              controller: _horizontalHeaderScrollController,
              child: Row(
                children: List.generate(daysOfWeek.length, (index) {
                  return Container(
                    width: dayCellWidth,
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primaryGreen,
                      borderRadius:
                          BorderRadius.circular(AppSizes.borderRadius),
                    ),
                    child: Center(
                      child: Text(
                        '${daysOfWeek[index]}\n${getDay(index, curMonday)}',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.tableHeader,
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarContent(double hourCellHeight, double dayCellWidth,
      List<String> daysOfWeek, List<Map<String, dynamic>> events) {
    return Expanded(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHourColumn(hourCellHeight),
            _buildEventContent(
                hourCellHeight, dayCellWidth, daysOfWeek, events),
          ],
        ),
      ),
    );
  }

  Widget _buildHourColumn(double hourCellHeight) {
    return Column(
      children: List.generate(24, (index) {
        return Container(
          height: hourCellHeight,
          width: 60,
          alignment: Alignment.center,
          child: Text(
            '${index.toString().padLeft(2, '0')}:00',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        );
      }),
    );
  }

  Widget _buildEventContent(double hourCellHeight, double dayCellWidth,
      List<String> daysOfWeek, List<Map<String, dynamic>> events) {
    return Expanded(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        controller: _horizontalScrollController,
        child: Stack(
          children: [
            Row(
              children: List.generate(daysOfWeek.length, (dayIndex) {
                return Container(
                  width: dayCellWidth,
                  height: hourCellHeight * 24 + hourCellHeight / 2.0,
                  margin: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: AppColors.iconGray.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                  ),
                );
              }),
            ),
            for (var event in events)
              Positioned(
                top: event['startHour'] * hourCellHeight + hourCellHeight / 2.0,
                left: event['dayIndex'] * (dayCellWidth + 10) + 10,
                child: Container(
                  width: dayCellWidth - 10,
                  height: event['duration'] * hourCellHeight,
                  decoration: BoxDecoration(
                    color: AppColors.pieChartGreen3.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                  ),
                  child: Center(
                    child: Text(
                      event['headerValue'],
                      style: TextStyle(
                        color: AppColors.textBlack,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // this is to place chosen date button
  Widget _buildSetUpParamHeader() {
    return Container(
      width: 60,
      height: 80,
      color: Theme.of(context).scaffoldBackgroundColor,
    );
  }
}
