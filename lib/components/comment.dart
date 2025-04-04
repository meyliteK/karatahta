import 'package:flutter/material.dart';

class Comment extends StatelessWidget {
  final String text;
  final String user;
  final String time;

  const Comment({
    super.key,
    required this.text,
    required this.user,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(4),
      ),
      margin: const EdgeInsets.only(bottom: 5),
      padding: const EdgeInsets.all(15),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(text, style: TextStyle(fontSize:16)),
        const SizedBox(height: 5),
        Row(
          children: [
            Text(
              user,
              style: TextStyle(color: Theme.of(context).colorScheme.onSecondary,fontSize:13),
            ),
            Text(" - ", style: TextStyle(color: Theme.of(context).colorScheme.onSecondary,fontSize:13)),
            Text(time, style: TextStyle(color: Theme.of(context).colorScheme.onSecondary,fontSize:13)),
          ],
        ),
      ]),
    );
  }
}
