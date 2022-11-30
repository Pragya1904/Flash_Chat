import 'dart:developer';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:flash/components/RoundedButton.dart';
import 'package:flash/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
class LoginScreen extends StatefulWidget {
  static const String id='login_screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth=FirebaseAuth.instance;
  bool showSpinner=false;
  late User loggedInUser;
  String password='';
  String email='';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }
  void getCurrentUser()async{
    try{
      final user=await _auth.currentUser;
      if(user!=null)
          loggedInUser=user;
    }
    catch(e)
    {
      print(e);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag:'logo',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  email=value;
                },
                style:kButtonTextStyle,
                decoration: kTextFieldDecoration.copyWith(hintText: "enter your email ID",labelText: "Email ID"),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                textAlign: TextAlign.center,
                obscureText: true,
                onChanged: (value) {
                  password=value;
                },
                style: kButtonTextStyle,
                decoration:kTextFieldDecoration.copyWith(hintText: "enter your password",labelText: "Password"),
              ),
              SizedBox(
                height: 24.0,
              ),
              RoundedButton1(onPressed: () async{
                setState(() {
                  showSpinner=true;
                });
                final user=await _auth.signInWithEmailAndPassword(email: email, password: password);
                try{
                if(user!=null)
                  {
                    Navigator.pushNamed(context, ChatScreen.id);
                  }
                setState(() {
                  showSpinner=false;
                });
                }
                catch(e)
                {
                  print("Invalid user");
                }
              },
              title1: "Log in",
              colour:Colors.lightBlueAccent)
            ],
          ),
        ),
      ),
    );
  }
}
