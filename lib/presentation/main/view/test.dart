import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TimerApp(),
    );
  }
}

class TimerApp extends StatefulWidget {
  @override
  _TimerAppState createState() => _TimerAppState();
}

class _TimerAppState extends State<TimerApp> {
  int _remainingTimeInSeconds = 10 * 60; // 10 minutes in seconds
  bool _isRestPeriod = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTimeInSeconds > 0) {
          _remainingTimeInSeconds--;
          if (_remainingTimeInSeconds % 60 == 0) {
            _isRestPeriod = !_isRestPeriod; // Toggle rest period every minute
          }
        } else {
          _stopTimer();
        }
      });
    });
  }

  void _stopTimer() {
    if (_timer != null) {
      _timer!.cancel();
      _remainingTimeInSeconds = 0; // Set remaining time to 0
      _isRestPeriod = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Timer App'),
      ),
      body: Center(
        child: _remainingTimeInSeconds > 0
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _isRestPeriod
                  ? 'It\'s time to take a break and rest for a minute.'
                  : 'Keep working for 1 minute.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            Text(
              '${_remainingTimeInSeconds ~/ 60}:${(_remainingTimeInSeconds % 60).toString().padLeft(2, '0')}',
              style: TextStyle(fontSize: 40),
            ),
          ],
        )
            : Text(
          'Exercise completed!',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }
}
