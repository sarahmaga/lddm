import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ViewCalendar extends StatefulWidget {
  const ViewCalendar({Key? key}) : super(key: key);

  @override
  State<ViewCalendar> createState() => _ViewCalendarState();
}

class _ViewCalendarState extends State<ViewCalendar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[400],
        title: const Text('Calendário'),
        elevation: 0,
      ),
      body: Center(
          child: ListTile()
          ),
    );
  }
}
