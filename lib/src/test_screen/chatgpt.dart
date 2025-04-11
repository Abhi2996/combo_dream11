import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LuckCalculatorChatGpt(),
    );
  }
}

class LuckCalculatorChatGpt extends StatefulWidget {
  @override
  _LuckCalculatorChatGptState createState() => _LuckCalculatorChatGptState();
}

class _LuckCalculatorChatGptState extends State<LuckCalculatorChatGpt> {
  final TextEditingController dobController = TextEditingController();
  DateTime? selectedDate;
  double luckPercentage = 0.0;

  void _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        dobController.text = DateFormat('dd-MM-yyyy').format(picked);
      });
    }
  }

  void calculateLuck() {
    if (selectedDate == null) return;
    int birthNumber = selectedDate!.day % 9 == 0 ? 9 : selectedDate!.day % 9;
    int destinyNumber = selectedDate!.year
        .toString()
        .split('')
        .map(int.parse)
        .reduce((a, b) => a + b);
    destinyNumber = destinyNumber % 9 == 0 ? 9 : destinyNumber % 9;

    DateTime today = DateTime.now();
    int todayNumber = today.day % 9 == 0 ? 9 : today.day % 9;

    double luck = 50.0;
    if (birthNumber == todayNumber) luck += 25;
    if (destinyNumber == todayNumber) luck += 25;

    setState(() {
      luckPercentage = luck;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Luck Calculator")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: dobController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: "Enter Date of Birth",
                suffixIcon: IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(context),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: calculateLuck,
              child: Text("Calculate Luck"),
            ),
            SizedBox(height: 20),
            Text(
              "Your Luck Percentage: ${luckPercentage.toStringAsFixed(2)}%",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
