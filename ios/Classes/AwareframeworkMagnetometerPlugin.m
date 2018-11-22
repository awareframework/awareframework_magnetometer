#import "AwareframeworkMagnetometerPlugin.h"
#import <awareframework_magnetometer/awareframework_magnetometer-Swift.h>

@implementation AwareframeworkMagnetometerPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftAwareframeworkMagnetometerPlugin registerWithRegistrar:registrar];
}
@end
