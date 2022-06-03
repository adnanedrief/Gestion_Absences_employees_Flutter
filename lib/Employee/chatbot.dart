import 'package:flutter/material.dart';
import 'package:kommunicate_flutter/kommunicate_flutter.dart';

class Chatbot extends StatefulWidget {
  const Chatbot({Key? key}) : super(key: key);

  @override
  State<Chatbot> createState() => _ChatbotState();
}

class _ChatbotState extends State<Chatbot> {
  void _setateless() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          Center(child: Image.asset("images/ensias.png")),
          Center(child: Image.asset("images/chatbot.png")),
        ],
      )),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.start),
        label: Text('Lancer le chatBot'),
        onPressed: () async {
          dynamic conversationObject = {
            'appId':
                '37a4d401535da9a476038a57228db92b1', // The APP_ID obtained from kommunicate dashboard.
          };
          KommunicateFlutterPlugin.buildConversation(conversationObject)
              .then((clientConversationId) {
            print("Conversation builder success : " +
                clientConversationId.toString());
          }).catchError((error) {
            print("Conversation builder error : " + error.toString());
          });
        },
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
