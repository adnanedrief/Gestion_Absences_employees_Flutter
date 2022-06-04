import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() => runApp(MyApp8());

class MyApp8 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Mes_conges(),
    );
  }
}

class Mes_conges extends StatefulWidget {
  @override
  _Mes_congesState createState() => _Mes_congesState();
}

class _Mes_congesState extends State<Mes_conges> {
  DateTime currentDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: DateTime(2015),
        lastDate: DateTime(2050));
    if (pickedDate != null && pickedDate != currentDate)
      setState(() {
        currentDate = pickedDate;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text("La date choisi de votre congée est :",
                style: TextStyle(fontSize: 30)),
            Text(" "),
            Text(" "),
            Text(" "),
            Text(DateFormat('dd / MM / yyyy').format(currentDate).toString(),
                style: TextStyle(fontSize: 25)),
            Text(" "),
            Text(" "),
            RaisedButton(
              color: Color.fromARGB(255, 215, 67, 67),
              onPressed: () => _selectDate(context),
              child: Text('Sélectionner la  date',
                  style: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255), fontSize: 25)),
            ),
          ],
        ),
      ),
    );
  }
}
