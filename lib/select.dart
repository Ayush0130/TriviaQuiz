import 'package:flutter/material.dart';
import 'package:trivia3/quiz.dart';

class SelectionPage extends StatefulWidget {
  const SelectionPage({super.key, required this.categoryId, required this.categoryName});

  final String categoryId;
  final String categoryName;

  @override
  _SelectionPageState createState() => _SelectionPageState();
}

class _SelectionPageState extends State<SelectionPage> {
  int _numOfQuestions = 5;
  String _difficulty = 'easy';
  String _type = 'multiple';

  List<int> _numberOfQuestionsOptions = [5, 10, 15, 20];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryName),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildSectionTitle('Number of Questions'),
            _buildNumberOfQuestionsSelector(),
            SizedBox(height: 20),
            _buildSectionTitle('Difficulty'),
            _buildDifficultySelector(),
            SizedBox(height: 20),
            _buildSectionTitle('Type'),
            _buildTypeSelector(),
            Spacer(),
            _buildStartQuizButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildNumberOfQuestionsSelector() {
    return Wrap(
      spacing: 10.0,
      children: _numberOfQuestionsOptions.map((int value) {
        return ChoiceChip(
          label: Text(value.toString()),
          selected: _numOfQuestions == value,
          onSelected: (bool selected) {
            setState(() {
              _numOfQuestions = value;
            });
          },
        );
      }).toList(),
    );
  }

  Widget _buildDifficultySelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <String>['easy', 'medium', 'hard'].map((String value) {
        return ChoiceChip(
          label: Text(value.toUpperCase()),
          selected: _difficulty == value,
          onSelected: (bool selected) {
            setState(() {
              _difficulty = value;
            });
          },
        );
      }).toList(),
    );
  }

  Widget _buildTypeSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <String>['multiple', 'boolean'].map((String value) {
        return ChoiceChip(
          label: Text(value.toUpperCase()),
          selected: _type == value,
          onSelected: (bool selected) {
            setState(() {
              _type = value;
            });
          },
        );
      }).toList(),
    );
  }

  Widget _buildStartQuizButton(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 200,
        child: ElevatedButton(
          onPressed: () {
            String apiUrl = 'https://opentdb.com/api.php?amount=$_numOfQuestions&category=${widget.categoryId}&difficulty=$_difficulty&type=$_type';
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => QuizPage(apiUrl: apiUrl),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: Text('Start Quiz', style: TextStyle(fontSize: 16)),
        ),
      ),
    );
  }
}
