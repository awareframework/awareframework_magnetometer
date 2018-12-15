import Flutter
import UIKit
import com_awareframework_ios_sensor_magnetometer
import com_awareframework_ios_sensor_core
import awareframework_core

public class SwiftAwareframeworkMagnetometerPlugin: AwareFlutterPluginCore, FlutterPlugin, AwareFlutterPluginSensorInitializationHandler, MagnetometerObserver{

    var magnetometerSensor:MagnetometerSensor?
    
    public func initializeSensor(_ call: FlutterMethodCall, result: @escaping FlutterResult) -> AwareSensor? {
        if self.sensor == nil {
            if let config = call.arguments as? Dictionary<String,Any>{
                self.magnetometerSensor = MagnetometerSensor.init(MagnetometerSensor.Config(config))
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
        let instance = SwiftAwareframeworkMagnetometerPlugin()
        
        super.setMethodChannel(with: registrar,
                               instance: instance,
                               channelName: "awareframework_magnetometer/method")
        super.setEventChannels(with: registrar,
                               instance: instance,
                               channelNames:["awareframework_magnetometer/event",
                                             "awareframework_magnetometer/event_on_data_changed"])
    }


    public func onDataChanged(data: MagnetometerData) {
        for handler in self.streamHandlers {
            if handler.eventName == "on_data_changed" {
                handler.eventSink(data.toDictionary())
            }
        }
    }
}
