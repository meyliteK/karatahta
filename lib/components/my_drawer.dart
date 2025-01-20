import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  void logout() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.tertiary,
      child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Column(
          children: [
            DrawerHeader(
              child: Icon(
                Icons.my_library_books,
                color: Colors.black,
                size: 100
              ),
            ),
            const SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.only(left: 25.0),
              child: ListTile(
                leading: Icon(
                  Icons.home,
                  color: Colors.black,
                ),
                title: const Text("ANA SAYFA"),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25.0),
              child: ListTile(
                leading: Icon(
                  Icons.person,
                  color: Colors.black,
                ),
                title: const Text("PROFİL"),
                onTap: () {
                  Navigator.pop(context);

                  Navigator.pushNamed(context, '/profile_page');
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25.0),
              child: ListTile(
                leading: Icon(
                  Icons.group,
                  color: Colors.black,
                ),
                title: const Text("KULLANICILAR"),
                onTap: () {
                  Navigator.pop(context);

                  Navigator.pushNamed(context, '/users_page');
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25.0),
              child: ListTile(
                leading: Icon(
                  Icons.edit,
                  color: Colors.black,
                ),
                title: const Text("GÖNDERİLERİM"),
                onTap: () {
                  Navigator.pop(context);

                  Navigator.pushNamed(context, '/posts_page');
                },
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 25.0, bottom: 25),
          child: ListTile(
            leading: Icon(
              Icons.logout,
              color: Colors.black,
            ),
            title: const Text("ÇIKIŞ YAP"),
            onTap: () {
              Navigator.pop(context);

              logout();
            },
          ),
        )
      ]),
    );
  }
}
