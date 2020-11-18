import 'package:flutter/material.dart';

class EventModel {
  final String id;
  final String title;
  final String description;
  final DateTime eventDate;
  final String eventTime;

  EventModel(
      {this.id, this.title, this.description, this.eventDate, this.eventTime});

  factory EventModel.fromMap(Map data) {
    return EventModel(
      title: data['title'],
      description: data['description'],
      eventDate: data['event_date'],
      eventTime: data['event_time'],
    );
  }

  factory EventModel.fromDS(String id, Map<String, dynamic> data) {
    return EventModel(
      id: id,
      title: data['title'],
      description: data['description'],
      eventDate: data['event_date'].toDate(),
      eventTime: data['event_time'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "title": title,
      "description": description,
      "event_date": eventDate,
      "event_time": eventTime,
      "id": id,
    };
  }
}
