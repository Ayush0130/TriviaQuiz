import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class resultpage extends StatefulWidget {
  const resultpage({super.key, required this.score, required this.numofQuestions, required this.onRestart});

  final int score;
  final int numofQuestions;
  final VoidCallback onRestart;

  @override
  State<resultpage> createState() => _resultpagestate();
}

class _resultpagestate extends State<resultpage> {

  @override
  void initState() {
    super.initState();
    saveScore();
  }

  void saveScore() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int score = widget.score;
    int totalPoints = widget.numofQuestions * 10;
    String scoreFormatted = '$score/$totalPoints';
    prefs.setString("score", scoreFormatted);
  }

  void retakeQuiz(BuildContext context) {
    int count = 0;
    Navigator.of(context).popUntil((_) => count++ >= 2);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child:Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Quiz Completed'),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Congratulations!',
              style: TextStyle(
                fontSize: 32.0,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.0),
            Text(
              'You have completed the quiz.',
              style: TextStyle(
                fontSize: 24.0,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.0),
            Text(
              'Your score is:',
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.0),
            Text(
              '${widget.score} / ${widget.numofQuestions * 10}',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () => retakeQuiz(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding: EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                textStyle: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              child: Text('Retake Quiz'),
            ),
            SizedBox(height: 16.0),

          ],
        ),
      ),
    ),
    );
  }
}
