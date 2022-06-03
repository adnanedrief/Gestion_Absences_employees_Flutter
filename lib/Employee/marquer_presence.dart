import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
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

Future AlertEntree(BuildContext context) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Marquage'),
        content: const Text('Votre Entrée est bien Entregistrée'),
        actions: [
          FlatButton(
            child: Text('Ok'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

Future AlertSortie(BuildContext context) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Marquage'),
        content: const Text('Votre Sortie est bien Entregistrée'),
        actions: [
          FlatButton(
            child: Text('Ok'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

class _Marquer_presenceState extends State<Marquer_presence> {
  int countSortie = 1;
  int countEntrer = 1;

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
                onClicked: () async {
                  if (countEntrer == 1) {
                    await Marquer_Entrer();
                    countEntrer--;
                    AlertEntree(context);
                  }
                },
              ),
              SizedBox(height: 8),
              SizedBox(height: 48),
              ButtonWidget(
                text: 'Marquer la sortie',
                icon: Icons.add_to_home_screen,
                onClicked: () async {
                  if (countSortie == 1) {
                    await Marquer_Sortie();
                    countSortie--;
                    AlertSortie(context);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget formaDtate2(String time) {
    String hours;
    if (time != "today") {
      var date = time.substring(0, 10);
      hours = time.substring(11, 16);
      var today = DateTime.now().toString();
      if (date == today.substring(0, 10)) {
        return Text(
          date + " à " + hours,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20,
              color: Color.fromARGB(255, 32, 224, 38),
              fontWeight: FontWeight.bold),
        );
      } else if (date != today.substring(0, 10)) {
        return Text(
          "No record",
          textAlign: TextAlign.center,
        );
      } else {
        return Text(
          date + " à " + hours,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20),
        );
      }
    } else {
      return Text(
        "No record",
        textAlign: TextAlign.center,
      );
    }
  }

  Future Marquer_Entrer() async {
    DateTime checkin = new DateTime.now();
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser;
    final uid = user.uid; // current user uploader ID
    try {
      DocumentReference documentReference1 =
          FirebaseFirestore.instance.collection("Employee").doc(uid);

      FirebaseFirestore.instance.runTransaction((transaction) async {
        transaction.update(documentReference1, {
          "check in": checkin.toString(),
        });
      });
      // FirebaseFirestore.instance
      //     .collection("Employee")
      //     .doc(uid)
      //     .collection("History")
      //     .add({
      //   'check in': checkin.toString(),
      //   "check out": checkin.toString(),
      //   "current amount": 0,
      // });
      return true;
    } catch (e) {
      return false;
    }
  }

  Future Marquer_Sortie() async {
    DateTime checkout = new DateTime.now();
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser;
    final uid = user.uid; // current user uploader ID
    try {
      DocumentReference documentReference1 =
          FirebaseFirestore.instance.collection("Employee").doc(uid);

      FirebaseFirestore.instance.runTransaction((transaction) async {
        transaction.update(documentReference1, {
          "check out": checkout.toString(),
        });
      });

      setAttendeceHistory(checkout, uid);

      return true;
    } catch (e) {
      return false;
    }
  }
}

Future<void> setAttendeceHistory(DateTime checkout, String uid) async {
  FirebaseFirestore.instance
      .collection('Employee')
      .where("uid", isEqualTo: uid)
      .get()
      .then((QuerySnapshot querySnapshot) {
    querySnapshot.docs.forEach((doc) {
      String checkin = doc["check in"];
      print("Check in : " + doc["check in"]);

      FirebaseFirestore.instance
          .collection("Employee")
          .doc(uid)
          .collection("History")
          .add({
        "check in": checkin.toString(),
        "check out": checkout.toString(),
        "current amount": 0,
      });
    });
  });
}
