import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'firebase_api.dart';
import 'button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await Firebase.initializeApp();
  runApp(Marquer_presence());
}

class Marquer_presence extends StatefulWidget {
  @override
  _Marquer_presenceState createState() => _Marquer_presenceState();
}

class _Marquer_presenceState extends State<Marquer_presence> {
 
  @override
  Widget build(BuildContext context) {
   

    return Scaffold(
      appBar: AppBar(
        title: Text("Marquer l'entré et la sortie"),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromARGB(255, 215, 67, 67),
      ),
      body: Container(
        padding: EdgeInsets.all(32),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ButtonWidget(
                text: 'Marquer l\'entrée',
                icon: Icons.add_to_home_screen_rounded,
                onClicked: Marquer_Entrer,
              ),
              SizedBox(height: 8),
             
              SizedBox(height: 48),
              ButtonWidget(
                text: 'Marquer la sortie',
                icon: Icons.add_to_home_screen,
                onClicked: () async {
                  await Marquer_Sortie();
                },
              ),
              
            ],
          ),
        ),
      ),
    );
  }

  Future Marquer_Entrer() async {
    
  }

  Future Marquer_Sortie() async {
    
  }

  
}
