import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:Gestion_Absences_employees/Supervisor/addemployee.dart';
import 'package:Gestion_Absences_employees/Supervisor/info.dart';
import 'package:Gestion_Absences_employees/Supervisor/profile.dart';
import 'package:Gestion_Absences_employees/Supervisor/listofemployee.dart';
import 'package:Gestion_Absences_employees/WelcomeScr.dart';
import '../main.dart';

class Dashboard extends StatelessWidget {
  Widget build(BuildContext context) {
    Future<void> _logout() async {
      await FirebaseAuth.instance.signOut();
      if (FirebaseAuth.instance.currentUser == null) {
        Navigator.pop(context);
        FirebaseAuth.instance.currentUser;
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MyApp()));
      } else {
        AlertDialog(
          title: Text("Déconnectez-vous à nouveau"),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Tableau de bord"),
      ),
      body: Center(
          child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.all(20.0),
                  child: new MaterialButton(
                    elevation: 10,
                    height: 100.0,
                    minWidth: 150.0,
                    color: Theme.of(context).primaryColor,
                    textColor: Colors.white,
                    child: new Text("Profile"),
                    onPressed: () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Profile()),
                      )
                    },
                    splashColor: Colors.redAccent,
                  )),
              Padding(
                  padding: EdgeInsets.all(20.0),
                  child: new MaterialButton(
                    elevation: 10,
                    height: 100.0,
                    minWidth: 150.0,
                    color: Theme.of(context).primaryColor,
                    textColor: Colors.white,
                    child: new Text("Présence"),
                    onPressed: () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Attendance()),
                      )
                    },
                    splashColor: Colors.redAccent,
                  )),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.all(20.0),
                  child: new MaterialButton(
                    elevation: 10,
                    height: 100.0,
                    minWidth: 150.0,
                    color: Theme.of(context).primaryColor,
                    textColor: Colors.white,
                    child: new Text("Se déconnecter"),
                    onPressed: () => {
                      ////////////////////////////////////////////
                      Navigator.pop(context),
                      _logout(),
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => HomePage()),
                      // )
                    },
                    splashColor: Colors.redAccent,
                  )),
              Padding(
                  padding: EdgeInsets.all(20.0),
                  child: new MaterialButton(
                    elevation: 10,
                    height: 100.0,
                    minWidth: 150.0,
                    color: Theme.of(context).primaryColor,
                    textColor: Colors.white,
                    child: new Text("À propos de"),
                    onPressed: () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => About()),
                      )
                    },
                    splashColor: Color.fromARGB(255, 215, 67, 67),
                  )),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.all(20.0),
                  child: new MaterialButton(
                    elevation: 10,
                    height: 100.0,
                    minWidth: 150.0,
                    color: Theme.of(context).primaryColor,
                    textColor: Colors.white,
                    child: new Text("Ajouter un employé"),
                    onPressed: () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AddEmployee()),
                      )
                    },
                    splashColor: Colors.redAccent,
                  )),
            ],
          )
        ],
      )),
    );
  }
}
