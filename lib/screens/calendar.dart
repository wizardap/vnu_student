import 'dart:math';

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
    // "January",
    // "February",
    // "March",
    // "April",
    // "May",
    // "June",
    // "July",
    // "August",
    // "September",
    // "October",
    // "November",
    // "December"
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec"
  ];

  // Dữ liệu sự kiện (dayIndex, startHour, duration)
  final List<Map<String, dynamic>> sampleEvents = [
    {
      'date': DateTime(2024, 11, 27),
      'startHour': 10,
      'duration': 2,
      'headerValue': "Sự kiện 1",
      'place' : "G2"
    }, // Event trên Wednesday
    {
      'date': DateTime(2024, 11, 29),
      'startHour': 15,
      'duration': 1,
      'headerValue': "Sự kiện 2",
      'place' : "G3"
    }, // Event trên Friday
    {
      'date': DateTime(2024, 12, 06),
      'startHour': 8,
      'duration': 3,
      'headerValue': "Sự kiện 3",
      'place' : "GĐ2"
    }, // Event trên // Event trên Friday
    {
      'date': DateTime(2024, 12, 05),
      'startHour': 8,
      'duration': 3,
      'headerValue': "Sự kiện 4",
      'place' : "GĐ3"
    }, // Tuesday
    {
      'date': DateTime(2024, 11, 30),
      'startHour': 8,
      'duration': 3,
      'headerValue': "Sự kiện 5",
      'place' : "GĐ4"
    }, // Tuesd
  ];

  List<Map<String, dynamic>> events = [];

  DateTime _selectedDate = DateTime.now();
  DateTime curMonday = DateTime.now(); // Ngày đầu tuần hiện tại

  @override
  void initState() {
    super.initState();
    refreshCalendar();
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

  // Cập nhật dữ liệu tuần mỗi khi thay đổi xảy ra
  void refreshCalendar() {
    curMonday = getStartOfWeek(_selectedDate);
    getEventOccurInThisWeek();
  }

  // Lấy các sự kiện xảy ra trong tuần
  void getEventOccurInThisWeek() {
    events = [];
    for (var event in sampleEvents) {
      if (event['date'].isAfter(curMonday.subtract(const Duration(days: 1))) &&
          event['date'].isBefore(curMonday.add(const Duration(days: 7)))) {
        events.add(event);
      }
    }
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
        refreshCalendar();
      });
    }
  }

  void _previousWeek() {
    setState(() {
      _selectedDate = _selectedDate.subtract(const Duration(days: 7));
      curMonday = curMonday.subtract(const Duration(days: 7));
      refreshCalendar();
    });
  }

  void _nextWeek() {
    setState(() {
      _selectedDate = _selectedDate.add(const Duration(days: 7));
      curMonday = curMonday.add(const Duration(days: 7));
      refreshCalendar();
    });
  }

  // Lấy chỉ số ngày trong tuần của một ngày
  // Ví dụ: Monday -> 1, Tuesday -> 2, ..., Sunday -> 7
  int getDayIndex(DateTime date) {
    return date.difference(curMonday).inDays + 1;
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

  List<Widget> getEventWidget() {
    List<Widget> eventWidgets = [];

    for (var event in events) {
      eventWidgets.add(
        Positioned(
          top: event['startHour'] * hourCellHeight + hourCellHeight / 2.0,
          left: getDayIndex(event['date']) * (dayCellWidth + 10) + 10,
          child: GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('${event['headerValue']}'),
                    content: Text('Thời gian bắt đầu: ${event['startHour']}:00\nThời lượng: ${event['duration']} giờ\nĐịa điểm: ${event['place']}'),
                    actions: <Widget>[
                      TextButton(
                        child: Text('Close'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
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
                  style: AppTextStyles.tableData,
                ),
              ),
            ),
          ),
        )
      );
    }

    return eventWidgets;
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
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: () => _previousWeek(),
                  style: ButtonStyles.primaryStyle,
                  child: const Icon(Icons.arrow_back),
                ),
                const SizedBox(width: AppSizes.smallPadding),
                ElevatedButton( 
                  onPressed: () => _nextWeek(),
                  style: ButtonStyles.primaryStyle,
                  child: const Icon(Icons.arrow_forward), 
                ),
                const SizedBox(width: AppSizes.smallPadding),
                ElevatedButton(
                  onPressed: () => _selectDate(context),
                  style: ButtonStyles.primaryStyle,
                  child: Text(
                    curMonday.year == getYear(6, curMonday) ?
                    (curMonday.month == getMonth(6, curMonday) ?
                    "${monthsOfYear[curMonday.month]}, ${curMonday.year}" :
                    "${monthsOfYear[curMonday.month]} - ${monthsOfYear[getMonth(6, curMonday)]}, ${curMonday.year}") : 
                    "${monthsOfYear[curMonday.month]}, ${curMonday.year} - ${monthsOfYear[getMonth(6, curMonday)]}, ${getYear(6, curMonday)}",
                    style: AppTextStyles.buttonText,
                  ),  
                ),
              ], 
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
            ...getEventWidget(),
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
