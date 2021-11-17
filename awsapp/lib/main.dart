import 'package:flutter/material.dart';

// Other Pages
import 'package:awsapp/pages/auth/auth.dart';
import 'package:awsapp/pages/auth/email_confirm.dart';
import 'package:awsapp/pages/auth/pw_change.dart';
import 'package:awsapp/pages/auth/sign_in.dart';
import 'package:awsapp/pages/home/home.dart';
import 'package:awsapp/pages/home/intro.dart';
import 'package:awsapp/pages/home/logs.dart';
import 'package:awsapp/pages/home/setting.dart';
import 'package:splashscreen/splashscreen.dart';
import 'pages/auth/sign_up.dart';
import 'services/global.dart'; // global variable

// AWS Amplify
import 'amplifyconfiguration.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:amplify_analytics_pinpoint/amplify_analytics_pinpoint.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:amplify_datastore/amplify_datastore.dart';
import 'models/ModelProvider.dart';

Future<void> main() async {
  runApp(InitAWS());
}

class InitAWS extends StatefulWidget {
  @override
  _InitAWSState createState() => _InitAWSState();
}

class _InitAWSState extends State<InitAWS> {
  @override
  initState() {
    super.initState();
    _configureAmplify();
  }

  void _configureAmplify() async {
    AmplifyAnalyticsPinpoint analyticsPlugin = AmplifyAnalyticsPinpoint();
    AmplifyAuthCognito authPlugin = AmplifyAuthCognito();
    AmplifyStorageS3 storagePlugin = AmplifyStorageS3();
    AmplifyDataStore datastorePlugin =
        AmplifyDataStore(modelProvider: ModelProvider.instance);
    await Amplify.addPlugins([
      authPlugin,
      storagePlugin,
      analyticsPlugin,
      datastorePlugin,
    ]);

    // await Amplify.addPlugin(AmplifyAPI());

    try {
      await Amplify.configure(amplifyconfig);
      print("Amplify is configured");
    } on AmplifyAlreadyConfiguredException catch (e) {
      print("Amplify was already configured.");
      print(e);
    }

    // listen Auth events
    Amplify.Hub.listen([HubChannel.Auth], (hubEvent) {
      switch (hubEvent.eventName) {
        case "SIGNED_IN":
          print("USER IS SIGNED IN");
          setState(() {
            isLoggedIn = true;
          });
          break;
        case "SIGNED_OUT":
          print("USER IS SIGNED OUT");
          setState(() {
            isLoggedIn = false;
          });
          break;
        case "SESSION_EXPIRED":
          print("USER IS SIGNED IN");
          setState(() {
            isLoggedIn = true;
          });
          break;
      }
      print("finish listening");
    });
  }

  @override
  Widget build(BuildContext context) {
    return MyApp();
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Guard',
      theme: ThemeData(primaryColor: Colors.teal[800]),
      routes: Navigate.routes,
      initialRoute: '/',
    );
  }
}

// Navgator to each page / feature
class Navigate {
  static Map<String, Widget Function(BuildContext)> routes = {
    '/': (context) => WelcomeScreen(),
    '/home': (context) => HomePage(),
    '/auth': (context) => AuthPage(),
    '/sign-up': (context) => SignUpPage(),
    '/sign-in': (context) => SignInPage(),
    '/email': (context) => EmailConfirmPage(),
    '/pass': (context) => changePassword(),
    '/log': (context) => LogPage(),
    '/setting': (context) => SettingPage(),
    '/intro': (context) => IntroPage(),
  };
}

// Splash Screen (Welcome Screen)
class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new SplashScreen(
      seconds: 4,
      navigateAfterSeconds: isLoggedIn ? new HomePage() : new AuthPage(),
      title: Text(""),
      image: Image.asset('assets/images/logo-512.png', fit: BoxFit.scaleDown),
      backgroundColor: Colors.white,
      styleTextUnderTheLoader: new TextStyle(),
      photoSize: 100.0,
      onClick: () => print("flutter"),
      loaderColor: Colors.teal[800],
      loadingText: Text('Loading'),
      loadingTextPadding: EdgeInsets.all(10.0),
      useLoader: true,
    );
  }
}
