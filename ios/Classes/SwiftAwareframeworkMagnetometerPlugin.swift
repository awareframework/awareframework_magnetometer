import Flutter
import UIKit
import SwiftyJSON
import com_awareframework_ios_sensor_magnetometer
import com_awareframework_ios_sensor_core
import awareframework_core

public class SwiftAwareframeworkMagnetometerPlugin: AwareFlutterPluginCore, FlutterPlugin, AwareFlutterPluginSensorInitializationHandler, MagnetometerObserver{

    var magnetometerSensor:MagnetometerSensor?
    
    public func initializeSensor(_ call: FlutterMethodCall, result: @escaping FlutterResult) -> AwareSensor? {
        if self.sensor == nil {
            if let config = call.arguments as? Dictionary<String,Any>{
                let json = JSON.init(config)
                self.magnetometerSensor = MagnetometerSensor.init(MagnetometerSensor.Config(json))
            }else{
                self.magnetometerSensor = MagnetometerSensor.init(MagnetometerSensor.Config())
            }
            self.magnetometerSensor?.CONFIG.sensorObserver = self
            return self.magnetometerSensor
        }else{
            return nil
        }
    }


    public override init() {
        super.init()
        super.initializationCallEventHandler = self
    }

    public static func register(with registrar: FlutterPluginRegistrar) {
        // add own channel
        super.setChannels(with: registrar,
                          instance: SwiftAwareframeworkMagnetometerPlugin(),
                          methodChannelName: "awareframework_magnetometer/method",
                          eventChannelName: "awareframework_magnetometer/event")

    }


    public func onDataChanged(data: MagnetometerData) {
        for handler in self.streamHandlers {
            if handler.eventName == "on_data_changed" {
                handler.eventSink(data.toDictionary())
            }
        }
    }
}
