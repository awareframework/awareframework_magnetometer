import 'dart:async';

import 'package:flutter/services.dart';
import 'package:awareframework_core/awareframework_core.dart';
import 'package:flutter/material.dart';

/// init sensor
class MagnetometerSensor extends AwareSensorCore {
  static const MethodChannel _magnetometerMethod = const MethodChannel('awareframework_magnetometer/method');
  static const EventChannel  _magnetometerStream  = const EventChannel('awareframework_magnetometer/event');

  /// Init Magnetometer Sensor with MagnetometerSensorConfig
  MagnetometerSensor(MagnetometerSensorConfig config):this.convenience(config);
  MagnetometerSensor.convenience(config) : super(config){
    super.setMethodChannel(_magnetometerMethod);
  }

  /// A sensor observer instance
  Stream<Map<String,dynamic>> get onDataChanged{
     return super.getBroadcastStream(_magnetometerStream, "on_data_changed").map((dynamic event) => Map<String,dynamic>.from(event));
  }

  @override
  void cancelAllEventChannels() {
    super.cancelBroadcastStream("on_data_changed");
  }
}

class MagnetometerSensorConfig extends AwareSensorConfig{
  MagnetometerSensorConfig();

  int frequency    = 5;
  double period    = 1.0;
  double threshold = 0.0;

  @override
  Map<String, dynamic> toMap() {
    var map = super.toMap();
    map['frequency'] = frequency;
    map['period']    = period;
    map['threshold'] = threshold;
    return map;
  }
}

/// Make an AwareWidget
class MagnetometerCard extends StatefulWidget {
  MagnetometerCard({Key key, @required this.sensor, this.bufferSize=299, this.height = 250.0}) : super(key: key);

  final MagnetometerSensor sensor;
  final double height;
  final int bufferSize;

  @override
  MagnetometerCardState createState() => new MagnetometerCardState();
}


class MagnetometerCardState extends State<MagnetometerCard> {

  List<LineSeriesData> dataLine1 = List<LineSeriesData>();
  List<LineSeriesData> dataLine2 = List<LineSeriesData>();
  List<LineSeriesData> dataLine3 = List<LineSeriesData>();

  @override
  void initState() {
    super.initState();
    // set observer
    widget.sensor.onDataChanged.listen((event) {
      setState((){
        if(event!=null){
          DateTime.fromMicrosecondsSinceEpoch(event['timestamp']);
          StreamLineSeriesChart.add(data:event['x'], into:dataLine1, id:"x", buffer: widget.bufferSize);
          StreamLineSeriesChart.add(data:event['y'], into:dataLine2, id:"y", buffer: widget.bufferSize);
          StreamLineSeriesChart.add(data:event['z'], into:dataLine3, id:"z", buffer: widget.bufferSize);
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
          height:widget.height,
          width: MediaQuery.of(context).size.width*0.8,
          child: new StreamLineSeriesChart(StreamLineSeriesChart.createTimeSeriesData(dataLine1, dataLine2, dataLine3)),
        ),
      title: "Magnetometer",
      sensor: widget.sensor
    );
  }

  @override
  void dispose() {
    print("called dispose!");
    super.dispose();
  }

}
