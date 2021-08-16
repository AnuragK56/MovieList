import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movielist/pages/login_page.dart';
import 'package:movielist/services/auth.dart';
import 'package:provider/provider.dart';

class MyDrawer extends StatefulWidget {
  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    print(user!.displayName);
    return Drawer( 
      child: ListView(
        padding: const EdgeInsets.all(0),
        children: <Widget>[
          // UserAccountsDrawerHeader(
          //     accountName: Text("Anurag Kandalkar "),
          //     accountEmail: Text("test@gmail1.com"),
          //     currentAccountPicture: CircleAvatar(
          //       backgroundImage: NetworkImage(
          //           "https://images.unsplash.com/photo-1531891437562-4301cf35b7e4?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=400&q=80"),
          //     )),
          UserAccountsDrawerHeader(
              accountName: Text(user!.displayName!),
              accountEmail: Text(user!.email!),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(user!.photoURL!),
              )),
          Align(
            alignment: Alignment.center,
            child: ListTile(
              title: Text("Sign Out", style: TextStyle(fontSize: 15)),
              trailing: Icon(Icons.exit_to_app),
              onTap: () {
                final provider =
                    Provider.of<GoogleSignInProvider>(context, listen: false);
                provider.logout();
                Navigator.pushReplacementNamed(context, LoginPage.routeName);
              },
            ),
          ),
        ],
      ),
    );
  }
}
