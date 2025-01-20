import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:karatahta/components/comment.dart';
import 'package:karatahta/components/comment_button.dart';
import 'package:karatahta/components/delete_button.dart';
import 'package:karatahta/components/like_button.dart';
import 'package:karatahta/helper/helper_methods.dart';

class WallPost extends StatefulWidget {
  final String message;
  final String user; // Kullanıcı adı için kullanılıyor
  final String time;
  final String postId;
  final List<String> likes;

  const WallPost({
    super.key,
    required this.message,
    required this.user,
    required this.time,
    required this.likes,
    required this.postId,
  });

  @override
  State<WallPost> createState() => _WallPostState();
}

class _WallPostState extends State<WallPost> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  bool isLiked = false;

  final _commentTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    isLiked = widget.likes.contains(currentUser.email);
  }

  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });

    DocumentReference postRef =
        FirebaseFirestore.instance.collection('User Posts').doc(widget.postId);

    if (isLiked) {
      postRef.update({
        'Likes': FieldValue.arrayUnion([currentUser.email])
      });
    } else {
      postRef.update({
        'Likes': FieldValue.arrayRemove([currentUser.email])
      });
    }
  }

  void addComment(String commentText) async {
    if (commentText.isNotEmpty) {
      // Kullanıcının username bilgisini al
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection("Users")
          .doc(currentUser.email)
          .get();

      String username = userDoc['username'];

      // Yorumu ekle
      FirebaseFirestore.instance
          .collection("User Posts")
          .doc(widget.postId)
          .collection("Comments")
          .add({
        "CommentText": commentText,
        "CommentedBy": username, // Kullanıcı adı eklendi
        "CommentTime": Timestamp.now()
      });
    }
  }

  void showCommentDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: _commentTextController,
          decoration: InputDecoration(hintText: "Bir Yorum Ekle.."),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);

              _commentTextController.clear();
            },
            child: Text("İptal"),
          ),
          TextButton(
            onPressed: () {
              // Yorum ekle
              addComment(_commentTextController.text);
              // Pencereden çık
              Navigator.pop(context);
              // Controller temizle
              _commentTextController.clear();
            },
            child: Text("Gönder"),
          ),
        ],
      ),
    );
  }

  void deletePost() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Gönderiyi Sil"),
        content: const Text("Bu gönderiyi silmek istediğine emin misin?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("İptal"),
          ),
          TextButton(
            onPressed: () async {
              final commentDocs = await FirebaseFirestore.instance
                  .collection("User Posts")
                  .doc(widget.postId)
                  .collection("Comments")
                  .get();

              for (var doc in commentDocs.docs) {
                await FirebaseFirestore.instance
                    .collection("User Posts")
                    .doc(widget.postId)
                    .collection("Comments")
                    .doc(doc.id)
                    .delete();
              }
              FirebaseFirestore.instance
                  .collection("User Posts")
                  .doc(widget.postId)
                  .delete()
                  .then((value) => print("Gönderi silindi"))
                  .catchError(
                      (error) => print("Failed to delete post: $error"));

              Navigator.pop(context);
            },
            child: const Text("Sil"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.only(top: 25, left: 25, right: 25),
      padding: const EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Post içerik
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Mesaj
                  Text(widget.message , style: TextStyle(fontSize:16)),
                  const SizedBox(height: 5),

                  Row(
                    children: [
                      Text(
                        widget.user, // Kullanıcı adı buraya alındı
                        style: TextStyle(color: Theme.of(context).colorScheme.onSecondary, fontSize:13),
                      ),
                      Text(" - ", style: TextStyle(color: Theme.of(context).colorScheme.onSecondary, fontSize:13)),
                      Text(widget.time,
                          style: TextStyle(color: Theme.of(context).colorScheme.onSecondary, fontSize:13 )),
                    ],
                  ),
                ],
              ),
              // Silme butonu
              if (widget.user == currentUser.email)
                DeleteButton(onTap: deletePost),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Beğeni
              Column(
                children: [
                  LikeButton(
                    isLiked: isLiked,
                    onTap: toggleLike,
                  ),

                  const SizedBox(height: 5),

                  // Beğeni sayısı
                  Text(
                    widget.likes.length.toString(),
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(width: 100),

              // Yorum
              Column(
                children: [
                  CommentButton(onTap: showCommentDialog),

                  const SizedBox(height: 5),

                  // Beğeni sayısı
                  Text(
                    '0',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(width: 20),
          // Yorumlar
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("User Posts")
                .doc(widget.postId)
                .collection("Comments")
                .orderBy("CommentTime", descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: snapshot.data!.docs.map((doc) {
                  final commentData = doc.data() as Map<String, dynamic>;

                  return Comment(
                    text: commentData["CommentText"],
                    user: commentData["CommentedBy"], // Kullanıcı adı buraya alındı
                    time: formatDate(commentData["CommentTime"]),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
