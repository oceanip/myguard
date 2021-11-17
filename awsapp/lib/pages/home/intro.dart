import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:introduction_screen/introduction_screen.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    const pageDeco = const PageDecoration(
      titleTextStyle: TextStyle(
          fontSize: 28.0,
          color: Color(0xFF00695C),
          fontWeight: FontWeight.w700),
      bodyTextStyle: TextStyle(
        fontSize: 20.0,
        color: Color(0xFF009C89),
        fontWeight: FontWeight.w500,
        height: 1.4,
      ),
      descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      bodyFlex: 2,
      imageFlex: 4,
      bodyAlignment: Alignment.bottomCenter,
      imageAlignment: Alignment.topCenter,
    );

    return Scaffold(
      body: IntroductionScreen(
        globalBackgroundColor: Colors.white,
        pages: [
          PageViewModel(
            title: "Welcome to MyGuard",
            body:
                "In MyGuard, all images captured by the system will be seen after sensors are triggered",
            image: Image.asset('assets/images/logo-512.png'),
            decoration: pageDeco,
            reverse: true,
          ),
          PageViewModel(
            title: "Home Screen",
            body: "You can view the latest captured image in here",
            image: Image.asset('assets/images/intro-1.png'),
            decoration: pageDeco,
            reverse: true,
          ),
          PageViewModel(
            title: "Log History",
            body:
                "You can review all previous images in the log screen (sensor filter option for multiple sensors).",
            image: Image.asset('assets/images/intro-3.png'),
            decoration: pageDeco,
            reverse: true,
          ),
          PageViewModel(
            title: "Deatil Log",
            body:
                "You can zoom in one image with long-pressing the log thumbnail (timestamp provided).",
            image: Image.asset('assets/images/intro-4.png'),
            decoration: pageDeco,
            reverse: true,
          ),
          PageViewModel(
            title: "Face Recognition",
            body:
                "MyGuard will help you to verify the person in the captured image.",
            image: Image.asset('assets/images/intro-5.png'),
            decoration: pageDeco,
            reverse: true,
          ),
        ],
        onDone: () {
          Navigator.of(context)
              .pushNamedAndRemoveUntil('/home', (route) => false);
        },
        onSkip: () {
          Navigator.of(context)
              .pushNamedAndRemoveUntil('/home', (route) => false);
        },
        color: Colors.teal[800],
        showSkipButton: true,
        showDoneButton: true,
        showNextButton: true,
        skipFlex: 0,
        nextFlex: 0,
        skip: const Text("Skip"),
        next: const Icon(Icons.arrow_forward, size: 25.0),
        done: const Icon(
          Icons.done,
          size: 25.0,
        ),
        dotsDecorator: DotsDecorator(
          size: const Size.square(10.0),
          activeSize: const Size(20.0, 10.0),
          activeShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(25.0)),
          ),
          activeColor: Colors.lightGreen,
          color: Colors.teal,
        ),
      ),
    );
  }
}
