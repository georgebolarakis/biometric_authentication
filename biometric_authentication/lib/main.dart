// import 'package:bio_auth/pages/home.dart';
// import 'package:bio_auth/pages/Register.dart';
// import 'package:bio_auth/pages/login.dart';
// import 'package:bio_auth/pages/onboarding.dart';
// import 'package:bio_auth/pages/passcod.dart';
// import 'package:bio_auth/pages/setupPincode.dart';
// import 'package:bio_auth/services/AuthenticationService.dart';
import 'package:biometric_authenticatio_third/pages/Register.dart';
import 'package:biometric_authenticatio_third/pages/home.dart';
import 'package:biometric_authenticatio_third/pages/login.dart';
import 'package:biometric_authenticatio_third/pages/onboarding.dart';
import 'package:biometric_authenticatio_third/pages/passcode.dart';
import 'package:biometric_authenticatio_third/pages/setupPincode.dart';
import 'package:biometric_authenticatio_third/services/AuthenticatioService.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

//we are implementing the state of the app and when it is launching
class _MyAppState extends State<MyApp> {
  //we check if this is a new user
  bool isNewUser = true;

  @override
  void initState() {
    super.initState();
    //when the app is launching we check the status of the user
    getUserStatus();
  }

  Future<void> getUserStatus() async {
    // we check if the pin code is there
    //if the user exists we switch navigation
    final val = await authService.read('pin');
    if (val.isNotEmpty) {
      setState(() {
        //this is not a new user
        isNewUser = false;
      });
    }
    //we add the value to the controller
    authService.isNewUserController.add(isNewUser);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: FutureBuilder<String>(
        future: authService.read('pin'),
        builder: (context, snapshot) {
          //if the connection is waiting we return an indicator
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
                body: Center(
              child: CircularProgressIndicator(),
            ));
          }
          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return PasscodePage();
          }
          return RegisterPage();
        },
      ),
       routes: {
        'home': (builder) => MyHomePage(),
        'login': (context) => LoginPage(),
        'register': (context) => RegisterPage(),
        'onboarding': (context) => OnboardingPage(),
        'setPincodeScreen': (context) => SetupPincode()
      },
    );
  }
}
