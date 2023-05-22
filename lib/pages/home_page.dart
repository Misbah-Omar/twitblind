import 'package:alan_voice/alan_voice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:twitblind/components/drawer.dart';
import 'package:twitblind/components/feed_post.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:twitblind/pages/profile_page.dart';

import '../components/my_textfield.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formkey = GlobalKey<FormState>;
  // speech to text
  // SpeechToText stt = SpeechToText();
  // // late FlutterTts _flutterTts;
  // bool _isListening = false;
  // String _text = '';
  // user
  final currentUser = FirebaseAuth.instance.currentUser!;
  final textController = TextEditingController();

  _HomePageState() {
    /// Init Alan Button with project key from Alan AI Studio
    AlanVoice.addButton(
        "a145b61158ba93cd321b2b77a19738aa2e956eca572e1d8b807a3e2338fdd0dc/stage",
        buttonAlign: AlanVoice.BUTTON_ALIGN_LEFT);

    /// Handle commands from Alan AI Studio
    AlanVoice.onCommand.add((command) => _handleCommand(command.data));
  }

  void signOut() {
    FirebaseAuth.instance.signOut();
  }

  void postMessage() {
    //only post if something is in the textfield
    if (textController.text.isNotEmpty) {
      // Store in firebase
      FirebaseFirestore.instance.collection("User Posts").add({
        'UserEmail': currentUser.email,
        'Message': textController.text,
        'TimeStamp': Timestamp.now(),
      });
    }
  }

  // Sign in command Alan AI
  void _handleCommand(Map<String, dynamic> command) {
    switch (command["command"]) {
      case "Sign out":
        signOut();
        break;
      case "getTweet":
        textController.text = command["text"];
        postMessage();
        break;
      default:
        debugPrint("wrong command");
    }
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }
  //  @override
  // void initState() {
  //   initializeAudio();
  //   super.initState();
  //   // _speechToText = stt.SpeechToText();
  //   // _flutterTts = FlutterTts();
  // }

  // initializeAudio() async{
  //   stt.initialize();
  // }

  // void _startListening() {
  //   if(stt.isAvailable) {
  //     if(!_isListening) {
  //       stt.listen(onResult: (result){
  //         setState(() {
  //           _text = result.recognizedWords;
  //           _isListening = true;
  //         });
  //       });
  //     }
  //     else {
  //       setState(() {
  //         _isListening = false;
  //       stt.stop();
  //       });
  //     }
  //   }
  // }

  // Navigate to profile page
  void goToProfile() {
    //pop menu drawer
    Navigator.pop(context);

    //Go to profile page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfilePage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: Text('TwitBlind'),
        actions: [
          IconButton(
            onPressed: signOut,
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      drawer: MyDrawer(
        onProfileTap: goToProfile,
        onSignOut: signOut,
      ),
      body: Center(
        child: Column(
          children: [
            // Feed
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("User posts")
                    .orderBy("TimeStamp", descending: false)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        // get the message
                        final post = snapshot.data!.docs[index];
                        return FeedPost(
                          message: post['message'],
                          user: post['user'],
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error + ${snapshot.error}'),
                    );
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
            // Tweet
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Row(
                children: [
                  //Textfield
                  Expanded(
                    // child: MyTextField(
                    //   controller: textController,
                    //   hintText: 'Write something in the feed',
                    //   obscureText: false,
                    // ),
                    child: TextFormField(
                      controller: textController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'please enter some text';
                        }
                        return null;
                      },
                    ),
                  ),
                  //Post button
                  IconButton(
                    onPressed: postMessage,
                    icon: const Icon(Icons.arrow_circle_up),
                  )
                ],
              ),
            ),
            // loggin is as
            Text("Logged in as:" + currentUser.email!),
          ],
        ),
      ),
    );
  }
}
