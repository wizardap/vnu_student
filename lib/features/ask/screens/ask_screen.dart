import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vnu_student/core/constants/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:file_picker/file_picker.dart';

class AskScreen extends StatefulWidget {
  const AskScreen({Key? key}) : super(key: key);

  @override
  State<AskScreen> createState() => _AskScreenState();
}

class _AskScreenState extends State<AskScreen> {
  bool isAskSelected = true;
  final TextEditingController _questionController = TextEditingController();

  String? userId;
  List<Map<String, dynamic>> inProgressQuestions = [];
  List<Map<String, dynamic>> doneQuestions = [];

  List<Map<String, dynamic>> regularQuestions = [];

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  Future<void> _getCurrentUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        userId = user.uid;
      });
      _fetchDataFromFirestore();
    }
  }

    Future<void> _fetchDataFromFirestore() async {
    if (userId == null) return;

    // Fetch questions from Firestore
    QuerySnapshot questionsSnapshot = await FirebaseFirestore.instance
      .collection('questions')
      .where('userId', isEqualTo: userId) // Filter by userId
      .get();
  
    // Categorize questions based on their status
    List<Map<String, dynamic>> inProgress = [];
    List<Map<String, dynamic>> done = [];

    questionsSnapshot.docs.forEach((doc) {
    Map<String, dynamic> questionData = {
      "id": doc.id,
      "question": doc['question'], // The question string
      "answer": doc['answer'],     // The answer string
      "status": doc['status'],     // Assuming this field exists
    };

    // Categorize based on status
    if (questionData['status'] == 'in-progress') {
      inProgress.add(questionData);
    } else if (questionData['status'] == 'done') {
      done.add(questionData);
    }

  });

  questionsSnapshot = await FirebaseFirestore.instance
      .collection('regular_questions').get();

  List<Map<String, dynamic>> regular = [];

  questionsSnapshot.docs.forEach((doc){
    Map<String, dynamic> questionData = {
      "id": doc.id,
      "question": doc['question'], // The question string
      "answer": doc['answer'],     // The answer string
    };

    regular.add(questionData);
  });

  setState(() {
    inProgressQuestions = inProgress;
    doneQuestions = done;
    regularQuestions = regular;
  });
}


    @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ask Question',style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        color: Colors.white,
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          // Buttons for Ask and Regular Question
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTabButton('Ask', true),
              const SizedBox(width: 10),
              _buildTabButton('Regular Question', false),
            ],
          ),
          const SizedBox(height: 20),
          // Display content based on selection
          Expanded(
            child: isAskSelected ? buildAskContent() : buildRegularQuestionContent(),
          ),
        ],
      ),
    ),
    );
  }

  Widget _buildTabButton(String title, bool isActive) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          isAskSelected = isActive;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isAskSelected == isActive
            ? AppColors.primaryGreen
            : AppColors.lightGray,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        ),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: isAskSelected == isActive ? Colors.white : Colors.black,
        ),
      ),
    );
  }

  // Content for "Ask"
  Widget buildAskContent() {
  return ListView(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    children: [
      ListTile(
        title: Container(
          
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: Row(
                  children: [
                    Icon(Icons.add, color: Color(0xFF13511C)),
                    SizedBox(width: 10),
                    Text(
                      'Create a request',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  ],
                ),
              ),
        onTap: () => _showCreateQuestionDialog(),
      ),
      const SizedBox(height: 20),
      // In Progress Section
      BuildRequestStatusTile(
  title: 'In progress',
  counts: inProgressQuestions.length,
  questions: inProgressQuestions,
),
      
      const SizedBox(height: 20),
      // Done Section
      BuildRequestStatusTile(
  title: 'Done',
  counts: doneQuestions.length,
  questions: doneQuestions,
),
      
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
        shrinkWrap: true, // Prevents scrolling conflicts
        physics: const NeverScrollableScrollPhysics(),
        itemCount: questions.length,
        itemBuilder: (context, index) {
          final questionData = questions[index];
          final questionText = questionData['question'];

          return Card(
            child: ListTile(
              title: Text(questionText),
              trailing: IconButton(
                icon: const Icon(Icons.check, color: AppColors.primaryGreen),
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

Widget buildDoneSection() {
  return StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance
        .collection('questions')
        .where('status', isEqualTo: 'done')
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
        return const Center(child: Text('No questions marked as done.'));
      }

      return ListView.builder(
        shrinkWrap: true, // Prevents scrolling conflicts
        physics: const NeverScrollableScrollPhysics(),
        itemCount: questions.length,
        itemBuilder: (context, index) {
          final questionData = questions[index];
          final questionText = questionData['question'];

          return Card(
            child: ListTile(
              title: Text(questionText),
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
        backgroundColor: Colors.white,
        title: const Text('Create a Question'),
        content: TextField(
          controller: _questionController,
          decoration: const InputDecoration(hintText: 'Enter your question'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: AppColors.primaryGreen, // Màu xanh cho chữ Cancel
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _addQuestionToFirestore();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF13511C), // Màu nền xanh cho nút Submit
            ),
            child: const Text(
              'Submit',
              style: TextStyle(
                color: Colors.white, // Chữ trắng trên nền xanh
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      );
    },
  );
}

  // Add a new question to Firestore
  Future<void> _addQuestionToFirestore() async {
  if (_questionController.text.isNotEmpty && userId != null) {
    await FirebaseFirestore.instance.collection('questions').add({
      'userId': userId, // Ensure the userId is stored
      'question': _questionController.text,
      'answer': '', // Initialize the answer field as empty
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
            controller: _questionController,
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
            itemCount: regularQuestions.length,
            itemBuilder: (context, index) {
              final question = regularQuestions[index]['question'];
              final answer = regularQuestions[index]['answer'];

              return Container(
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.2),
                    //border: Border.all(color: Color(0xFF13511C).withOpacity(0.4)),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  title: Text(
                    'Question ${index + 1}: ${_truncateText(question)}', // Truncate text with ellipsis
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  onTap: () => _showQuestionDialog(context, question, answer), // Khi nhấn vào câu hỏi
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // Hàm cắt ngắn văn bản nếu quá dài và thêm dấu ba chấm
  String _truncateText(String text) {
    if (text.length > 30) { // Giới hạn 30 ký tự, có thể thay đổi tùy ý
      return text.substring(0, 30) + '...';
    }
    return text;
  }

  // Hàm hiển thị cửa sổ mới khi nhấn vào câu hỏi
  void _showQuestionDialog(BuildContext context, String question, String answer) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: AppColors.backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Dialog Title
                Text(
                  "Full Question",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: AppColors.primaryGreen,
                  ),
                ),
                const SizedBox(height: 16),
                // Question Section
                Text(
                  "Question:",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  question,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
                const Divider(height: 24, color: Colors.grey),
                // Answer Section
                Text(
                  "Answer:",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  answer,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 24),
                // Close Button
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      backgroundColor: AppColors.primaryGreen,
                    ),
                    child: const Text(
  "Close",
  style: TextStyle(color: AppColors.white),
),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
}


class BuildRequestStatusTile extends StatefulWidget {
  final String title;
  final int counts;
  final List<Map<String, dynamic>> questions;

  const BuildRequestStatusTile({
    Key? key,
    required this.title,
    required this.counts,
    required this.questions,
  }) : super(key: key);

  @override
  _BuildRequestStatusTileState createState() => _BuildRequestStatusTileState();
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
              color: isExpanded ? Color(0xFF13511C) : Colors.grey[200], // Background for title and icon
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
                isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
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
              shrinkWrap: true, // To avoid layout errors
              physics: const NeverScrollableScrollPhysics(), // Prevent scrolling
              itemCount: widget.counts,
              itemBuilder: (context, index) {
                final questionData = widget.questions[index];
                final questionText = questionData['question'];
                final answerText = questionData['answer'];

                return Container(
                  padding: const EdgeInsets.only(left: 20.0),
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center, // Center bullet and text
                    children: [
                      const Icon(
                        Icons.fiber_manual_record, // Bullet point
                        size: 8,
                        color: Colors.black54, // Bullet color
                      ),
                      const SizedBox(width: 12.0),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            // Show dialog when a question is tapped
                            _showQuestionDialog(context, questionText, answerText);
                          },
                          child: Text(
                            questionText,
                            style: const TextStyle(color: Colors.black),
                          ),
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

  // Function to show a dialog with the question and answer
  void _showQuestionDialog(BuildContext context, String question, String answer) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0), // Round corners
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Make the dialog only as big as needed
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Question Detail',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryGreen,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Question:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                question,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Answer:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                answer,
                style: TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Close the dialog
                  },
                  child: const Text('Close'),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: AppColors.primaryGreen, // Button color
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

}
