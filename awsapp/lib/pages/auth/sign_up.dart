import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// AWS Amplify
import 'package:amplify_flutter/amplify.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  bool isSignUpComplete = false;
  bool editingUserName = false;
  bool editingPassword = false;

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passController = TextEditingController();
  TextEditingController _nameController = TextEditingController();

  // regiester User
  void registerUser(String email, String name, String password) async {
    try {
      SignUpResult res = await Amplify.Auth.signUp(
        username: name,
        password: password,
        options: CognitoSignUpOptions(userAttributes: {
          'email': email,
          'name': name,
        }),
      );
      setState(() {
        isSignUpComplete = res.isSignUpComplete;
      });
      print("user " + name + " signed up");
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Check Inbox"),
            content: Text(
                "Please check your email inbox and enter your verification code before your first time sign-in"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/auth');
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

  @override
  Widget build(BuildContext context) {
    const hinttext = const TextStyle(
      color: Color(0xFF616161),
      // fontStyle: FontStyle.italic,
    );
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Up"),
        backgroundColor: Colors.teal[800],
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                // username input
                Padding(
                  padding: (editingUserName)
                      ? EdgeInsets.only(
                          left: 20.0, right: 20.0, top: 20.0, bottom: 5.0)
                      : EdgeInsets.all(20.0),
                  child: TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: "Enter username",
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        editingUserName = true;
                        editingPassword = false;
                      });
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter username';
                      }
                      return null;
                    },
                  ),
                ),
                // username hint
                Visibility(
                  visible: editingUserName,
                  child: new Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: 20.0),
                    child: Text(
                        '● not accepted blank space\n● cannot be changed afterward',
                        style: hinttext),
                  ),
                ),

                // email input
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: "Enter Email",
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        editingUserName = false;
                        editingPassword = false;
                      });
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter Email';
                      }
                      return null;
                    },
                  ),
                ),
                // password input
                Padding(
                  padding: (editingPassword)
                      ? EdgeInsets.only(
                          left: 20.0, right: 20.0, top: 20.0, bottom: 5.0)
                      : EdgeInsets.all(20.0),
                  child: TextFormField(
                    obscureText: true,
                    controller: _passController,
                    decoration: InputDecoration(
                      labelText: "Enter Password",
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        editingUserName = false;
                        editingPassword = true;
                      });
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter Password';
                      }
                      return null;
                    },
                  ),
                ),
                // password hint
                Visibility(
                  visible: editingPassword,
                  child: Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: 20.0),
                    child: Text(
                        '● 8 or more character\n● include at least a number',
                        style: hinttext),
                  ),
                ),

                // sumbit the sign up form
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: SizedBox(
                    width: double.maxFinite,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          registerUser(_emailController.text,
                              _nameController.text, _passController.text);
                        }
                      },
                      child: Text('Sign Up'),
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
