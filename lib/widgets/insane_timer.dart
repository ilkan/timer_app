import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'file:///C:/CENG/tutorials/timer_app/lib/widgets/insane_timer_progress_loader.dart';

class Insanetimer extends StatefulWidget {
  Insanetimer({Key key}) : super(key: key);

  @override
  _InsanetimerState createState() => _InsanetimerState();
}

class _InsanetimerState extends State<Insanetimer> {
  //Timer
  Timer _timer;
  //Timer Controls
  int _startTime = 0;
  int _currentTime = 0;

  int _progress = 100;

  //Text Field and Buttons
  TextEditingController _timerTextController = TextEditingController();
  String _btnText = "Start Timer";

  bool _isTimerRunning = false;
  bool _isTextEnabled = true;

  //Animate Controller
  TimerProgressController _progressController = TimerProgressController();

  void _startTimer() {
    //Set timer Start
    _setTimerStart();

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_currentTime > 0) {
        _currentTime--;

        //Set Text Field Value

        _timerTextController.text = _currentTime.toString();

        //Set Time Progress
        _progressController.animateToProgress(
          beginValue: _calcProgress(_currentTime + 1) / 100,
          endValue: _calcProgress(_currentTime) / 100,
        );
      } else {
        //Stop Timer
        _setTimerStop();
      }
    });
  }

  int _calcProgress(int number) {
    _progress = ((number / _startTime) * 100).round();
    return _progress;
  }

  void _setTimerStart() {
    setState(() {
      _isTimerRunning = true;
      _isTextEnabled = false;

      _btnText = "Stop Timer";
    });
  }

  void _setTimerStop() {
    setState(() {
      _timerTextController.text = "";

      _progressController.animateToProgress(
        beginValue: _calcProgress(_currentTime) / 100,
        endValue: 1,
      );

      _isTimerRunning = false;
      _isTextEnabled = true;

      _btnText = "Start Timer";

      _timer.cancel();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF111111),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //Timer Container with text field and animation
          Stack(
            children: [
              //Loading Animation
              Center(
                child: TimerProgressLoader(
                  controller: _progressController,
                ),
              ),
              //Timer text field
              Center(
                child: Container(
                  height: 300,
                  width: 300,
                  alignment: Alignment.center,
                  child: TextField(
                    enabled: _isTextEnabled,
                    controller: _timerTextController,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "0",
                        hintStyle: TextStyle(
                          fontSize: 56,
                          color: Colors.white.withAlpha(90),
                        )),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 56,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),

          //Spacing
          SizedBox(
            height: 56,
          ),

          //Timer Start/Stop Button
          TextButton(
              onPressed: () {
                //Check if timer is already running
                if (!_isTimerRunning) {
                  String timerTextValue = _timerTextController.text.toString();
                  if (timerTextValue.isNotEmpty) {
                    //Get Time
                    int time = int.parse(timerTextValue);

                    //Set Time
                    _startTime = time;
                    _currentTime = time;

                    _startTimer();
                  }
                } else {
                  _setTimerStop();
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  _btnText,
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ))
        ],
      ),
    );
  }
}
