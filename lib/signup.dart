import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'email_login.dart';
import 'email_signup.dart';
import 'home.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool isLoading = false;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  DatabaseReference dbRef =
      FirebaseDatabase.instance.reference().child("Users");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Sign Up'),
        ),
        body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <
              Widget>[
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Text("Test App",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
            ),
            Padding(
                padding: EdgeInsets.all(10.0),
                child: SignInButton(
                  Buttons.Email,
                  text: "Sign up with Email",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EmailSignUp()),
                    );
                  },
                )),
            Padding(
                padding: EdgeInsets.all(10.0),
                child: isLoading
                    ? CircularProgressIndicator()
                    : SignInButton(
                        Buttons.Google,
                        text: "Sign up with Google",
                        onPressed: () {
                          signInWithGoogle();
                        },
                      )),
            Padding(
                padding: EdgeInsets.all(10.0),
                child: GestureDetector(
                    child: Text("Log In Using Email",
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Colors.blue)),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => EmailLogIn()),
                      );
                    }))
          ]),
        ));
  }

  Future<String?> signInWithGoogle() async {
    final GoogleSignIn _googleSignIn = GoogleSignIn();

    isLoading = true;
    setState(() {});
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      await firebaseAuth.signInWithCredential(credential);
      isLoading = false;
      setState(() {});
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                Home(uid: firebaseAuth.currentUser?.displayName ?? '')),
      );
    } on FirebaseAuthException catch (e) {
      print('Achuuuuu_ ${e.message}');
      throw e;
    }
  }
}
