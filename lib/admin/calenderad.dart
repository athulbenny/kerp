

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import 'ostrmap.dart';

class Calenderad extends StatefulWidget {
  const Calenderad({required this.pid,required this.isChanged,required this.tid});
  static final String id="calender";
  final String pid;final int isChanged,tid;

  @override
  State<Calenderad> createState() => _CalenderadState(pid,isChanged,tid);
}

class _CalenderadState extends State<Calenderad> {
  String pid;int isChanged,tid;
  _CalenderadState(this.pid,this.isChanged,this.tid);
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(25),
            bottomLeft: Radius.circular(25)),
      ), toolbarHeight: MediaQuery.of(context).size.height/15,title: Text('Choose Date'),
      centerTitle: true,backgroundColor: Colors.green,),
      body: TableCalendar(
        firstDay: DateTime.utc(2023,01,01),
        lastDay: DateTime.utc(2050,12,31),
        focusedDay: _focusedDay,
        calendarFormat: _calendarFormat,
        weekNumbersVisible: true,
        rowHeight: 100,
        daysOfWeekHeight: 25,
        pageJumpingEnabled: true,
        selectedDayPredicate: (day) {
          return isSameDay(_selectedDay, day);
        },
        onDaySelected: (selectedDay, focusedDay) {
          if (!isSameDay(_selectedDay, selectedDay)) {
            // Call `setState()` when updating the selected day
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
              Navigator.of(context).push(MaterialPageRoute<void>(builder: (context){
                return Scaffold(
                    body: Ostrmap(pid: pid,Tdate: _focusedDay.toString(),isChanged:isChanged,tid:tid)
                );
              }));
            });
          }
        },
        onFormatChanged: (format) {
          if (_calendarFormat != format) {
            // Call `setState()` when updating calendar format
            setState(() {
              _calendarFormat = format;
            });
          }
        },
        onPageChanged: (focusedDay) {
          // No need to call `setState()` here
          _focusedDay = focusedDay;
        },
      ),
    );
    //);
  }
}
