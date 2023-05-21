// import 'package:flutter/material.dart';
// import 'package:speech_to_text/speech_to_text.dart';
// import 'package:flutter_tts/flutter_tts.dart';
// import 'package:twitblind/pages/home_page.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class SpeechToTextButton extends StatefulWidget {
//   @override
//   _SpeechToTextButtonState createState() => _SpeechToTextButtonState();
// }

// class _SpeechToTextButtonState extends State<SpeechToTextButton> {
//   SpeechToText stt = SpeechToText();
//   late FlutterTts _flutterTts;
//   bool _isListening = false;
//   String _text = '';

//   final currentUser = FirebaseAuth.instance.currentUser!;
//   final textController = TextEditingController();

//   @override
//   void initState() {
//     // initializeAudio();
//     super.initState();
//     // _speechToText = stt.SpeechToText();
//     // _flutterTts = FlutterTts();
//   }

//   // initializeAudio async() {
//   //   stt.initialize();
//   // }

//   void _startListening() {
//     if(stt.isAvailable) {
//       if(!_isListening) {
//         stt.listen(onResult: (result){
//           setState(() {
//             _text = result.recognizedWords;
//             _isListening = true;
//           });
//         });
//       }
//       else {
//         setState(() {
//           _isListening = false;
//         stt.stop();
//         });
//       }
//     }
//   }

//   // void _stopListening() {
//   //   stt.stop();
//   //   setState(() {
//   //     _isListening = false;
//   //   });
//   // }

//   // Implement your tweet posting logic here
//   // You can use the _text variable to access the recognized text
//   // and post it to your Twitter clone backend
//   void postMessage() {
//     //only post if something is in the textfield
//     if (textController.text.isNotEmpty) {
//       // Store in firebase
//       FirebaseFirestore.instance.collection("User Posts").add({
//         'UserEmail': currentUser.email,
//         'Message': _text,
//         'TimeStamp': Timestamp.now(),
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         // IconButton(
//           floatingActionButton: FloatingActionButton(
//             onPressed: _startListening(),
//             tooltip: 'Increment',
//             child: Icon(isListening ? Icons.pause_circle_filled : Icons.play_circle_filled),
//           // icon: _isListening ? Icon(Icons.mic_off) : Icon(Icons.mic),
//           // onPressed: () {
//           //   if (_isListening) {
//           //     _stopListening();
//           //     postMessage();
//           //   } else {
//           //     _startListening();
//           //   }
//         ),
//         Text(_text),
//       ],
//     );
//   }
// }
