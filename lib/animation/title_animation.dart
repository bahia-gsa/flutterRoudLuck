import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class titleAnimation extends StatelessWidget {
  final String title;
  const titleAnimation({super.key, required this.title});

  

  @override
  Widget build(BuildContext context) {
    const colorizeColors = [
  Colors.purple,
  Colors.blue,
  Colors.yellow,
  Colors.red,
    ];

  const colorizeTextStyle = TextStyle(
    fontSize: 50.0,
    fontFamily: 'Gluten',
  );
    return Center(
            child: AnimatedTextKit(
              animatedTexts: [
                ColorizeAnimatedText(
                  title,
                  textStyle: colorizeTextStyle,
                  colors: colorizeColors,
                ),
              ],
              isRepeatingAnimation: true,
            ),
          );
  }
}