import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wakelock/wakelock.dart';

import '../../resources/strings_manager.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
// Global Variables
  int _remainingTimeInSeconds = 60 * 10; // 10 minutes in seconds
  bool _isRestPeriod = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTimeInSeconds > 0) {
          --_remainingTimeInSeconds;
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
      Wakelock.disable(); // Disable wakelock when the timer stops
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.appTitle)),
      body: Center(
          child: _remainingTimeInSeconds > 0
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  // Center content vertically
                  children: [
                    Text(
                      _isRestPeriod
                          ? AppStrings.takeBreak
                          : AppStrings.keepWorking,
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      '${_remainingTimeInSeconds ~/ 60}:${(_remainingTimeInSeconds % 60).toString().padLeft(2, '0')}',
                      style: const TextStyle(fontSize: 40),
                    ),
                  ],
                )
              : const Text(
                  AppStrings.exerciseCompleted,
                  style: TextStyle(fontSize: 20),
                )),
    );
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }
}
