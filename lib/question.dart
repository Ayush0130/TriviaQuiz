class Question {
  final String category;
  final String type;
  final String difficulty;
  final String question;
  final String correct_answer;
  final List<String> incorrect_answers;
  late List<String> shuffled_answers;



  Question({
    required this.category,
    required this.type,
    required this.difficulty,
    required this.question,
    required this.correct_answer,
    required this.incorrect_answers,
  }){
    shuffled_answers=[correct_answer,...incorrect_answers]..shuffle();
  }

  /*List<String> getShuffledAnswers() {
    List<String> allAnswers = List.from(incorrect_answers);
    allAnswers.add(correct_answer);
    allAnswers.shuffle();
    return allAnswers;
  }*/
  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      category: json['category'],
      type: json['type'],
      difficulty: json['difficulty'],
      question: json['question'],
      correct_answer: json['correct_answer'],
      incorrect_answers: List<String>.from(json['incorrect_answers']),
    );
  }

}
