import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:Gestion_Absences_employees/Employee/attendance.dart';
import 'package:Gestion_Absences_employees/Employee/finance.dart';
import 'package:Gestion_Absences_employees/Employee/home_screen.dart';
import 'package:Gestion_Absences_employees/main.dart';
import 'Marquer_presence.dart';
import 'package:Gestion_Absences_employees/Employee/profilepage.dart';
import 'package:Gestion_Absences_employees/Employee/justification.dart';
import 'package:Gestion_Absences_employees/Employee/chatbot.dart';

import 'headerDrawer.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var currentPage = DrawerSections.home;

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    if (FirebaseAuth.instance.currentUser == null) {
      Navigator.pop(context);
      FirebaseAuth.instance.currentUser;
      Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp()));
    } else {
      AlertDialog(
        title: Text("Déconnectez-vous"),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var container;
    if (currentPage == DrawerSections.home) {
      container = HomeScreen();
    } else if (currentPage == DrawerSections.profile) {
      container = ProfilePage();
    } else if (currentPage == DrawerSections.income) {
      container = IncomePage();
    } else if (currentPage == DrawerSections.attendance) {
      container = AttendanceHistory();
    } else if (currentPage == DrawerSections.marquer_presence) {
      container = Marquer_presence();
    } else if (currentPage == DrawerSections.justification) {
      container = Justification(); //

    } else if (currentPage == DrawerSections.chatbot) {
      container = Chatbot(); //
    } else if (currentPage == DrawerSections.logout) {
      // Navigator.pop(context);
      _logout();

      // WidgetsBinding.instance!.addPostFrameCallback((_) {
      //   Navigator.pushReplacement(
      //       context, MaterialPageRoute(builder: (_) => MyApp()));
      // });

    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 215, 67, 67),
      ),
      body: container,
      drawer: Drawer(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                MyHeaderDrawer(),
                MyDrawerList(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget MyDrawerList() {
    return Container(
      padding: EdgeInsets.only(
        top: 15,
      ),
      child: Column(
        // shows the list of menu drawer
        children: [
          menuItem(1, "Accueil", Icons.home,
              currentPage == DrawerSections.home ? true : false),
          menuItem(2, "Profil", Icons.person,
              currentPage == DrawerSections.profile ? true : false),
          menuItem(3, "Finance", Icons.monetization_on,
              currentPage == DrawerSections.income ? true : false),
          menuItem(4, "Présence", Icons.timer,
              currentPage == DrawerSections.attendance ? true : false),
          Divider(),
          menuItem(5, "Marquer ma présence", Icons.check,
              currentPage == DrawerSections.marquer_presence ? true : false),
          Divider(),
          menuItem(6, "Justif d'absence", Icons.file_upload,
              currentPage == DrawerSections.justification ? true : false),
          Divider(),
          menuItem(7, "ChatBot", Icons.chat,
              currentPage == DrawerSections.chatbot ? true : false),
          Divider(),
          menuItem(8, "Se déconnecter", Icons.lock_open_rounded,
              currentPage == DrawerSections.logout ? true : false),
        ],
      ),
    );
  }

  Widget menuItem(int id, String title, IconData icon, bool selected) {
    return Material(
      color: selected ? Colors.grey[300] : Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
          setState(() {
            if (id == 1) {
              currentPage = DrawerSections.home;
            } else if (id == 2) {
              currentPage = DrawerSections.profile;
            } else if (id == 3) {
              currentPage = DrawerSections.income;
            } else if (id == 4) {
              currentPage = DrawerSections.attendance;
            } else if (id == 5) {
              currentPage = DrawerSections.marquer_presence;
            } else if (id == 6) {
              currentPage = DrawerSections.justification;
            } else if (id == 7) {
              currentPage = DrawerSections.chatbot;
            } else if (id == 8) {
              currentPage = DrawerSections.logout;
            }
          });
        },
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Row(
            children: [
              Expanded(
                child: Icon(
                  icon,
                  size: 20,
                  color: Colors.black,
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum DrawerSections {
  home,
  profile,
  income,
  attendance,
  logout,
  justification,
  chatbot,
  marquer_presence,
}
