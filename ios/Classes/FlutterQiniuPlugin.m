#import "FlutterQiniuPlugin.h"
#import <flutter_qiniu/flutter_qiniu-Swift.h>

@implementation FlutterQiniuPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterQiniuPlugin registerWithRegistrar:registrar];
}
@end
