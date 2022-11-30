import 'package:flutter/material.dart';
import 'package:flash/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
final _firestore=FirebaseFirestore.instance;
 late User loggedInUser;
class ChatScreen extends StatefulWidget {
  static const String id='chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final msgTextController=TextEditingController();
  final _auth=FirebaseAuth.instance;
  String msgText='';
  @override
  void initState() {
    // TODO: implement initState

    getCurrentUser();
    super.initState();
  }
  void getCurrentUser() async{
    final user= await _auth.currentUser;
    try{
    if(user!=null)
    {
      loggedInUser=user;
      print(loggedInUser.email);
    }
    }
    catch(e){
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessagesStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: msgTextController,
                      onChanged: (value) {
                        msgText=value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      msgTextController.clear();
                      _firestore.collection('messages').add({
                        'msg':msgText,
                        'sender':loggedInUser.email,
                        'time':FieldValue.serverTimestamp()
                      });
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessagesStream extends StatelessWidget {
  const MessagesStream({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('messages').orderBy('time').snapshots(),
      builder: (context,snapshot){
        if(snapshot.hasData)
        {
          final messages=snapshot.data!.docs.reversed;
          List<MessageBubble> msgWidgets=[];
          for(var message in messages)
          {
            final timestamp=message.get('time');
            final msgText=message.get('msg');
            final msgSender=message.get('sender');
            final currentUser=loggedInUser.email;

            final messageBubbles=MessageBubble(sender: msgSender,text: msgText,isMe:currentUser==msgSender);
            msgWidgets.add(messageBubbles);
          }
          return Expanded(
            child: ListView(
              reverse: true,
              padding: EdgeInsets.symmetric(horizontal: 10,vertical: 20),
              children: msgWidgets,
            ),
          );
        }
        return Center(
          child: CircularProgressIndicator(
            backgroundColor: Colors.lightBlueAccent,
          ),
        );
      },
    );
  }
}


class MessageBubble extends StatelessWidget {
  MessageBubble({this.sender,this.text, this.isMe:false});
  final sender,text;
 final bool isMe;
// final time;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: isMe?CrossAxisAlignment.end :CrossAxisAlignment.start,
        children: [
          Text(sender,style: TextStyle(color: Colors.grey,fontSize: 8),),
          Material(
            elevation: 5.0,
              borderRadius: isMe? BorderRadius.only(topLeft: Radius.circular(30),bottomLeft: Radius.circular(30),bottomRight: Radius.circular(30)):
              BorderRadius.only(topRight: Radius.circular(30),bottomLeft: Radius.circular(30),bottomRight: Radius.circular(30)),
              color: isMe? Colors.lightBlueAccent: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text("$text",style: TextStyle(color: isMe?Colors.white:Colors.black,fontSize: 15),),
              )),
        ],
      ),
    );
  }
}

