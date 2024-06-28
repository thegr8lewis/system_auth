import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:confetti/confetti.dart';

class Question extends StatefulWidget {
  const Question({super.key});

  @override
  State<Question> createState() => _QuestState();
}

class _QuestState extends State<Question> {
  String? _selectedOption;
  String correctAnswer = '20 years';
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _onOptionSelected(String option) {
    setState(() {
      _selectedOption = option;
      if (option == correctAnswer) {
        _confettiController.play();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFDF7F2),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Icon(Icons.arrow_back, color: Colors.brown[800]),
        actions: [
          SizedBox(height: 10),
          TextButton(
            onPressed: () {
              // Add your button action here
            },
            child: Text(
              'Skip',
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
            ),
          )
        ],
        title: Center(
          child: Text(
            'Math Quiz',
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.brown[800],
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '1/20',
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.brown[800],
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: SizedBox(
                          height: 10,
                          child: LinearProgressIndicator(
                            value: 1 / 20,
                            backgroundColor: Colors.orange[100],
                            color: Color.fromARGB(255, 15, 160, 27),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Color.fromARGB(255, 15, 160, 27),
                            ),
                            borderRadius: BorderRadius.circular(5.0), // Add this line to make the LinearProgressIndicator rounded
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text(
                    'If David’s age is 27 years old in 2011. What was his age in 2003?',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown[800],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  _buildOptionCard('19 years'),
                  _buildOptionCard('37 years'),
                  _buildOptionCard('20 years'),
                  _buildOptionCard('17 years'),
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      // Handle report question action
                    },
                    child: Row(
                      children: [
                        Icon(Icons.flag, color: Colors.brown[800]),
                        SizedBox(width: 10),
                        Text(
                          'Report question',
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              fontSize: 16,
                              color: Colors.brown[800],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  if (_selectedOption != null)
                    ElevatedButton(
                      onPressed: () {
                        // Handle the next button action
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                      ),
                      child: Text(
                        'Next',
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirection: -3.14 / 2,
                maxBlastForce: 5,
                minBlastForce: 2,
                emissionFrequency: 0.05,
                numberOfParticles: 20,
                gravity: 0.1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionCard(String option) {
    bool isCorrect = option == correctAnswer;
    bool isSelected = option == _selectedOption;

    return GestureDetector(
      onTap: () => _onOptionSelected(option),
      child: Container(
        margin: EdgeInsets.only(bottom: 20),
        padding: EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          color: isSelected
              ? (isCorrect ? Colors.green : Colors.red)
              : Colors.orange,
          borderRadius: BorderRadius.circular(19.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              option,
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            if (isSelected)
              Icon(
                isCorrect ? Icons.check_circle : Icons.cancel,
                color: Colors.white,
              ),
          ],
        ),
      ),
    );
  }
}
