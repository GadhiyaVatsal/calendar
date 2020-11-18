import 'package:calendar/model/event.dart';
import 'package:calendar/ui/view_events.dart';
import 'package:calendar/utils/helper_widgets.dart';
import 'package:firebase_helpers/firebase_helpers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

// ignore: must_be_immutable
class EventView extends StatefulWidget {
  final DatabaseService<EventModel> eventDBS;
  final Map<DateTime, List<dynamic>> events;
  List<dynamic> selectedEvents;
  final DateTime day;

  EventView({this.eventDBS, this.events, this.selectedEvents, this.day});

  @override
  _EventViewState createState() => _EventViewState();
}

class _EventViewState extends State<EventView> {
  CalendarController _calendarController;

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
  }

  _createCalendarView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TableCalendar(
          events: widget.events,
          initialCalendarFormat: CalendarFormat.week,
          initialSelectedDay: widget.day,
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
              widget.selectedEvents = events;
            });
          },
          startingDayOfWeek: StartingDayOfWeek.monday,
        ),
        Container(
          margin: EdgeInsets.only(top: 5.0),
          height: MediaQuery.of(context).size.height - 263,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40.0),
              topRight: Radius.circular(40.0),
            ),
            color: Colors.white60,
          ),
          child: Padding(
            padding: EdgeInsets.only(top: 20.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ...widget.selectedEvents.map((e) {
                    return Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                        border: Border.all(color: Colors.black),
                        color: Colors.tealAccent,
                      ),
                      child: ListTile(
                        title: Text(e.title),
                        leading: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(e.eventTime),
                        ),
                        subtitle: Text(e.description),
                        /*onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        EventDetailsPage(
                                          event: e,
                                        ),
                                  ),
                                );
                              },*/
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(171, 219, 209, 1),
      body: SafeArea(
        child: StreamBuilder<List<EventModel>>(
          stream: widget.eventDBS.streamList(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<EventModel> allEvents = snapshot.data;
              if (allEvents.isNotEmpty) {
                //_events = _groupEvents(allEvents);
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
    );
  }
}
