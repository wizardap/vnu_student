class AcademicResult {
  final String semester;
  final double gpa;
  final int trainingPoints;
  final Map<String, int> grades;
  final List<Subject> subjects;

  AcademicResult({
    required this.semester,
    required this.gpa,
    required this.trainingPoints,
    required this.grades,
    required this.subjects,
  });

  // Chuyển đổi từ Firestore DocumentSnapshot sang AcademicResult
  factory AcademicResult.fromFirestore(Map<String, dynamic> data) {
    return AcademicResult(
      semester: data['semester'] as String,
      gpa: (data['gpa'] as num).toDouble(),
      trainingPoints: data['trainingPoints'] as int,
      grades: Map<String, int>.from(data['grades']),
      subjects: (data['subjects'] as List)
          .map((subject) => Subject.fromFirestore(subject))
          .toList(),
    );
  }

  // Chuyển đổi từ AcademicResult sang Map để lưu vào Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'semester': semester,
      'gpa': gpa,
      'trainingPoints': trainingPoints,
      'grades': grades,
      'subjects': subjects.map((subject) => subject.toFirestore()).toList(),
    };
  }
}

class Subject {
  final int stt;
  final String name;
  final int credits;
  final String grade;

  Subject({
    required this.stt,
    required this.name,
    required this.credits,
    required this.grade,
  });

  // Chuyển đổi từ Map sang Subject
  factory Subject.fromFirestore(Map<String, dynamic> data) {
    return Subject(
      stt: data['stt'] as int,
      name: data['name'] as String,
      credits: data['credits'] as int,
      grade: data['grade'] as String,
    );
  }

  // Chuyển đổi từ Subject sang Map
  Map<String, dynamic> toFirestore() {
    return {
      'stt': stt,
      'name': name,
      'credits': credits,
      'grade': grade,
    };
  }
}
