import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:karatahta/components/my_drawer.dart';
import 'package:karatahta/components/my_textfield.dart';
import 'package:karatahta/components/wall_post.dart';
import 'package:karatahta/helper/helper_methods.dart';

class HomePage extends StatefulWidget {
  final VoidCallback toggleTheme;
  final bool isDarkMode;

  const HomePage({super.key, required this.toggleTheme, required this.isDarkMode});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final textController = TextEditingController();

  void postMessage() {
    if (textController.text.isNotEmpty) {
      FirebaseFirestore.instance.collection("User Posts").add({
        'UserEmail': currentUser.email,
        'PostMessage': textController.text,
        'TimeStamp': Timestamp.now(),
        'Likes': [],
      });
    }

    setState(() {
      textController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text("Ana Sayfa"),
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(widget.isDarkMode ? Icons.nightlight_round : Icons.wb_sunny),
            onPressed: widget.toggleTheme,
          ),
        ],
      ),
      drawer: const MyDrawer(),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("User Posts")
                    .orderBy(
                      "TimeStamp",
                      descending: false,
                    )
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final post = snapshot.data!.docs[index];
                        return WallPost(
                          message: post['PostMessage'],
                          user: post['UserEmail'],
                          likes: List<String>.from(post['Likes'] ?? []),
                          postId: post.id,
                          time: formatDate(post['TimeStamp']),
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error:${snapshot.error}'),
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Row(
                children: [
                  Expanded(
                    child: MyTextField(
                      controller: textController,
                      hintText: 'Bir Şeyler Yaz...',
                      obscureText: false,
                    ),
                  ),
                  IconButton(
                    onPressed: postMessage,
                    icon: const Icon(Icons.edit),
                  )
                ],
              ),
            ),
            Text("${currentUser.email!} hesabıyla giriş yapıldı"),
          ],
        ),
      ),
    );
  }
}

