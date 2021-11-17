import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// AWS Amplify
import 'package:amplify_flutter/amplify.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  bool isSignedIn = false;

  TextEditingController _nameController = TextEditingController();
  TextEditingController _passController = TextEditingController();

  // Sign In User
  void signIn(String name, String password) async {
    try {
      SignInResult res = await Amplify.Auth.signIn(
        username: name.trim(),
        password: password.trim(),
      );
      setState(() {
        isSignedIn = res.isSignedIn;
      });
      print("User " + name + " is signed in");
      Navigator.pushNamed(context, '/intro');
    } on AuthException catch (e) {
      if (e.message == "There is already a user signed in.") {
        Navigator.pushNamed(context, '/intro');
      } else {
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
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign In"),
        backgroundColor: Colors.teal[800],
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(children: <Widget>[
              Padding(
                padding: EdgeInsets.all(20.0),
                child: TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: "User Name",
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter User Name';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20.0),
                child: TextFormField(
                  obscureText: true,
                  controller: _passController,
                  decoration: InputDecoration(
                    labelText: "Password",
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter Password';
                    }
                    return null;
                  },
                ),
              ),
              // sumbit the sign in form
              Padding(
                padding: EdgeInsets.all(20.0),
                child: SizedBox(
                  width: double.maxFinite,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        signIn(_nameController.text, _passController.text);
                      }
                    },
                    child: Text('Sign In'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.teal[800],
                      textStyle: TextStyle(fontSize: 20.0),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                child: SizedBox(
                  width: double.maxFinite,
                  child: ElevatedButton(
                    onPressed: () {
                      // goto EmailConfirmPage;
                      Navigator.pushNamed(context, '/email');
                    },
                    child: Text('Confirm Email'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.teal[800],
                      textStyle: TextStyle(fontSize: 20.0),
                    ),
                  ),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
