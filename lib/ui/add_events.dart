import 'package:calendar/model/event.dart';
import 'package:firebase_helpers/firebase_helpers.dart';
import 'package:flutter/material.dart';

class AddEventPage extends StatefulWidget {
  final DatabaseService<EventModel> eventDBS;
  final DateTime date;

  const AddEventPage({this.eventDBS, this.date});

  @override
  _AddEventPageState createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  EventModel note;
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  TextEditingController _title;
  TextEditingController _description;
  DateTime _eventDate;
  TimeOfDay _eventTime;
  String _eventTime1;
  final _formKey = GlobalKey<FormState>();
  final _key = GlobalKey<ScaffoldState>();
  bool processing;

  @override
  void initState() {
    super.initState();
    _title = TextEditingController(text: note != null ? note.title : "");
    _description =
        TextEditingController(text: note != null ? note.description : "");
    _eventDate = widget.date;
    _eventTime = TimeOfDay.now();
    //_eventTime1 = _eventTime.format(context);
    processing = false;
    //print("Selected day : ${widget.date.day}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(note != null ? "Edit Note" : "Add note"),
      ),
      key: _key,
      body: Form(
        key: _formKey,
        child: Container(
          alignment: Alignment.center,
          child: ListView(
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: TextFormField(
                  controller: _title,
                  validator: (value) =>
                      (value.isEmpty) ? "Please Enter title" : null,
                  style: style,
                  decoration: InputDecoration(
                      labelText: "Title",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: TextFormField(
                  controller: _description,
                  minLines: 3,
                  maxLines: 5,
                  validator: (value) =>
                      (value.isEmpty) ? "Please Enter description" : null,
                  style: style,
                  decoration: InputDecoration(
                      labelText: "description",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
              ),
              SizedBox(height: 10.0),
              ListTile(
                title: Text("Date (YYYY-MM-DD)"),
                subtitle: Text(
                    "${_eventDate.year} - ${_eventDate.month} - ${_eventDate.day}"),
                onTap: () async {
                  DateTime picked = await showDatePicker(
                      context: context,
                      initialDate: widget.date,
                      firstDate: DateTime(_eventDate.year - 5),
                      lastDate: DateTime(_eventDate.year + 5));
                  if (picked != null) {
                    setState(() {
                      _eventDate = picked;
                    });
                  } else {
                    setState(() {
                      _eventDate = widget.date;
                    });
                  }
                },
              ),
              SizedBox(height: 10.0),
              ListTile(
                title: Text("Time (hh:mm)"),
                subtitle: Text("${_eventTime.hour} : ${_eventTime.minute}"),
                onTap: () async {
                  TimeOfDay picked = await showTimePicker(
                      context: context,
                      initialTime: _eventTime,
                      builder: (BuildContext context, Widget child) {
                        return MediaQuery(
                          data: MediaQuery.of(context)
                              .copyWith(alwaysUse24HourFormat: false),
                          child: child,
                        );
                      });
                  if (picked == null) {
                    setState(() {
                      _eventTime1 = _eventTime.format(context);
                    });
                  } else {
                    setState(() {
                      _eventTime = picked;
                      _eventTime1 = picked.format(context);
                    });
                  }
                },
              ),
              SizedBox(height: 10.0),
              processing
                  ? Center(child: CircularProgressIndicator())
                  : Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Material(
                        elevation: 5.0,
                        borderRadius: BorderRadius.circular(30.0),
                        color: Theme.of(context).primaryColor,
                        child: MaterialButton(
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              setState(() {
                                processing = true;
                              });
                              if (note != null) {
                                await widget.eventDBS.updateData(note.id, {
                                  "title": _title.text,
                                  "description": _description.text,
                                  "event_date": _eventDate,
                                  //"event_time": "${_eventTime.hour} : ${_eventTime.minute}",
                                  "event_time": _eventTime1,
                                });
                              } else {
                                await widget.eventDBS.create({
                                  "title": _title.text,
                                  "description": _description.text,
                                  "event_date": _eventDate,
                                  //"event_time": "${_eventTime.hour} : ${_eventTime.minute}",
                                  "event_time": _eventTime1,
                                });
                              }
                              Navigator.pop(context);
                              setState(() {
                                processing = false;
                              });
                            }
                          },
                          child: Text(
                            "Save",
                            style: style.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    super.dispose();
  }
}
