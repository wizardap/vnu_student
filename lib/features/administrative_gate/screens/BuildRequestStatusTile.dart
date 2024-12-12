import 'package:flutter/material.dart';

class BuildRequestStatusTile extends StatefulWidget {
  final String title;
  final List<Map<String, dynamic>> items;

  const BuildRequestStatusTile({
    super.key,
    required this.title,
    required this.items,
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
              itemCount: widget.items.length,
              itemBuilder: (context, index) {
                return Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.2),
                    //border: Border.all(color: Color(0xFF13511C).withOpacity(0.4)),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  padding: const EdgeInsets.only(left: 30.0),
                  margin: const EdgeInsets.only(top: 10.0),
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
                          '${widget.items[index]['type']}',
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.info),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Popup Title'),
                                content:
                                    Text('This is the content of the popup.'),
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
