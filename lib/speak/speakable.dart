import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class SpeakableText extends StatelessWidget {
  final String text;
  final FlutterTts tts = FlutterTts();

  SpeakableText({required this.text});

  void speakText() async {
    await tts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: speakText,
      child: Text(text),
    );
  }
}
