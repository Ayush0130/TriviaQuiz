import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:trivia3/question.dart';
import 'package:trivia3/result.dart';

class QuizPage extends StatefulWidget {
  final String apiUrl;

  QuizPage({required this.apiUrl});

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int currentQuestionIndex = 0;
  List<Question> questions = [];
  bool isLoading = true;
  String errorMessage = '';
  int score = 0;
  int timer = 15;
  Timer? _timer;
  bool answered = false;

  @override
  void initState() {
    super.initState();
    fetchQuestions();
  }

  Future<void> fetchQuestions() async {
    try {
      final response = await http.get(Uri.parse(widget.apiUrl));
      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        setState(() {
          questions = (data['results'] as List)
              .map((item) => Question.fromJson(item))
              .toList();
          isLoading = false;
          _startTimer();
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load questions. Status code: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load questions. Error: $e';
        isLoading = false;
      });
    }
  }

  void _startTimer() {
    timer = 15; // 15 seconds for each question
    answered = false; // Reset the answered flag
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      if (this.timer > 0) {
        setState(() {
          this.timer--;
        });
      } else {
        _nextQuestion(); // Move to the next question when timer runs out
      }
    });
  }

  void _nextQuestion() {
    _timer?.cancel();
    if (!answered) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Time is up!'),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          duration: Duration(seconds: 1),
        ),
      );
    }
    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        _startTimer();
      });
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => resultpage(
            score: score,
            numofQuestions: questions.length,
            onRestart: resetQuiz,
          ),
        ),
      );
    }
  }

  void _checkAnswer(String answer) {
    answered = true;
    bool isCorrect = answer == questions[currentQuestionIndex].correct_answer;
    if (isCorrect) {
      score += (timer > 10) ? 10 : 5; // More points for faster answers
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isCorrect ? 'Correct!' : 'Wrong!'),
        backgroundColor: isCorrect ? Colors.green : Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        duration: Duration(seconds: 1),
      ),
    );

    Future.delayed(Duration(seconds: 1), () {
      _nextQuestion();
    });
  }

  void resetQuiz() {
    setState(() {
      currentQuestionIndex = 0;
      score = 0;
      isLoading = true;
      errorMessage = '';
    });
    fetchQuestions();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Trivia Quiz'),
          backgroundColor: Colors.teal,
          centerTitle: true,
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (errorMessage.isNotEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Trivia Quiz'),
          backgroundColor: Colors.teal,
          centerTitle: true,
        ),
        body: Center(
          child: Text(errorMessage),
        ),
      );
    }

    Question currentQuestion = questions[currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('Question ${currentQuestionIndex + 1} of ${questions.length}'),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LinearProgressIndicator(
              value: (currentQuestionIndex + 1) / questions.length,
              backgroundColor: Colors.teal.shade100,
              color: Colors.teal,
              minHeight: 8,
            ),
            SizedBox(height: 16.0),
            Text(
              'Score: $score/${questions.length * 10}', // Assuming max score per question is 10
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.teal),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.0),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  currentQuestion.question,
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(height: 24.0),
            Text(
              'Time Remaining: $timer seconds',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.teal),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.0),
            ...currentQuestion.shuffled_answers.map((answer) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal, // Background color
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    textStyle: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: Text(answer),
                  onPressed: () => _checkAnswer(answer),
                ),
              );
            }).toList(),
            Spacer(),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
