import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:alan_voice/alan_voice.dart';

import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:twitblind/components/drawer.dart';
import 'package:flutter_tts/flutter_tts.dart';
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
  final _controller = ScrollController();

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
        "339db7a281081921741107096e86a3342e956eca572e1d8b807a3e2338fdd0dc/stage",
        buttonAlign: AlanVoice.BUTTON_ALIGN_LEFT);

    // /// Handle commands from Alan AI Studio
    AlanVoice.onCommand.add((command) => _handleCommand(command.data));
  }
  final FlutterTts tts = FlutterTts();

  void signOut() {
    FirebaseAuth.instance.signOut();
  }

  void postMessage() async {
    //only post if something is in the textfield
    if (textController.text.isNotEmpty) {
      // Store in firebase
      await FirebaseFirestore.instance.collection("User Posts").add({
        'UserEmail': currentUser.email,
        'Message': textController.text,
        'TimeStamp': Timestamp.now(),
      });
    }
    textController.clear();
  }

  // Sign in command Alan AI
  void _handleCommand(Map<String, dynamic> command) {
    switch (command["command"]) {
      case "Sign out":
        signOut();
        break;
      case "getTweet":
        textController.text = command["text"];
        Timer(const Duration(seconds: 5), () {
          postMessage();
        });
        break;
      case "Profile page":
        goToProfile();
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
      body: Column(
        children: [
          // Feed
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("User Posts")
                  .orderBy("TimeStamp", descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                    if (_controller.hasClients) {
                      _controller.animateTo(
                          _controller.position.maxScrollExtent,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut);
                    }
                  });
                  return ListView.builder(
                    controller: _controller,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      // get the message
                      final post = snapshot.data!.docs[index];
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                        child: GestureDetector(
                          onTap: () async {
                            var username =
                                post['UserEmail'].toString().split('@');
                            await tts.speak(username[0] +
                                "tweeted " +
                                post['Message'].toString());
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            elevation: 10,
                            child: FeedPost(
                              message: post['Message'],
                              user: post['UserEmail'],
                            ),
                          ),
                        ),
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
                  child:
                      // MyTextField(

                      //   controller: textController,
                      //   hintText: 'Write something in the feed',
                      //   obscureText: false,
                      // ),
                      TextField(
                    maxLines: 6,
                    minLines: 1,
                    controller: textController,
                    obscureText: false,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[100],
                      focusColor: Colors.white,
                      labelText: 'Write something in the feed',
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(width: 1, color: Colors.blue),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                            width: 1,
                            color: Theme.of(context).unselectedWidgetColor),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(),
                      ),
                    ),
                  ),
                ),
                //Post button
                IconButton(
                  onPressed: () {
                    postMessage();
                  },
                  icon: const Icon(Icons.arrow_circle_up),
                )
              ],
            ),
          ),
          // loggin is as
          Text("Logged in as:" + currentUser.email!),
        ],
      ),
    );
  }
}
