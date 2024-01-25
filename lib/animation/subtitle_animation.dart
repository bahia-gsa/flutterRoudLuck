import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class subtitleAnimation extends StatelessWidget {
  const subtitleAnimation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300.0,
      height: 50.0,
      child: DefaultTextStyle(
        style: const TextStyle(
          fontSize: 20.0,
          fontFamily: 'Unbounded',
          color: Colors.white54,
        ),
        child: AnimatedTextKit(
          animatedTexts: [
            TypewriterAnimatedText('create a player for a game', speed: Duration(milliseconds: 150)),
            TypewriterAnimatedText('easily add, remove, and edit names', speed: Duration(milliseconds: 150)),
            TypewriterAnimatedText('randomly select a player', speed: Duration(milliseconds: 150)),
            TypewriterAnimatedText('keep track of who\'s turn it is', speed: Duration(milliseconds: 150)),
          ],
        ),
      ),
    );
  }
}