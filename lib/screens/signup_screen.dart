import 'package:cartapp/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:page_transition/page_transition.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SignUp'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                hintText: 'Enter Email',
              ),
            ),
            TextFormField(
              controller: passwordController,
              decoration: InputDecoration(
                hintText: 'Enter Password',
              ),
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
              child: Text('Sign Up'),
              onPressed: () async {
                if (_isValidate(
                  email: emailController.text,
                  password: passwordController.text,
                )) {
                  await _firebaseAuth
                      .createUserWithEmailAndPassword(
                          email: emailController.text,
                          password: passwordController.text)
                      .then((value) => Navigator.pushAndRemoveUntil(
                          context,
                          PageTransition(
                            type: PageTransitionType.rightToLeft,
                            duration: Duration(
                              milliseconds: 500,
                            ),
                            child: HomeScreen(),
                          ),
                          (route) => false))
                      .catchError((e) {
                    print('Error $e');
                    showToast(
                      'Some Error Please Try Again!',
                      context: context,
                      animation: StyledToastAnimation.slideFromBottom,
                      reverseAnimation: StyledToastAnimation.slideToBottom,
                      startOffset: Offset(0.0, 3.0),
                      reverseEndOffset: Offset(0.0, 3.0),
                      position: StyledToastPosition.bottom,
                      duration: Duration(seconds: 4),
                      animDuration: Duration(seconds: 1),
                      curve: Curves.elasticOut,
                      reverseCurve: Curves.fastOutSlowIn,
                    );
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  bool _isValidate({
    String email,
    String password,
  }) {
    if (email.isEmpty) {
      showToast(
        'Please Enter Valid Email',
        context: context,
        animation: StyledToastAnimation.slideFromBottom,
        reverseAnimation: StyledToastAnimation.slideToBottom,
        startOffset: Offset(0.0, 3.0),
        reverseEndOffset: Offset(0.0, 3.0),
        position: StyledToastPosition.bottom,
        duration: Duration(seconds: 4),
        animDuration: Duration(seconds: 1),
        curve: Curves.elasticOut,
        reverseCurve: Curves.fastOutSlowIn,
      );
      return false;
    }
    if (password.isEmpty) {
      showToast(
        'Please Enter Valid Password',
        context: context,
        animation: StyledToastAnimation.slideFromBottom,
        reverseAnimation: StyledToastAnimation.slideToBottom,
        startOffset: Offset(0.0, 3.0),
        reverseEndOffset: Offset(0.0, 3.0),
        position: StyledToastPosition.bottom,
        duration: Duration(seconds: 4),
        animDuration: Duration(seconds: 1),
        curve: Curves.elasticOut,
        reverseCurve: Curves.fastOutSlowIn,
      );
      return false;
    }
    return true;
  }
}
