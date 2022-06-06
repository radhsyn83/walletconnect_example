import 'package:flutter/services.dart';

const EventChannel channel = EventChannel("flutter.native/event");

Stream<String>? _eventStreams;

Stream<String> get eventData {
  _eventStreams ??= channel.receiveBroadcastStream().map((event) => event);
  return _eventStreams!;
}
