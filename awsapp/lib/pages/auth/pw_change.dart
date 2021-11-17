import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// AWS Amplify
import 'package:amplify_flutter/amplify.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';

class changePassword extends StatefulWidget {
  const changePassword({Key? key}) : super(key: key);

  @override
  _changePasswordState createState() => _changePasswordState();
}

class _changePasswordState extends State<changePassword> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _oldpassController = TextEditingController();
  TextEditingController _newpassController = TextEditingController();

  void ModifyPassword(String oldPass, String newPass) async {
    try {
      await Amplify.Auth.updatePassword(
        oldPassword: oldPass,
        newPassword: newPass,
      );
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Change Password"),
            content: Text('Your password is successfully changed'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/setting');
                },
                child: Text(
                  'Okay',
                  style: TextStyle(color: Colors.teal[800], fontSize: 18),
                ),
              ),
            ],
          );
        },
      );
    } on AuthException catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error!"),
            content: Text('${e.message}'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Okay',
                  style: TextStyle(color: Colors.teal[800], fontSize: 18),
                ),
              ),
            ],
          );
        },
      );
    }
  }

  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Scaffold(
      appBar: AppBar(
        title: Text("Change Password"),
        backgroundColor: Colors.teal[800],
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: TextFormField(
                    obscureText: true,
                    controller: _oldpassController,
                    decoration: InputDecoration(
                      labelText: "Enter Old Password",
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter Valid Old Password';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: TextFormField(
                    obscureText: true,
                    controller: _newpassController,
                    decoration: InputDecoration(
                      labelText: "Enter New Password",
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter Valid New Password';
                      }
                      return null;
                    },
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 20.0, bottom: 20.0),
                  child: Text(
                    '● 8 or more character\n● include at least a number',
                    style: TextStyle(
                      color: Color(0xFF616161),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: SizedBox(
                    width: double.maxFinite,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          ModifyPassword(
                              _oldpassController.text, _newpassController.text);
                        }
                      },
                      child: Text('Change Password'),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.teal[800],
                        textStyle: TextStyle(fontSize: 20.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
