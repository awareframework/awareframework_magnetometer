import 'package:test/test.dart';

import 'package:awareframework_magnetometer/awareframework_magnetometer.dart';

void main(){
  test("test sensor config", (){

    var config = MagnetometerSensorConfig();

    expect(config.debug, false);

  });
}