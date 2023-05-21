import 'package:flutter/material.dart';

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
          color: Colors.white, borderRadius: BorderRadius.circular(8)),
      margin: EdgeInsets.only(top: 25, left: 25, right: 25),
      padding: EdgeInsets.all(25),
      child: Row(
        children: [
          // profile pic

          // message and user post
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user,
                style: TextStyle(color: Colors.grey[200]),
              ),
              const SizedBox(height: 20),
              Text(message),
            ],
          )
        ],
      ),
    );
  }
}
