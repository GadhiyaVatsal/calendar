import 'package:calendar/ui/add_events.dart';
import 'package:calendar/ui/event_view.dart';
import 'package:calendar/utils/helper_widgets.dart';
import 'package:firebase_helpers/firebase_helpers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../model/event.dart';

class Calendar extends StatefulWidget {
  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  CalendarController _calendarController;
  Map<DateTime, List<dynamic>> _events;
  List<dynamic> _selectedEvents;
  DatabaseService<EventModel> eventDBS = DatabaseService<EventModel>("events",
      fromDS: (id, data) => EventModel.fromDS(id, data),
      toMap: (event) => event.toMap());
  DateTime _date;

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
    _events = {};
    _selectedEvents = [];
    _date = DateTime.now();
  }

  /* Widget _createTitleBarWidget() {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(40),
        ),
        color: Color.fromRGBO(62, 213, 187, 100),
        boxShadow: [
          BoxShadow(
            blurRadius: 10.0,
            color: Colors.blueGrey,
            offset: Offset(0.0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(top: 35.0, left: 30.0),
        child: Text(
          'Calendar',
          style: TextStyle(
            color: Colors.white,
            fontSize: 30.0,
            decoration: TextDecoration.none,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }*/

  _createCalendarView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TableCalendar(
          events: _events,
          onDayLongPressed: (day, events, holidays) => {
            //print("Day : ${events.map((e) => Text(e.title))}"),
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EventView(
                  eventDBS: eventDBS,
                  events: _events,
                  selectedEvents: _selectedEvents,
                  day: day,
                ),
              ),
            ),
          },
          initialCalendarFormat: CalendarFormat.month,
          calendarController: _calendarController,
          calendarStyle: CalendarStyle(
            todayColor: Colors.orange,
            selectedColor: Colors.cyan,
            todayStyle: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 18.0,
              color: Colors.white,
            ),
          ),
          builders: CalendarBuilders(
            selectedDayBuilder: (context, date, events) => Container(
              margin: const EdgeInsets.all(4.0),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(10.0)),
              child: Text(
                date.day.toString(),
                style: TextStyle(color: Colors.white),
              ),
            ),
            todayDayBuilder: (context, date, events) => Container(
              margin: const EdgeInsets.all(4.0),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(10.0)),
              child: Text(
                date.day.toString(),
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          headerStyle: HeaderStyle(
            centerHeaderTitle: true,
            formatButtonVisible: false,
          ),
          onDaySelected: (date, events, _) {
            setState(() {
              _selectedEvents = events;
              _date = date;
            });
          },
          startingDayOfWeek: StartingDayOfWeek.monday,
        ),
      ],
    );
  }

  Map<DateTime, List<dynamic>> _groupEvents(List<EventModel> events) {
    Map<DateTime, List<dynamic>> data = {};
    events.forEach((event) {
      DateTime date = DateTime(
          event.eventDate.year, event.eventDate.month, event.eventDate.day, 12);
      if (data[date] == null) data[date] = [];
      data[date].add(event);
    });
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(171, 219, 209, 1),
      body: SafeArea(
        child: StreamBuilder<List<EventModel>>(
          stream: eventDBS.streamList(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<EventModel> allEvents = snapshot.data;
              if (allEvents.isNotEmpty) {
                _events = _groupEvents(allEvents);
              }
            }
            return Column(
              children: [
                createTitleBarWidget(context),
                _createCalendarView(),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddEventPage(eventDBS: eventDBS, date: _date),
          ),
        ),
      ),
    );
  }
}
