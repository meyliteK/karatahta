import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:karatahta/components/my_list_tile.dart';
import 'package:karatahta/helper/helper_functions.dart';

class UsersPage extends StatelessWidget {
  final VoidCallback toggleTheme;
  final bool isDarkMode;

  const UsersPage({super.key, required this.toggleTheme, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kullanıcılar"),
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(isDarkMode ? Icons.nightlight_round : Icons.wb_sunny),
            onPressed: toggleTheme,
          ),
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("Users").snapshots(),
        builder: (context, snapshot) {
          //any errors
          if (snapshot.hasError) {
            displayMessageToUser("Something went wrong", context);
          }

          //show loading circle
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.data == null) {
            return const Text("Veri Yok");
          }

          //get all users
          final users = snapshot.data!.docs;

          return Column(
            children: [
              //back button
              const Padding(
                padding: EdgeInsets.only(
                  top: 50.0,
                  left: 25,
                ),
                /*child: Row(
                  children: [
                    MyBackButton(),
                  ],
                ),*/
              ),

              Expanded(
                child: ListView.builder(
                  itemCount: users.length,
                  padding: const EdgeInsets.all(0),
                  itemBuilder: (context, index) {
                    final user = users[index];

                    String username = user['username'];
                    //String email = user['email'];

                    return MyListTile(
                      title: username,
                      subTitle: username,
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}





