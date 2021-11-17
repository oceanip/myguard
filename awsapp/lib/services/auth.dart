import 'dart:async';
import 'package:amplify_analytics_pinpoint/amplify_analytics_pinpoint.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:flutter/material.dart';

import 'package:awsapp/amplifyconfiguration.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_core/amplify_core.dart';
import 'package:amplify_flutter/amplify.dart';

class Auth extends ChangeNotifier {
  bool isSignUp = false;
  bool isSignIn = false;
  String? username;

  Auth() {
    _configureAmplify();
  }

  void _configureAmplify() async {
    AmplifyAnalyticsPinpoint analyticsPlugin = AmplifyAnalyticsPinpoint();
    AmplifyAuthCognito authPlugin = AmplifyAuthCognito();
    AmplifyStorageS3 storagePlugin = AmplifyStorageS3();
    await Amplify.addPlugins([authPlugin, storagePlugin, analyticsPlugin]);

    try {
      await Amplify.configure(amplifyconfig);
    } on AmplifyAlreadyConfiguredException {
      print("Amplify was already configured.");
    }

    // listen Auth events
    Amplify.Hub.listen([HubChannel.Auth], (hubEvent) {
      switch (hubEvent.eventName) {
        case "SIGNED_IN":
          print("USER IS SIGNED IN");
          isSignIn = true;
          break;
        case "SIGNED_OUT":
          print("USER IS SIGNED OUT");
          isSignIn = false;
          break;
        case "SESSION_EXPIRED":
          print("USER IS SIGNED IN");
          isSignIn = true;
          break;
      }
    });
  }

  // Sign up
  // Future<void> signUp(String username, String password, String email) async {

  // Confirm User
  // Future<void> confirm(String username, String confirmationCode) async {

  // Sign in
  // Future<void> signIn(String username, String password) async {

  // Sign out
  // Future<void> signOut() async {

  // check is sign in
  // Future<bool> _isSignedIn() async {
  //   final session = await Amplify.Auth.fetchAuthSession();
  //   return session.isSignedIn;
  // }

  // get auth session
  Future<String> fetchSession() async {
    try {
      AuthSession session = await Amplify.Auth.fetchAuthSession(
        options: CognitoSessionOptions(getAWSCredentials: true),
      );

      return session.isSignedIn.toString();
    } on AuthException catch (e) {
      print(e);
      throw (e);
    }
  }

  // get current user
  Future<String> getCurrentUser() async {
    try {
      AuthUser res = await Amplify.Auth.getCurrentUser();
      return res.username;
    } on AuthException catch (e) {
      print(e);
      throw (e);
    }
  }
}
