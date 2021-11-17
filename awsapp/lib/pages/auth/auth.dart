import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AuthPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Scaffold(
        appBar: AppBar(
          title: Text("My Guard"),
          backgroundColor: Colors.teal[800],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(20.0),
                child: Image.asset(
                  'assets/images/logo-192.png',
                  height: 100.0,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: 20.0, left: 40.0, right: 40.0, bottom: 20.0),
                child: SizedBox(
                  width: double.maxFinite,
                  child: ElevatedButton(
                    child: Text('Sign Up'),
                    onPressed: () {
                      Navigator.pushNamed(context, '/sign-up');
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.teal[800],
                      textStyle: TextStyle(fontSize: 18.0),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: 20.0, left: 40.0, right: 40.0, bottom: 20.0),
                child: SizedBox(
                  width: double.maxFinite,
                  child: ElevatedButton(
                    child: Text('Sign In'),
                    onPressed: () {
                      Navigator.pushNamed(context, '/sign-in');
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.teal[800],
                      textStyle: TextStyle(fontSize: 18.0),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 40.0),
                child: Text(
                  'please create an account \nif this is your first time using MyGuard',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      height: 1.7,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey[800]),
                ),
              ),
            ],
          ),
        ));
  }
}
