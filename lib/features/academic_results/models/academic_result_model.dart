class AcademicResult {
  final String semester;
  final double gpa;
  final int trainingPoints;
  final Map<String, int> grades;
  final List<Subject> subjects;
  final List<String> advice;

  AcademicResult({
    required this.semester,
    required this.gpa,
    required this.trainingPoints,
    required this.grades,
    required this.subjects,
    required this.advice,
  });

  // Chuyển đổi từ Firestore DocumentSnapshot sang AcademicResult
  factory AcademicResult.fromFirestore(Map<String, dynamic> data) {
    List<Subject> subjectsList = (data['subjects'] as List)
        .asMap()
        .entries
        .map((entry) => Subject.fromFirestore(entry.value, entry.key + 1))
        .toList();

    return AcademicResult(
      semester: data['semester'] as String,
      gpa: (data['gpa'] as num).toDouble(),
      trainingPoints: data['trainingPoints'] as int,
      grades: Map<String, int>.from(data['gradeDistribution']),
      subjects: subjectsList,
      advice: List<String>.from(data['advice']),
    );
  }

  // Chuyển đổi từ AcademicResult sang Map để lưu vào Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'semester': semester,
      'gpa': gpa,
      'trainingPoints': trainingPoints,
      'gradeDistribution': grades,
      'subjects': subjects.map((subject) => subject.toFirestore()).toList(),
      'advice': advice,
    };
  }
}

class Subject {
  final int id;          // Số thứ tự tự động
  final String subjectName;
  final int credit;
  final String grade;

  Subject({
    required this.id,
    required this.subjectName,
    required this.credit,
    required this.grade,
  });

  // Chuyển đổi từ Map sang Subject và tự động gán stt
  factory Subject.fromFirestore(Map<String, dynamic> data, int stt) {
    return Subject(
      id: stt,
      subjectName: data['subjectName'] as String,
      credit: data['credit'] as int,
      grade: data['grade'] as String,
    );
  }

  // Chuyển đổi từ Subject sang Map
  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'subjectName': subjectName,
      'credit': credit,
      'grade': grade,
    };
  }
}
