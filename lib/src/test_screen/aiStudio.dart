import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import intl for date formatting

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Luck Calculator',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: LuckCalculator(),
    );
  }
}

class LuckCalculator extends StatefulWidget {
  @override
  _LuckCalculatorState createState() => _LuckCalculatorState();
}

class _LuckCalculatorState extends State<LuckCalculator> {
  DateTime? _birthDate;
  DateTime? _selectedDate;
  double _luckPercentage = 0.0;

  Future<void> _selectBirthDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _birthDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _birthDate) {
      setState(() {
        _birthDate = picked;
        _calculateLuckPercentage();
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _calculateLuckPercentage();
      });
    }
  }

  int _calculateMulank(DateTime date) {
    return date.day % 9 == 0 ? 9 : date.day % 9;
  }

  int _calculateBhagyank(DateTime date) {
    int day = date.day;
    int month = date.month;
    int year = date.year;

    int sum = 0;
    String dateString = '$day$month$year';

    for (int i = 0; i < dateString.length; i++) {
      sum += int.parse(dateString[i]);
    }

    while (sum > 9) {
      int tempSum = 0;
      String sumString = sum.toString();
      for (int i = 0; i < sumString.length; i++) {
        tempSum += int.parse(sumString[i]);
      }
      sum = tempSum;
    }
    return sum;
  }

  double _calculateLuckPercentage() {
    if (_birthDate == null || _selectedDate == null) {
      return 0.0;
    }

    int mulank = _calculateMulank(_birthDate!);
    int bhagyank = _calculateBhagyank(_birthDate!);

    // Match day of the week (1=Monday, 7=Sunday)
    int weekday = _selectedDate!.weekday;

    // Weekday luck score (arbitrary values)
    double weekdayScore = 0.0;
    if (mulank == 1 || mulank == 4) {
      weekdayScore =
          (weekday == 1 || weekday == 7)
              ? 10.0
              : (weekday == 6)
              ? 3.0
              : 7.0; //Example logic
    } else if (mulank == 2 || mulank == 7) {
      weekdayScore =
          (weekday == 1 || weekday == 4)
              ? 10.0
              : (weekday == 3)
              ? 3.0
              : 7.0;
    } else if (mulank == 3 || mulank == 9) {
      weekdayScore =
          (weekday == 4 || weekday == 7)
              ? 10.0
              : (weekday == 3)
              ? 3.0
              : 7.0;
    } else if (mulank == 5) {
      weekdayScore =
          (weekday == 3 || weekday == 5)
              ? 10.0
              : (weekday == 2)
              ? 3.0
              : 7.0;
    } else if (mulank == 6 || mulank == 8) {
      weekdayScore =
          (weekday == 2 || weekday == 5)
              ? 10.0
              : (weekday == 7)
              ? 3.0
              : 7.0;
    }

    // Match date numerology score (arbitrary values)
    int selectedDateMulank = _calculateMulank(_selectedDate!);
    double dateScore =
        (selectedDateMulank == mulank || selectedDateMulank == bhagyank)
            ? 10.0
            : 5.0; //Example logic

    //Month Score
    int month = _birthDate!.month;
    double monthScore = 7.0;
    if (mulank == 1 || mulank == 4) {
      monthScore =
          (month == 1 || month == 10)
              ? 10.0
              : (month == 8)
              ? 3.0
              : 7.0; //Example logic
    } else if (mulank == 2 || mulank == 7) {
      monthScore =
          (month == 2 || month == 7 || month == 11)
              ? 10.0
              : (month == 8)
              ? 3.0
              : 7.0;
    } else if (mulank == 3 || mulank == 9) {
      monthScore =
          (month == 3 || month == 12)
              ? 10.0
              : (month == 5)
              ? 3.0
              : 7.0;
    } else if (mulank == 5) {
      monthScore =
          (month == 5 || month == 9)
              ? 10.0
              : (month == 1)
              ? 3.0
              : 7.0;
    } else if (mulank == 6 || mulank == 8) {
      monthScore =
          (month == 6 || month == 10)
              ? 10.0
              : (month == 3)
              ? 3.0
              : 7.0;
    }

    // Luck Calculation
    double luckPercentage =
        (0.3 * (mulank * 10 / 9)) +
        (0.3 * (bhagyank * 10 / 9)) +
        (0.2 * dateScore) +
        (0.1 * weekdayScore) +
        (0.1 * monthScore);

    setState(() {
      _luckPercentage = luckPercentage;
    });
    return luckPercentage;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Luck Calculator')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            ElevatedButton(
              onPressed: () => _selectBirthDate(context),
              child: Text(
                _birthDate == null
                    ? 'Select Birth Date'
                    : 'Birth Date: ${DateFormat('yyyy-MM-dd').format(_birthDate!)}',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _selectDate(context),
              child: Text(
                _selectedDate == null
                    ? 'Select Date'
                    : 'Selected Date: ${DateFormat('yyyy-MM-dd').format(_selectedDate!)}',
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Luck Percentage: ${_luckPercentage.toStringAsFixed(2)}%',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 10),
            _luckPercentage > 0
                ? Text(
                  _getLuckInterpretation(_luckPercentage),
                  style: TextStyle(
                    fontSize: 16,
                    color: _getColorForLuck(_luckPercentage),
                  ),
                  textAlign: TextAlign.center,
                )
                : Container(),
          ],
        ),
      ),
    );
  }

  String _getLuckInterpretation(double luckPercentage) {
    if (luckPercentage >= 80) {
      return 'Super Lucky - Best performance day!';
    } else if (luckPercentage >= 60) {
      return 'Good Luck - High chance of success.';
    } else if (luckPercentage >= 40) {
      return 'Average Luck - Unpredictable game, may struggle.';
    } else if (luckPercentage >= 20) {
      return 'Low Luck - Bad performance likely.';
    } else {
      return 'Very Bad Luck - High chance of failure.';
    }
  }

  Color _getColorForLuck(double luckPercentage) {
    if (luckPercentage >= 60) {
      return Colors.green;
    } else if (luckPercentage >= 40) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }
}
