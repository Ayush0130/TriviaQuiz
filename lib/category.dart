import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trivia3/select.dart';

class CategorySelection extends StatefulWidget {
  const CategorySelection({super.key});

  @override
  State<CategorySelection> createState() => _CategorySelectionState();
}

class _CategorySelectionState extends State<CategorySelection> {
  String score = '0/0';

  @override
  void initState() {
    super.initState();
    getValue();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Category'),
        backgroundColor: Colors.teal,
        elevation: 0,
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Your Previous Score:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.teal),
              ),
              SizedBox(height: 8),
              Text(
                score,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.teal),
              ),
              SizedBox(height: 40),
              categoryButton('12', 'Music'),
              SizedBox(height: 20),
              categoryButton('21', 'Sports'),
              SizedBox(height: 20),
              categoryButton('18', 'Computers'),
              SizedBox(height: 20),
              categoryButton('9', 'General Knowledge'),
            ],
          ),
        ),
      ),
    );
  }

  Widget categoryButton(String categoryId, String categoryName) {
    return SizedBox(
      width: double.infinity, // Make buttons take full width
      child: ElevatedButton(
        onPressed: () {
          _navigateToSelectionPage(context, categoryId, categoryName);
        },
        child: Text(
          categoryName,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }

  void _navigateToSelectionPage(BuildContext context, String categoryId, String categoryName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SelectionPage(categoryId: categoryId, categoryName: categoryName),
      ),
    ).then((_) {
      setState(() {
        getValue();
      });
    });
  }

  void getValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? getscore = prefs.getString("score");
    setState(() {
      score = getscore ?? '0/0';
    });
  }
}
