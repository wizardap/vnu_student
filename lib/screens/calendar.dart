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

  @override
  Widget build(BuildContext context) {
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

    // Dữ liệu sự kiện (dayIndex, startHour, duration)
    final List<Map<String, dynamic>> events = [
      {'dayIndex': 2, 'startHour': 10, 'duration': 2, 'headerValue': "Sự kiện 1"}, // Event trên Wednesday
      {'dayIndex': 4, 'startHour': 15, 'duration': 1, 'headerValue': "Sự kiện 2"}, // Event trên Friday
      {'dayIndex': 1, 'startHour': 8, 'duration': 3, 'headerValue': "Sự kiện 3"}, // Event trên Tuesday
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
        titleTextStyle: AppTextStyles.appBarTitle,
      ),
      body: Stack(
      children : [
        Column(
          children: [
            // Hàng tiêu đề ngày
            SizedBox(
              height: 80,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                controller: _horizontalHeaderScrollController,
                child: Row(
                  children: [
                    Container(
                      width: 60, // Ô trống ở góc trên bên trái
                      height: 80,
                      color: Theme.of(context).scaffoldBackgroundColor,
                    ),
                    Row(
                      children: List.generate(daysOfWeek.length, (index) {
                        return Container(
                          width: dayCellWidth,
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.primaryGreen,
                            borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                          ),
                          child: Center(
                            child: Text(
                              '${daysOfWeek[index]}\n04/${11 + index}',
                              textAlign: TextAlign.center,
                              style: AppTextStyles.tableHeader,
                              // style: const TextStyle(
                              //   color: Colors.white,
                              //   fontWeight: FontWeight.bold,
                              // ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
            // Nội dung cuộn dọc và ngang
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Cột giờ cố định
                    Column(
                      children: List.generate(24, (index) {
                        return Container(
                          height: hourCellHeight,
                          width: 60,
                          alignment: Alignment.center,
                          child: Text(
                            '${index.toString().padLeft(2, '0')}:00',
                            // style: AppTextStyles.tableData,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        );
                      }),
                    ),
                    // Nội dung lịch
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        controller: _horizontalScrollController,
                        child: Stack(
                          children: [
                            // Hàng duy nhất tô màu xám
                            Row(
                              children:
                                  List.generate(daysOfWeek.length, (dayIndex) {
                                return Container(
                                  width: dayCellWidth,
                                  height: hourCellHeight * 24 + hourCellHeight / 2.0, // Chiều cao của cột giờ + 1/2 chiều cao của ô giờ 23:00->00:00
                                  margin: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: AppColors.iconGray.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                                  )
                                );
                              }),
                            ),
                            // Sự kiện được căn chỉnh
                            for (var event in events)
                              Positioned(
                                top: event['startHour'] * hourCellHeight + hourCellHeight / 2.0, // Text ở vị trí giữa
                                left: event['dayIndex'] * (dayCellWidth + 10) +
                                    10, // Cách biên trái
                                child: Container(
                                  width: dayCellWidth - 10, // Cách biên phải
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
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Positioned(
          top: 0,
          left: 0,
          width: 60,
          height: 80,
          child: Container(
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
        ),
      ]),
    );
  }
}
