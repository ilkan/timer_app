import 'package:flutter/material.dart';

// Controller, requiered to controll progress animation
class TimerProgressController {
  void Function({double beginValue, double endValue}) animateToProgress;
  void Function() resetProgress;
}

class TimerProgressLoader extends StatefulWidget {
  TimerProgressLoader({this.controller});
  final TimerProgressController controller;

  @override
  _TimerProgressLoaderState createState() =>
      _TimerProgressLoaderState(controller);
}

class _TimerProgressLoaderState extends State<TimerProgressLoader>
    with SingleTickerProviderStateMixin {
  _TimerProgressLoaderState(TimerProgressController _controller) {
    _controller.animateToProgress = animateProgress;
    _controller.resetProgress = resetProgress;
  }

  //Animation

  Animation<double> _animation;
  AnimationController _animationController;

  //Values
  double _animationValue = 0;
  double _beginValue = 0;
  double _endValue = 1;

  //Dimens
  double _loaderSize = 300;

  //Not Private, access it from home page
  void animateProgress({double beginValue, double endValue}) {
    _beginValue = beginValue;
    _endValue = endValue;

    _animationController.reset();
    _assignAnimation();
    _animationController.forward();
  }

  void resetProgress() {}

  @override
  void initState() {
    super.initState();

    //Initiate Animation controller

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );

    // Define animation

    // Asign Animation
    _assignAnimation();

    //Start animation, when page loads
    _animationController.forward();
  }

  void _assignAnimation() {
    _animation = Tween<double>(begin: _beginValue, end: _endValue)
        .animate(_animationController)

          //Add Listeners if required
          ..addListener(() {
            setState(() {});
          })
          ..addStatusListener((status) {});
  }

  @override
  Widget build(BuildContext context) {
    // Update animation value, when page updates state updates
    _animationValue = _animation.value;

    //Loading Wrapper
    return Container(
      width: _loaderSize,
      height: _loaderSize,

      //Stack Contains the background gradient and foreground circle to cover the front
      child: Stack(
        children: [
          ShaderMask(
            shaderCallback: (rect) {
              return SweepGradient(
                stops: [_animationValue, _animationValue],
                center: Alignment.center,
                colors: [
                  Colors.blue,
                  Colors.white.withAlpha(10),
                ],
              ).createShader(rect);
            },
            child: Container(
              width: _loaderSize,
              height: _loaderSize,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/progress-bar.png"),
                ),
                //color: Colors.blue,
                shape: BoxShape.circle,
              ),
              child: Container(),
            ),
          ),

          //Cover to block the center part of gradient loading circle
          Center(
            child: Container(
              width: _loaderSize - 20,
              height: _loaderSize - 20,
              decoration: BoxDecoration(
                //color: Color(0xFF111111),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
