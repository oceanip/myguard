import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:awsapp/drawer/app_drawer.dart';

// AWS Amplify
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  String? name = 'demo'; // user name
  String? email = 'demo@example.com'; // user email
  bool _editInfo = false; // status of edit mode

  TextEditingController _nameController = TextEditingController();

  Future<bool> _fetchData() => Future.delayed(Duration(seconds: 0), () async {
        try {
          var att =
              await Amplify.Auth.fetchUserAttributes(); // get user attribute
          name = att[2].value; // get user name
          email = att[3].value; // get user email
          print("*****user: " + name! + " email: " + email! + "*****");
        } on AuthException catch (e) {
          print(e.message);
        }
        return true;
      });

  Future<void> _update(String newName) async {
    if (_nameController.text == '') {
      newName = name!;
    }

    try {
      await Amplify.Auth.updateUserAttribute(
        userAttributeKey: 'name',
        value: newName,
      );
      print('updated name: ' + newName);
    } on AuthException catch (e) {
      print(e.message);
    }
  }

  Future<void> signOut() async {
    try {
      Amplify.Auth.signOut();
    } on AuthException catch (e) {
      print(e.message);
    }
  }

  @override
  Widget build(BuildContext context) => FutureBuilder(
      future: _fetchData(), // fetch the user info before loading in
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          SystemChrome.setPreferredOrientations([
            DeviceOrientation.portraitUp,
            DeviceOrientation.portraitDown,
          ]);
          return Scaffold(
            appBar: AppBar(
              title: Text("Settings"),
              backgroundColor: Colors.teal[800],
              actions: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      _editInfo = !_editInfo;
                    });
                    _update(_nameController.text);
                  },
                  icon: _editInfo ? Icon(Icons.done) : Icon(Icons.edit),
                ),
              ],
            ),
            drawer: AppDrawer(),
            body: Column(
              children: <Widget>[
                // display user name
                ListTile(
                  leading: Icon(Icons.person),
                  title: TextField(
                    controller: _nameController,
                    enabled: _editInfo,
                    decoration: InputDecoration(
                      hintText: name,
                      hintStyle: TextStyle(
                          color: _editInfo ? Colors.grey[500] : Colors.black),
                      contentPadding: new EdgeInsets.symmetric(vertical: 10.0),
                      border: _editInfo
                          ? UnderlineInputBorder(
                              borderSide: BorderSide(width: 1.0),
                            )
                          : InputBorder.none,
                    ),
                  ),
                ),
                Divider(thickness: 1.0),
                // display user email
                ListTile(
                  leading: Icon(Icons.mail),
                  title: Text(email!),
                ),
                Divider(thickness: 1.0),
                // change password
                ListTile(
                  leading: Icon(Icons.password),
                  title: Text(
                    'Change Password',
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, '/pass');
                  },
                ),
                Divider(thickness: 1.0),
                // sign out
                ListTile(
                  leading: Icon(
                    Icons.exit_to_app_outlined,
                    color: Colors.red,
                  ),
                  title: Text(
                    'Sign Out',
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () {
                    signOut();
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil('/auth', (route) => false);
                  },
                ),
                Divider(thickness: 1.0),
              ],
            ),
          );
        } else {
          return Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }
      });
}
