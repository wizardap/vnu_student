import 'package:flutter/material.dart';

class BuildRequestStatusTile extends StatefulWidget {
  final String title;
  final int counts;

  const BuildRequestStatusTile({
    super.key,
    required this.title,
    required this.counts,
  });

  @override
  State<BuildRequestStatusTile> createState() => _BuildRequestStatusTileState();
}

class _BuildRequestStatusTileState extends State<BuildRequestStatusTile> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: isExpanded ? Color(0xFF13511C) : Colors.grey[200],
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: ListTile(
              title: Text(
                widget.title,
                style: TextStyle(
                  color: isExpanded ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: Icon(
                isExpanded
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
                color: isExpanded ? Colors.white : Colors.black54,
              ),
              onTap: () {
                setState(() {
                  isExpanded = !isExpanded;
                });
              },
            ),
          ),
          if (isExpanded)
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.counts,
              itemBuilder: (context, index) {
                return Container(
                  padding: const EdgeInsets.only(left: 20.0),
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.fiber_manual_record,
                        size: 8,
                        color: Colors.black54,
                      ),
                      const SizedBox(width: 12.0),
                      Expanded(
                        child: Text(
                          'Test ${index + 1}',
                          style: const TextStyle(color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}