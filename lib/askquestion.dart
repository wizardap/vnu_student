import 'package:flutter/material.dart';

class AskQuestionScreen extends StatefulWidget {
  const AskQuestionScreen({Key? key}) : super(key: key);

  @override
  State<AskQuestionScreen> createState() => _AskQuestionScreenState();
}

class _AskQuestionScreenState extends State<AskQuestionScreen> {
  bool isAskSelected = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ask Question'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          // Buttons for Ask and Regular Question
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    isAskSelected = true;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isAskSelected ? Colors.green : Colors.grey,
                  shape: const StadiumBorder(),
                ),
                child: const Text('Ask'),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    isAskSelected = false;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: !isAskSelected ? Colors.green : Colors.grey,
                  shape: const StadiumBorder(),
                ),
                child: const Text('Regular Question'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          isAskSelected ? buildAskContent() : buildRegularQuestionContent(),
        ],
      ),
    );
  }

  // Content for "Ask"
  Widget buildAskContent() {
    return Expanded(
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          const ListTile(
            title: Text('Create a question'),
            leading: Icon(Icons.add, color: Colors.green),
          ),
          const SizedBox(height: 20),
          buildExpandableSection('In progress'),
          const SizedBox(height: 10),
          buildExpandableSection('Done'),
        ],
      ),
    );
  }

  // Expandable section for items
  Widget buildExpandableSection(String title) {
    return Card(
      child: ExpansionTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        children: List.generate(3, (index) {
          return const ListTile(
            leading: Icon(Icons.circle, size: 12),
            title: Text(''),
          );
        }),
      ),
    );
  }

  // Content for "Regular Question"
  Widget buildRegularQuestionContent() {
    return Expanded(
      child: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          // List of questions
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: 5,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    title: Text('Question: ___________________'),
                    subtitle: Text('Answer: ____________________'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}