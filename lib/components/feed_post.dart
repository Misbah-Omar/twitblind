import 'package:flutter/material.dart';
import 'package:twitblind/speak/speakable.dart';

class FeedPost extends StatelessWidget {
  final String message;
  final String user;

  const FeedPost({
    super.key,
    required this.message,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      // margin: EdgeInsets.only(top: 25, left: 25, right: 25),
      padding: EdgeInsets.fromLTRB(20, 15, 20, 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            user,
            style: TextStyle(color: Colors.grey[400]),
          ),
          const SizedBox(height: 20),
          Text(
            message,
          ),
        ],
      ),
    );
  }
}
