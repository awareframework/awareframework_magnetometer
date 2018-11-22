import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:awareframework_magnetometer/awareframework_magnetometer.dart';
import 'package:awareframework_core/awareframework_core.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {

  MagnetometerSensor sensor;
  MagnetometerSensorConfig config;

  @override
  void initState() {
    super.initState();

    config = MagnetometerSensorConfig()
      ..debug = true;

    sensor = new MagnetometerSensor(config);

  }

  @override
  Widget build(BuildContext context) {


    return new MaterialApp(
      home: new Scaffold(
          appBar: new AppBar(
            title: const Text('Plugin Example App'),
          ),
          body: new MagnetometerCard(sensor: sensor,)
      ),
    );
  }
}