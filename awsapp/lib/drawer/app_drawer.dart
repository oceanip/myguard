import 'package:flutter/material.dart';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  Future<void> signOut() async {
    try {
      Amplify.Auth.signOut();
    } on AuthException catch (e) {
      print(e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            AppBar(
              title: Text('My Guard'),
              automaticallyImplyLeading: false,
              backgroundColor: Colors.teal[800],
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                Navigator.pushNamed(context, '/home');
              },
            ),
            Divider(
              color: Colors.teal[800],
              thickness: 1.0,
              endIndent: 25.0,
            ),
            ListTile(
              leading: Icon(Icons.description_outlined),
              title: Text('Log History'),
              onTap: () {
                Navigator.pushNamed(context, '/log');
              },
            ),
            Divider(
              color: Colors.teal[800],
              thickness: 1.0,
              endIndent: 25.0,
            ),
            ListTile(
              leading: Icon(Icons.settings_outlined),
              title: Text('Settings'),
              onTap: () {
                Navigator.pushNamed(context, '/setting');
              },
            ),
            Divider(
              color: Colors.teal[800],
              thickness: 1.0,
              endIndent: 25.0,
            ),
            ListTile(
              leading: Icon(
                Icons.exit_to_app_outlined,
                color: Colors.red,
              ),
              title: Text('Sign Out', style: TextStyle(color: Colors.red)),
              onTap: () {
                signOut();
                Navigator.of(context)
                    .pushNamedAndRemoveUntil('/auth', (route) => false);
              },
            ),
            Divider(
              color: Colors.teal[800],
              thickness: 1.0,
              endIndent: 25.0,
            ),
          ],
        ),
      ),
    );
  }
}
