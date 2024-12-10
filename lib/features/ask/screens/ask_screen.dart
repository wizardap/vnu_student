import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vnu_student/core/constants/constants.dart';

class AskScreen extends StatefulWidget {
  const AskScreen({Key? key}) : super(key: key);

  @override
  State<AskScreen> createState() => _AskScreenState();
}

class _AskScreenState extends State<AskScreen> {
  bool isAskSelected = true;
  final TextEditingController _questionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ask Question'),
        titleTextStyle: AppTextStyles.appBarTitle,
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
                child: const Text(
                  'Ask',
                  style: TextStyle(color: Colors.black),
                ),
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
                child: const Text(
                  'Regular Question',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Display content based on selection
          Expanded(
            child: isAskSelected
                ? buildAskContent()
                : buildRegularQuestionContent(),
          ),
        ],
      ),
    );
  }

  // Content for "Ask"
  Widget buildAskContent() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        ListTile(
          title: const Text('Create a question'),
          leading: const Icon(Icons.add, color: Colors.green),
          onTap: () => _showCreateQuestionDialog(),
        ),
        const SizedBox(height: 20),
        buildInProgressSection(),
      ],
    );
  }

  // Firestore stream for in-progress questions
  Widget buildInProgressSection() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('questions')
          .where('status', isEqualTo: 'in-progress')
          .orderBy('created_at', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(child: Text('Error fetching questions.'));
        }

        final questions = snapshot.data?.docs ?? [];

        if (questions.isEmpty) {
          return const Center(child: Text('No questions in progress.'));
        }

        return ListView.builder(
          shrinkWrap: true,
          itemCount: questions.length,
          itemBuilder: (context, index) {
            final questionData = questions[index];
            final questionText = questionData['question'];

            return Card(
              child: ListTile(
                title: Text(questionText),
                trailing: IconButton(
                  icon: const Icon(Icons.check, color: Colors.green),
                  onPressed: () {
                    markQuestionAsDone(questionData.id);
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Mark a question as done
  Future<void> markQuestionAsDone(String questionId) async {
    await FirebaseFirestore.instance
        .collection('questions')
        .doc(questionId)
        .update({'status': 'done'});
  }

  // Dialog to create a new question
  void _showCreateQuestionDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Create a Question'),
          content: TextField(
            controller: _questionController,
            decoration: const InputDecoration(hintText: 'Enter your question'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                _addQuestionToFirestore();
                Navigator.pop(context);
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  // Add a new question to Firestore
  Future<void> _addQuestionToFirestore() async {
    if (_questionController.text.isNotEmpty) {
      await FirebaseFirestore.instance.collection('questions').add({
        'question': _questionController.text,
        'status': 'in-progress',
        'created_at': FieldValue.serverTimestamp(),
      });
      _questionController.clear();
    }
  }

  // Content for "Regular Question"
  Widget buildRegularQuestionContent() {
    return Column(
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
                  title: Text('Question ${index + 1}'),
                  subtitle: const Text('Answer: ____________________'),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
