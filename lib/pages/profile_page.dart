import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:karatahta/components/text_box.dart';

class ProfilePage extends StatefulWidget {
  final VoidCallback toggleTheme;
  final bool isDarkMode;

  const ProfilePage({super.key, required this.toggleTheme, required this.isDarkMode});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final usersCollection = FirebaseFirestore.instance.collection("Users");

   // Kullanıcı verilerini Firestore'dan almak için bir future tanımlıyoruz
  Future<Map<String, dynamic>> fetchUserData() async {
    DocumentSnapshot userDoc =
        await usersCollection.doc(currentUser.email).get();
    return userDoc.data() as Map<String, dynamic>;
  }

  Future<void> editField(String field, String currentValue) async {
    String newValue = currentValue;
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text(
          "$field düzenle",
          style: const TextStyle(color: Colors.white),
        ),
        content: TextField(
          autocorrect: true,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: "Yeni Bir $field Girin",
            hintStyle: const TextStyle(color: Colors.grey),
          ),
          controller: TextEditingController(text: currentValue),
          onChanged: (value) {
            newValue = value;
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'İptal',
              style: TextStyle(color: Colors.white),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(newValue),
            child: const Text(
              'Kaydet',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );

    // Firestore'da güncelle
    if (newValue.trim().isNotEmpty && newValue != currentValue) {
      await usersCollection.doc(currentUser.email).update({field: newValue});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profil"),
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              widget.isDarkMode ? Icons.nightlight_round : Icons.wb_sunny,
              color: Theme.of(context).iconTheme.color,
            ),
            onPressed: widget.toggleTheme,
          ),
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Hata: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Kullanıcı Profili Bulunamadı.'));
          }

          final userData = snapshot.data!;
          final username = userData['username'] ?? 'Unknown username';
          final bio = userData['bio'] ?? 'Boş Biyografi';

          return ListView(
            children: [
              const SizedBox(height: 50),
              const Icon(
                Icons.person,
                size: 72,
              ),
              Text(
                currentUser.email!,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[700]),
              ),
              const SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: Text(
                  'Detaylar',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
              ListTile(
                title: Text(
                  'Kullanıcı Adı',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(username),
                trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => editField('username', username),
                ),
              ),
              const Divider(),
              ListTile(
                title: Text(
                  'Biyografi',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(bio),
                trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => editField('bio', bio),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}


