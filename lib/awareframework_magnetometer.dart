import 'dart:async';

import 'package:flutter/services.dart';
import 'package:awareframework_core/awareframework_core.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

/// init sensor
class MagnetometerSensor extends AwareSensorCore {
  static const MethodChannel _magnetometerMethod = const MethodChannel('awareframework_magnetometer/method');
  static const EventChannel  _magnetometerStream  = const EventChannel('awareframework_magnetometer/event');

  /// Init Magnetometer Sensor with MagnetometerSensorConfig
  MagnetometerSensor(MagnetometerSensorConfig config):this.convenience(config);
  MagnetometerSensor.convenience(config) : super(config){
    /// Set sensor method & event channels
    super.setMethodChannel(_magnetometerMethod);
  }

  /// A sensor observer instance
  Stream<Map<String,dynamic>> onDataChanged(String id) {
     return super.getBroadcastStream(_magnetometerStream, "on_data_changed", id).map((dynamic event) => Map<String,dynamic>.from(event));
  }
}

class MagnetometerSensorConfig extends AwareSensorConfig{
  MagnetometerSensorConfig();

  /// TODO

  @override
  Map<String, dynamic> toMap() {
    var map = super.toMap();
    return map;
  }
}

/// Make an AwareWidget
class MagnetometerCard extends StatefulWidget {
  MagnetometerCard({Key key, @required this.sensor, this.cardId = "magnetometer_card", this.hight = 250.0}) : super(key: key);

  MagnetometerSensor sensor;
  String cardId;
  double hight;

  @override
  MagnetometerCardState createState() => new MagnetometerCardState();
}


class MagnetometerCardState extends State<MagnetometerCard> {

  List<LineSeriesData> dataLine1 = List<LineSeriesData>();
  List<LineSeriesData> dataLine2 = List<LineSeriesData>();
  List<LineSeriesData> dataLine3 = List<LineSeriesData>();
  int bufferSize = 299;

  @override
  void initState() {
    super.initState();
    // set observer
    widget.sensor.onDataChanged(widget.cardId).listen((event) {
      setState((){
        if(event!=null){
          DateTime.fromMicrosecondsSinceEpoch(event['timestamp']);
          StreamLineSeriesChart.add(data:event['x'], into:dataLine1, id:"x", buffer: bufferSize);
          StreamLineSeriesChart.add(data:event['y'], into:dataLine2, id:"y", buffer: bufferSize);
          StreamLineSeriesChart.add(data:event['z'], into:dataLine3, id:"z", buffer: bufferSize);
        }
      });
    }, onError: (dynamic error) {
        print('Received error: ${error.message}');
    });
    print(widget.sensor);
  }


  @override
  Widget build(BuildContext context) {
    return new AwareCard(
      contentWidget: SizedBox(
          height:widget.hight,
          width: MediaQuery.of(context).size.width*0.8,
          child: new StreamLineSeriesChart(StreamLineSeriesChart.createTimeSeriesData(dataLine1, dataLine2, dataLine3)),
        ),
      title: "Magnetometer",
      sensor: widget.sensor
    );
  }

  @override
  void dispose() {
    widget.sensor.cancelBroadcastStream(widget.cardId);
    super.dispose();
  }

}
