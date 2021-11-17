import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// AWS Amplify
import 'package:amplify_flutter/amplify.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';

class EmailConfirmPage extends StatefulWidget {
  @override
  _EmailConfirmPageState createState() => _EmailConfirmPageState();
}

class _EmailConfirmPageState extends State<EmailConfirmPage> {
  final _formKey = GlobalKey<FormState>();
  bool isSignUpComplete = false;

  TextEditingController _nameController = TextEditingController();
  TextEditingController _codeController = TextEditingController();

  void confirmUser(String name, String code) async {
    try {
      SignUpResult res = await Amplify.Auth.confirmSignUp(
          username: name, confirmationCode: code);
      setState(() {
        isSignUpComplete = res.isSignUpComplete;
      });
      print("user is confirmed");
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Congrat"),
            content: Text("Your Account is now activated"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/sign-in');
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
      print(e.message);
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
        title: Text("Email Confirmation"),
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
                  controller: _codeController,
                  decoration: InputDecoration(
                    labelText: "Verificaiton Code",
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter Verificaiton Code';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20.0),
                child: SizedBox(
                  width: double.maxFinite,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        confirmUser(_nameController.text, _codeController.text);
                      }
                    },
                    child: Text('Verify'),
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
