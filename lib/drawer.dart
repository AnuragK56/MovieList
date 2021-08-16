import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
 
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: const EdgeInsets.all(0),
        children: <Widget>[
          UserAccountsDrawerHeader(
              accountName: Text("Anurag Kandalkar "),
              accountEmail: Text("test@gmail1.com"),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(
                    "https://images.unsplash.com/photo-1531891437562-4301cf35b7e4?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=400&q=80"),
              )),
          ListTile(
            leading: Icon(Icons.person),
            title: Text("Anurag Kandalkar"),
            subtitle: Text("Developer"),
            trailing: Icon(Icons.edit),
          ),
          ListTile(
            leading: Icon(Icons.email),
            title: Text("Email"),
            subtitle: Text("test@gmail.com"),
            trailing: Icon(Icons.edit),
          )
        ],
      ),
    );
  }
}
