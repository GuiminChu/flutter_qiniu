#import "FlutterQiniuPlugin.h"
#if __has_include(<flutter_qiniu/flutter_qiniu-Swift.h>)
#import <flutter_qiniu/flutter_qiniu-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flutter_qiniu-Swift.h"
#endif

@implementation FlutterQiniuPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterQiniuPlugin registerWithRegistrar:registrar];
}
@end
