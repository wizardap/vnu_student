import 'dart:math';

import 'package:flutter/material.dart';
import 'package:vnu_student/core/constants/constants.dart';
import 'package:vnu_student/features/calendar/model/event_getter.dart';
import 'package:vnu_student/features/calendar/model/datetime_helper.dart';


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
  // [
  //   {
  //     'date': DateTime(2024, 11, 27),
  //     'startHour': 10,
  //     'duration': 2,
  //     'headerValue': "Sự kiện 1",
  //     'place' : "G2"
  //   }, // Event trên Wednesday
  // ];
  List<Map<String, dynamic>> events = [];
  EventGetter eventGetter = EventGetter();
  DatetimeHelper dateTimeHelper = DatetimeHelper();

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

  // Cập nhật dữ liệu tuần mỗi khi thay đổi xảy ra
  void refreshCalendar() {
    events = eventGetter.getEvents(
      dateTimeHelper.getMonday(), dateTimeHelper.getWeekEnd() 
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: dateTimeHelper.getSelectedDate(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != dateTimeHelper.getSelectedDate()) {
      setState(() {
        dateTimeHelper.set(picked);
        refreshCalendar();
      });
    }
  }

  void _previousWeek() {
    setState(() {
      dateTimeHelper.set(
        dateTimeHelper.getSelectedDate().subtract(const Duration(days: 7))
      );
      refreshCalendar();
    });
  }

  void _nextWeek() {
    setState(() {
      dateTimeHelper.set(
        dateTimeHelper.getSelectedDate().add(const Duration(days: 7))
      );
      refreshCalendar();
    });
  }

  List<Widget> getEventWidget() {
    List<Widget> eventWidgets = [];

    for (var event in events) {
      eventWidgets.add(
        Positioned(
          top: event['startHour'] * hourCellHeight + hourCellHeight / 2.0,
          left: DatetimeHelper.getDayIndex(event['date']) * (dayCellWidth + 10) + 10,
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
                    dateTimeHelper.allSameYear() ?
                    (dateTimeHelper.allSameMonth() ?
                    "${monthsOfYear[dateTimeHelper.getMonday().month]}, ${dateTimeHelper.getMonday().year}" :
                    "${monthsOfYear[dateTimeHelper.getMonday().month]} - ${monthsOfYear[DatetimeHelper.getMonth(6, dateTimeHelper.getMonday())]}, ${dateTimeHelper.getMonday().year}") : 
                    "${monthsOfYear[dateTimeHelper.getMonday().month]}, ${dateTimeHelper.getMonday().year} - ${monthsOfYear[DatetimeHelper.getMonth(6, dateTimeHelper.getMonday())]}, ${DatetimeHelper.getYear(6, dateTimeHelper.getMonday())}",
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
                        '${daysOfWeek[index]}\n${DatetimeHelper.getDay(index, dateTimeHelper.getMonday())}',
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
