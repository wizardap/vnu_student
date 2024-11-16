import 'package:flutter/material.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final ScrollController _hourScrollController = ScrollController();
  final ScrollController _contentScrollController = ScrollController();
  final ScrollController _horizontalScrollController = ScrollController();
  final ScrollController _horizontalHeaderScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _contentScrollController.addListener(() {
      _hourScrollController.jumpTo(_contentScrollController.offset);
    });
    _horizontalScrollController.addListener(() {
      _horizontalHeaderScrollController
          .jumpTo(_horizontalScrollController.offset);
    });
  }

  @override
  void dispose() {
    _hourScrollController.dispose();
    _contentScrollController.dispose();
    _horizontalScrollController.dispose();
    _horizontalHeaderScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double hourCellHeight = 60;
    final double dayCellWidth = 120;
    final List<String> daysOfWeek = [
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday",
      "Sunday"
    ];

    // Mock events data
    final List<List<bool>> events =
        List.generate(24, (i) => List.generate(7, (j) => false));
    events[10][2] = true; // Event at 10:00 on Wednesday
    events[15][4] = true; // Event at 15:00 on Friday
    events[8][1] = true; // Event at 08:00 on Tuesday
    events[12][5] = true; // Event at 12:00 on Saturday
    events[18][3] = true; // Event at 18:00 on Thursday

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar 7 Days'),
      ),
      body: Column(
        children: [
          // Day header row (horizontal scroll)
          SizedBox(
            height: 80,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              controller:
                  _horizontalHeaderScrollController, // Sync horizontal scroll
              child: Row(
                children: [
                  Container(
                    width: 60, // Blank space at the intersection
                    height: 80,
                    color: Colors.white,
                  ),
                  Row(
                    children: List.generate(daysOfWeek.length, (index) {
                      return Container(
                        width: dayCellWidth,
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                          color: Colors.green[800],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            '${daysOfWeek[index]}\n04/${11 + index}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
          // Calendar content (horizontal and vertical scroll)
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Fixed hour column
                SizedBox(
                  width: 60,
                  child: ListView.builder(
                    controller: _hourScrollController, // Sync vertical scroll
                    itemCount: 24,
                    itemBuilder: (context, index) {
                      return Container(
                        height: hourCellHeight,
                        alignment: Alignment.center,
                        child: Text(
                          '${index.toString().padLeft(2, '0')}:00',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      );
                    },
                  ),
                ),
                // Calendar grid (horizontal and vertical scroll)
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    controller:
                        _horizontalScrollController, // Sync horizontal scroll
                    child: SizedBox(
                      width: (dayCellWidth + 10) * daysOfWeek.length,
                      child: ListView.builder(
                        controller:
                            _contentScrollController, // Sync vertical scroll
                        itemCount: 24,
                        itemBuilder: (context, hourIndex) {
                          return Row(
                            children:
                                List.generate(daysOfWeek.length, (dayIndex) {
                              bool isEvent = events[hourIndex][dayIndex];
                              return Container(
                                width: dayCellWidth,
                                height: hourCellHeight,
                                margin: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: isEvent
                                      ? Colors.blue
                                      : Colors.green.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child:
                                    Center(child: Text(isEvent ? 'Event' : '')),
                              );
                            }),
                          );
                        },
                      ),
                    ),
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
