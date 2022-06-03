import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

List events = [];

class AttendanceHistory extends StatefulWidget {
  const AttendanceHistory({Key? key}) : super(key: key);

  @override
  State<AttendanceHistory> createState() => _AttendanceHistoryState();
}

class _AttendanceHistoryState extends State<AttendanceHistory> {
  late Map<DateTime, List<dynamic>> _groupedEvents = Map();

  var _calendarController;
  late List<dynamic> _selectedEvents = [];

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
    _groupedEvents = {};
    _selectedEvents = [];
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  _getStringDate(String date, String checkout) {
    String cinTime = date.substring(10, 16);
    String coutTime = checkout.substring(10, 16);
    if (date != null) {
      print(date);
      DateTime toDate = DateTime.parse(date);
      print(toDate);

      _groupedEvents[toDate] = events.toList();
      _groupedEvents[toDate]!.add("Entrer à" + cinTime);
      _groupedEvents[toDate]!.add("Sortie à" + coutTime);

      // _groupedEvents[DateTime.parse(date)]!.add("Attended");
    }
  }

  bool sort = true;
  String Sort = "Ascending";
  // late IconData icon = Icon(Icons.arrow_circle_up) as IconData;
  Widget icon = Icon(Icons.arrow_circle_up);

  @override
  Widget build(BuildContext context) {
    String date = "today", checkin = "today", checkout = "today";
    initializeDateFormatting('fr_FR', null);

    return Scaffold(
        body: ListView(children: [
      Column(
        children: [
          SizedBox(
            height: 30,
          ),
          Text(
            "Mes présence",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 50,
          ),
          Container(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                width: 2,
                                color: Color.fromARGB(255, 47, 170, 16)))),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("Employee")
                      .doc(FirebaseAuth.instance.currentUser.uid)
                      .collection("History")
                      .orderBy("check out", descending: sort)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: Colors.yellow[900],
                        ),
                      );
                    } else if (snapshot.hasData) {
                      return Column(
                        children: [
                          Container(
                            child: Column(
                              children: snapshot.data!.docs
                                  .map((DocumentSnapshot document) {
                                checkin = document.data()["check in"];
                                checkout = document.data()["check out"];
                                _getStringDate(checkin, checkout);
                                return Container(
                                  child: Column(
                                    children: [],
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                          Card(
                            child: TableCalendar(
                             
                              locale: "fr_FR",
                              calendarStyle: CalendarStyle(
                                  markersColor:
                                      Color.fromARGB(255, 215, 67, 67),
                                  markersMaxAmount: 1,
                                  cellMargin: EdgeInsets.all(8),
                                  todayColor: Color.fromARGB(255, 215, 67, 67),
                                  weekendStyle: TextStyle(
                                      color: Color.fromARGB(255, 215, 67, 67),
                                      fontWeight: FontWeight.bold),
                                  selectedColor:
                                      Color.fromARGB(255, 215, 67, 67),
                                  selectedStyle: TextStyle(
                                      color: Color.fromARGB(255, 215, 67, 67),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                  eventDayStyle: TextStyle(
                                      decorationColor:
                                          Color.fromARGB(255, 215, 67, 67),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17)),
                              events: _groupedEvents,
                              calendarController: _calendarController,
                              onDaySelected: (day, events, holidays) {
                                setState(() {
                                  _selectedEvents = events;
                                });
                              },
                              headerStyle: HeaderStyle(
                                  decoration:
                                      const BoxDecoration(color: Colors.black),
                                  headerMargin:
                                      const EdgeInsets.only(bottom: 10),
                                  titleTextStyle:
                                      const TextStyle(color: Colors.yellow),
                                  formatButtonDecoration: BoxDecoration(
                                    border: Border.all(color: Colors.yellow),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  formatButtonTextStyle:
                                      const TextStyle(color: Colors.yellow),
                                  leftChevronIcon: Icon(
                                    Icons.chevron_left_rounded,
                                    color: Colors.yellow[600],
                                  ),
                                  rightChevronIcon: Icon(
                                    Icons.chevron_right_rounded,
                                    color: Colors.yellow[600],
                                  )),
                            ),
                          ),
                          ..._selectedEvents.map((event) => Container(
                              decoration: BoxDecoration(
                                border: Border.all(width: 2),
                                color: Color.fromARGB(255, 215, 67, 67),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 4.0),
                              child: ListTile(
                                leading: Icon(
                                  FontAwesomeIcons.solidClock,
                                  color: Colors.black,
                                ),
                                title: Text(
                                  event,
                                  style: TextStyle(fontSize: 20),
                                ),
                              ))),
                          Container(
                              decoration: BoxDecoration(
                                border: Border.all(width: 2),
                                color: Color.fromARGB(255, 215, 67, 67),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 4.0),
                              child: ListTile(
                                  leading: Icon(
                                    FontAwesomeIcons.calendarAlt,
                                    color: Colors.black,
                                  ),
                                  title: Text(
                                    "Nombre total de jours assistés: ${_groupedEvents.length} Journées",
                                    style: TextStyle(fontSize: 20),
                                  )))
                        ],
                      );
                    }

                    return Text("No data");
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    ]));
  }
}

Widget formaDtate(String time) {
  String hours;
  if (time != "today") {
    hours = time.substring(11, 16);
    return Text(
      "   " + hours,
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 19),
    );
  } else {
    return Text(
      "No record",
      textAlign: TextAlign.center,
    );
  }
}

Widget formatDate(String time) {
  // String today = DateTime.now().toString();
  String day;
  if (time != "today") {
    day = time.substring(0, 10);
    return Text(
      day,
      style: TextStyle(fontSize: 19),
    );
  } else {
    return Text(
      "No Data",
      style: TextStyle(fontSize: 19),
    );
  }
}
