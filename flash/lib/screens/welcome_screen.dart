import 'package:flash/screens/login_screen.dart';
import 'package:flash/screens/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flash/components/RoundedButton.dart';
class WelcomeScreen extends StatefulWidget {

 static const  String id='welcome_screen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController controller;
 late Animation animation;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller=AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );
    animation=ColorTween(begin:Colors.blueGrey,end:Colors.white).animate(controller);
    controller.forward();

    controller.addListener(() {
      setState(() {
      });
  });}
  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height:60.0,
                  ),
                ),
                AnimatedTextKit(animatedTexts: [
                  TypewriterAnimatedText(
                    'Flash Chat',
                    textStyle: TextStyle(color: Colors.grey[500],
                      fontSize: 45.0,
                      fontWeight: FontWeight.w900,
                    ),
                    speed: const Duration(milliseconds: 150)
                  ),
                ])
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            RoundedButton1(colour:Colors.lightBlueAccent,
             title1:"Log in" ,
            onPressed: (){Navigator.pushNamed(context,LoginScreen.id);}
            ),
            RoundedButton1(colour:Colors.blueAccent,
                title1:"Register" ,
                onPressed: (){Navigator.pushNamed(context,RegistrationScreen.id);}
            ),
          ],
        ),
      ),
    );
  }
}

