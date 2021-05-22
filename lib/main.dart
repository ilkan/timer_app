import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timer_app/widgets/insane_timer.dart';

void main() => runApp(TimerApp());

class TimerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            textTheme: GoogleFonts.openSansTextTheme(
          Theme.of(context).textTheme,
        )),
        home: Insanetimer());
  }
}
