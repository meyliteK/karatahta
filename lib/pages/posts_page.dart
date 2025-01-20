import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:karatahta/components/text_box.dart';

class PostsPage extends StatelessWidget {
  final VoidCallback toggleTheme;
  final bool isDarkMode;

  const PostsPage({super.key, required this.toggleTheme, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    // Oturum açmış olan kullanıcının e-posta adresini alıyoruz
    final currentUserEmail = FirebaseAuth.instance.currentUser!.email;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Gönderilerim"),
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              isDarkMode ? Icons.nightlight_round : Icons.wb_sunny,
              color: Theme.of(context).iconTheme.color,
            ),
            onPressed: toggleTheme,
          ),
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: StreamBuilder(
        // Firestore'dan oturum açmış kullanıcıya ait verileri alıyoruz
        stream: FirebaseFirestore.instance
            .collection("User Posts") // Koleksiyon adı
            .where("UserEmail", isEqualTo: currentUserEmail) // E-posta ile filtreleme            
            .snapshots(),
        builder: (context, snapshot) {
          // Eğer bir hata oluştuysa
          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Bir hata oluştu: ${snapshot.error}",
                style: const TextStyle(fontSize: 16, color: Colors.red), // Varsayılan stil
              ),
            );
          }

          // Veriler yüklenirken gösterilecek yükleme çemberi
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // Eğer veri yoksa
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                "Henüz bir gönderi yapmadınız.",
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.onSurface, // Yüzey üzerindeki metin rengi
                ),
              ),
            );
          }

          // Kullanıcıya ait gönderiler
          final posts = snapshot.data!.docs;

          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];

              return Container(
                margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary, // Arka plan rengi
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Gönderi mesajı
                    Text(
                      post['PostMessage'],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSecondary, // Metin rengi
                      ),
                    ),
                    const SizedBox(height: 8.0),

                    // Gönderi tarihi
                    Text(
                      "Tarih: ${post['TimeStamp'] != null ? post['TimeStamp'].toDate().toString() : 'Zaman bilgisi yok'}",
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.onSurface, // Yüzey üzerindeki metin rengi
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

