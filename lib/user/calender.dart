
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kerp/user/individual.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:collection';
import 'package:http/http.dart' as http;

import '../login.dart';
import '../main.dart';



//List<String> locatevisit=['kannur','kannur'],datevisit=['2023-05-17','2023-05-18'];List<double> latvisit=[],longvisit=[];

class Calender extends StatefulWidget {
  const Calender({required this.pid,required this.locarray,
    required this.datearray,required this.countarray,required this.taskdatearray});
  static final String id="calender";
  final String pid;final List<String> locarray,datearray,taskdatearray;
  final List<int> countarray;

  @override
  State<Calender> createState() => _CalenderState(pid,locarray,datearray,countarray,taskdatearray);
}

class _CalenderState extends State<Calender> {
  String pid;//List<String> datearray,locarray;
  _CalenderState(this.pid,this.locarray,this.datearray,this.countarray,this.taskdatearray);
  List<String> locarray,datearray;
  List<int> countarray;List<String> taskdatearray;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  // RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
  //     .toggledOff; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  // DateTime? _rangeStart;
  // DateTime? _rangeEnd;

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 2), () {setState(() {}); });
    Timer.periodic(Duration(seconds: 10), (timer) =>setState(() {}));
  }


  // @override
  // void dispose() {
  //   //_selectedEvents.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    _selectedDay = _focusedDay;
    ValueNotifier<List<Event>> _selectedEvents;
int i=-1;print(countarray);print(taskdatearray);print(locarray.length);print(datearray);
    final _kEventSource = { for (var item in List.generate(countarray.length, (index) => index))
      DateTime.utc(DateTime.parse(taskdatearray[item]).year,
          DateTime.parse(taskdatearray[item]).month,
          DateTime.parse(taskdatearray[item]).day): List.generate(
          countarray[item], (index)=>
            Event('Location:  ${locarray[i=(i>locarray.length-2)?locarray.length-1:++i]} | ${taskdatearray[item]}')
          )}
      ..addAll({

      });

    final kEvents = LinkedHashMap<DateTime, List<Event>>(
      equals: isSameDay,
      hashCode: getHashCode,
    )
      ..addAll(_kEventSource);
    //
    // List<DateTime> daysInRange(DateTime first, DateTime last) {
    //   final dayCount = last.difference(first).inDays + 1;
    //   return List.generate(
    //     dayCount,
    //         (index) => DateTime.utc(first.year, first.month, first.day + index),
    //   );
    // }

  List<Event> _getEventsForDay(DateTime day) {
    // Implementation example
    return kEvents[day] ?? [];
  }
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));

  // List<Event> _getEventsForRange(DateTime start, DateTime end) {
  //   // Implementation example
  //   print(start.toString()+'  ' +end.toString());
  //   final days = daysInRange(start, end);
  //   return [
  //     for (final d in days) ..._getEventsForDay(d),
  //   ];
  // }


  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        // _rangeStart = null; // Important to clean those
        // _rangeEnd = null;
        // _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });

      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  //
  // void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
  //   setState(() {
  //     _selectedDay = null;
  //     _focusedDay = focusedDay;
  //     _rangeStart = start;
  //     _rangeEnd = end;
  //     _rangeSelectionMode = RangeSelectionMode.toggledOn;
  //   });
  //
  //   // `start` or `end` could be null
  //   if (start != null && end != null) {
  //     _selectedEvents.value = _getEventsForRange(start, end);
  //   } else if (start != null) {
  //     _selectedEvents.value = _getEventsForDay(start);
  //   } else if (end != null) {
  //     _selectedEvents.value = _getEventsForDay(end);
  //   }
  // }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("$pid", style: TextStyle(
          // color: Theme
          //     .of(context)
          //     .secondaryHeaderColor,
          fontSize: 25,
          fontWeight:
          FontWeight.w600,
        ),
        ),
        centerTitle: true,
        leading: BackButton(onPressed: (){
          Navigator.of(context).push(MaterialPageRoute<void>(builder: (context){
            return Scaffold(
              body: Individual(pid: pid),
            );
          })
          );
        },),shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(25),
            bottomLeft: Radius.circular(25)),
      ), toolbarHeight: MediaQuery.of(context).size.height/15,
        actions: [
          PopupMenuButton(
              itemBuilder: (context){
                return [
                  const PopupMenuItem<int>(
                    value: 0,
                    child: Text("My Account"),
                  ),

                  const PopupMenuItem<int>(
                    value: 1,
                    child: Text("calendar"),
                  ),

                  const PopupMenuItem<int>(
                    value: 2,
                    child: Text("Logout"),
                  ),
                ];
              },
              onSelected:(value){
                if(value == 0){
                  print("My account menu is selected.");
                }else if(value == 1){
                  Navigator.of(context).push(MaterialPageRoute<void>(builder: (context){
                    return Scaffold(
                      body: Calendpass(pid: pid,),
                    );
                  })
                  );

                }else if(value == 2){
                  Navigator.of(context).pushNamed(Login.id);
                }
              }
          ),
        ],
      ),
      body: Container(decoration: BoxDecoration(
        color: Colors.cyan[900],
      ),
        child: Column(
          children: [
            TableCalendar<Event>(
              firstDay: kFirstDay,
              lastDay: kLastDay,
              focusedDay: _focusedDay,
              daysOfWeekHeight: 20,
              daysOfWeekStyle: DaysOfWeekStyle(
                weekdayStyle: TextStyle(color: Colors.white54),
                weekendStyle: TextStyle(color: Colors.white30)
              ),
              //weekendDays: [DateTime.sunday],
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              // rangeStartDay: _rangeStart,
              // rangeEndDay: _rangeEnd,
              weekNumbersVisible: true,
              calendarFormat: _calendarFormat,
              // rangeSelectionMode: _rangeSelectionMode,
              eventLoader: _getEventsForDay,
              startingDayOfWeek: StartingDayOfWeek.sunday,
              calendarStyle: const CalendarStyle(
                // Use `CalendarStyle` to customize the UI
                outsideDaysVisible: false,
                weekendTextStyle: TextStyle(color: Colors.white54)
              ),
              onDaySelected: _onDaySelected,
              // onRangeSelected: _onRangeSelected,
              onFormatChanged: (format) {
                if (_calendarFormat != format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                }
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
            ),
            const SizedBox(height: 8.0),
            Expanded(
              child: ValueListenableBuilder<List<Event>>(
                valueListenable: _selectedEvents,
                builder: (context, value, _) {
                  return ListView.builder(
                    itemCount: value.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12.0,
                          vertical: 4.0,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: ListTile(
                          textColor: Colors.black,
                          onTap: () => print('${value[index]}'),
                          title: Text('${value[index]}'),
                        ),
                      );
                    },
                  );
                },
              ),
            ),

          ],
        ),
      ),
    );
  }

  int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }

  final kToday = DateTime.now();
  final kFirstDay = DateTime.utc(2023,01,01);
  final kLastDay = DateTime.utc(2050,12,31);
}

class Event {
  final String title;

  const Event(this.title);

  @override
  String toString() => title;
}
