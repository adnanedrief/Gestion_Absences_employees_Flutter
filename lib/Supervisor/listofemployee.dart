import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:Gestion_Absences_employees/Employee/profilepage.dart';
import 'package:Gestion_Absences_employees/Supervisor/getEmployeeData.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Employee/attendance.dart';
import '../FirestoreOperstions.dart';
import 'excel_operation.dart';
import 'login.dart';
// package:spring1_uSupervisor/login.dart
import 'package:Gestion_Absences_employees/Supervisor/login.dart';

class Attendance extends StatefulWidget {
  @override
  State<Attendance> createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  bool _canSee = true;

  late TextEditingController controller;
  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future getDialog(BuildContext context) {
    TextEditingController mycontroller = TextEditingController();
    // var cansee = Icon(Icons.remove_red_eye);
    // bool _canSee = false;
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Tapez votre mot de passe"),
            content: TextField(
              controller: mycontroller,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Mot de passe",
              ),
            ),
            actions: [
              TextButton(
                child: Text("Soumettre"),
                onPressed: () {
                  Navigator.of(context).pop(mycontroller.text.toString());
                },
              )
            ],
          );
        });
  }

  checkpassword(real, enterd) {
    if (real != enterd) {
      return false;
    } else {
      return true;
    }
  }

  goToDetailPage(DocumentSnapshot data) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DetailPage(selectedUser: data)));
  }

  void showError(String errormessage) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('ERROR'),
            content: Text(errormessage),
            actions: <Widget>[
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'))
            ],
          );
        });
  }

  String uid = FirebaseAuth.instance.currentUser!.uid;

  String collection = "Employee";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Liste des employ??s"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("Employee").snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            final list = snapshot.data!.docs;
            return ListView.builder(
              itemCount: snapshot.data!.size,
              itemBuilder: (context, i) {
                return Slidable(
                  key: const ValueKey(0),
                  startActionPane:
                      ActionPane(motion: StretchMotion(), children: [
                    SlidableAction(
                      onPressed: (context) {
                        openWhatsapp(list[i].data()["phone"]);
                      },
                      backgroundColor: Color.fromARGB(255, 215, 67, 67),
                      foregroundColor: Colors.white,
                      icon: FontAwesomeIcons.whatsapp,
                      label: "WhatsApp",
                    ),
                    SlidableAction(
                      onPressed: (context) {
                        callMe(list[i].data()["phone"]);
                      },
                      backgroundColor: Color.fromARGB(255, 215, 67, 67),
                      foregroundColor: Colors.white,
                      icon: FontAwesomeIcons.phoneAlt,
                      label: "Phone",
                    )
                  ]),
                  endActionPane: ActionPane(motion: StretchMotion(), children: [
                    SlidableAction(
                      onPressed: (context) {
                        var snap = FirebaseFirestore.instance
                            .collection("Supervisor")
                            .doc(FirebaseAuth.instance.currentUser.uid);

                        var snap2 = FirebaseFirestore.instance
                            .collection("Employee")
                            .doc(list[i].data()["uid"]);
                        var snap3 = FirebaseFirestore.instance
                            .collection("Employee")
                            .doc(list[i].get("uid"))
                            .collection("History");

                        getDialog(context).then((password) {
                          snap.get().then((value) {
                            var tempass = value.data()["tempass"];

                            if (tempass == null) {
                              showError("Vous n'??tes pas autoris?? ?? supprimer");
                            } else {
                              bool flag = checkpassword(
                                  tempass.toString(), password.toString());

                              if (flag) {
                                try {
                                  snap2.delete();
                                  snap3.doc().delete();
                                  // setState(() {
                                  //   Scaffold.of(context).showSnackBar(SnackBar(
                                  //       content: Text(
                                  //           "User Deleted Successfully")));
                                  // });
                                } catch (e) {}
                              } else {
                                showError("L'op??ration a ??chou??");
                              }
                            }
                          });
                        });

                        setState(() {
                          collection = "Employee";
                        });
                      },
                      backgroundColor: Color(0xFFFE4A49),
                      foregroundColor: Colors.white,
                      icon: FontAwesomeIcons.trash,
                      label: 'Delete',
                    )
                  ]),
                  child: Card(
                    elevation: 8,
                    child: ListTile(
                      title: Text(
                        list[i]["Fullname"].toString().toUpperCase(),
                        style: TextStyle(fontSize: 20),
                      ),
                      subtitle: Text(list[i]["phone"]),
                      trailing: getTrailing(list[i]["check in"].toString()),
                      leading: SizedBox(
                        height: 110.0,
                        width: 110.0, // fixed width and height
                        child: checkprofile(list[i]["profile pic"]),
                      ),
                      onTap: () => goToDetailPage(list[i]),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

class DetailPage extends StatefulWidget {
  final DocumentSnapshot selectedUser;
  DetailPage({required this.selectedUser});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  DateTime moonlanding = DateTime.parse("1969-07-20");
  late DateTime checkin =
      DateTime.parse(checkDate(widget.selectedUser.data()["check in"]));
  late DateTime checkout =
      DateTime.parse(checkDate(widget.selectedUser.data()["check out"]));
  late num Total = 0;
  int cinCount = 1;
  int coutCount = 1;

  String checkDate(String time) {
    if (time == "today") {
      return DateTime.now().toString();
    } else {
      return time;
    }
  }

  DateTime _getChckin() {
    DateTime currentCheckIN = new DateTime.now();
    print(currentCheckIN);
    return currentCheckIN;
  }

  DateTime _getCheckout() {
    DateTime currentCheckout = new DateTime.now();
    print(currentCheckout);
    return currentCheckout;
  }

  _differenceInHours(DateTime cin, DateTime cout) {
    Duration difference = checkout.difference(checkin);

    print(difference.inHours);

    if (!difference.isNegative) {
      var diff = difference.inMinutes
          .toString(); // for now set as seconds(demo purpose)
      print(diff);
      var hours = double.parse(diff);
      Total = hours * 50;
      var Ftotal = Total.toStringAsFixed(2);
      var toDouble = double.parse(Ftotal);
      print(Total);
      print(Ftotal);
      return toDouble;
    }
  }

  @override
  Widget build(BuildContext context) {
    void showError(String errormessage) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('ERROR'),
              content: Text(errormessage),
              actions: <Widget>[
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'))
              ],
            );
          });
    }

    String uid = widget.selectedUser.data()["uid"];

    checkinButton() {
      try {
        if (cinCount > 0) {
          checkin = _getChckin();
          updateCheckin(checkin, uid);
          cinCount--;
        } else {
          throw Exception("Impossible de s'enregistrer plus d'une fois??!");
        }
      } catch (e) {
        showError(e.toString());
      }
    }

    checkoutButton() {
      try {
        if ((checkin.difference(DateTime.now()).inSeconds) <= 0) {
          if (coutCount > 0) {
            checkout = _getCheckout();
            updateCheckout(checkout, uid);
            var money = _differenceInHours(checkin, checkout);
            updateEmployeeAmount(money, uid);
            setAttendeceHistory(checkout, checkin, money, uid);
            coutCount--;
          } else {
            throw Exception("Impossible de payer plus d'une fois??!");
          }
        } else {
          throw Exception("Veuillez d'abord vous enregistrer??!");
        }
      } catch (e) {
        showError(e.toString());
      }
    }

    return Scaffold(
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        activeBackgroundColor: Color.fromARGB(255, 215, 67, 67),
        backgroundColor: Color.fromARGB(255, 215, 67, 67),
        children: [
          SpeedDialChild(
            child: Icon(FontAwesomeIcons.fileExcel),
            backgroundColor: Color.fromARGB(255, 215, 67, 67),
            elevation: 20,
            label: "Excel Sheet",
            labelStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            labelBackgroundColor: Colors.yellowAccent,
            onTap: () => getExcel(
                widget.selectedUser.get("Fullname"),
                widget.selectedUser.get("address"),
                widget.selectedUser.get("phone"),
                uid,
                widget.selectedUser.get("Total Amount").toString()),
          ),
          SpeedDialChild(
              child: Icon(FontAwesomeIcons.phoneAlt),
              backgroundColor: Color.fromARGB(255, 215, 67, 67),
              elevation: 20,
              label:
                  "Appel ${widget.selectedUser.get("Fullname").toString().toUpperCase()}",
              labelStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              labelBackgroundColor: Colors.yellowAccent,
              onTap: () => callMe(widget.selectedUser.get("phone"))),
          SpeedDialChild(
            child: Icon(FontAwesomeIcons.whatsapp),
            backgroundColor: Color.fromARGB(255, 215, 67, 67),
            elevation: 20,
            label:
                "WhatsApp ${widget.selectedUser.get("Fullname").toString().toUpperCase()}",
            labelStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            labelBackgroundColor: Colors.yellowAccent,
            onTap: () => openWhatsapp(widget.selectedUser.get("phone")),
          ),
        ],
      ),
      appBar: AppBar(
        title: Text(
            "Infos sur ${widget.selectedUser.data()["Fullname"].toString().toUpperCase()}"),
      ),
      body: Container(
        child: Center(
          //--------------------------> //////
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("Employee")
                .where("uid", isEqualTo: uid)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              return Container(
                child: Container(
                  child: Column(
                    children:
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                      return Container(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(
                                height: 50,
                              ),

                              Text(
                                "Nom et pr??nom : ${document.data()["Fullname"].toString().toUpperCase()}",
                                style: TextStyle(fontSize: 20),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Derni??re Entr??e : ",
                                      style: TextStyle(fontSize: 20)),
                                  formaDtate2(
                                      document.data()["check in"].toString()),
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Derni??re Sortie :",
                                      style: TextStyle(fontSize: 20)),
                                  formaDtate2(
                                      document.data()["check out"].toString()),
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                  "Montant total : ${document.data()["Total Amount"]} DH",
                                  style: TextStyle(fontSize: 20)),
                              SizedBox(
                                height: 40,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 30,
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                padding: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            width: 2,
                                            color: Color.fromARGB(
                                                255, 47, 170, 16)))),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      "Date(yy-mm-dd)",
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    Text(
                                      "Entrer",
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    Text(
                                      "Sortie",
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    Text(
                                      "Montant",
                                      style: TextStyle(fontSize: 15),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              // getDataTable(uid),
                              GetEmployeeData(uid),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

Widget formaDtate2(String time) {
  String hours;
  if (time != "today") {
    var date = time.substring(0, 10);
    hours = time.substring(11, 16);
    var today = DateTime.now().toString();
    if (date == today.substring(0, 10)) {
      return Text(
        date + " ?? " + hours,
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
        date + " ?? " + hours,
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

Widget getTrailing(String checkin) {
  var today = DateTime.now().toString();
  if (checkin == "today") {
    return Icon(
      Icons.cancel_rounded,
      color: Color.fromARGB(255, 215, 67, 67),
      size: 30,
    );
  } else if (checkin.substring(0, 10) == today.substring(0, 10)) {
    return Icon(
      Icons.check_circle,
      color: Color.fromARGB(255, 215, 67, 67),
      size: 30,
    );
  }
  return Icon(
    Icons.cancel_rounded,
    color: Color.fromARGB(255, 215, 67, 67),
    size: 30,
  );
}

void openWhatsapp(String phone) async {
  String phoneNum = "01110948155";
  phoneNum = phone;
  var url = "https://wa.me/$phoneNum?text=Hello";
  await launch(url);
}

void callMe(String phone) async {
  String phoneNum = "01110948155";
  phoneNum = phone;
  // await FlutterPhoneDirectCaller.callNumber(phoneNum);
  await launch("tel:/$phoneNum");
}
