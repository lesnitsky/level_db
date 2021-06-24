#import "LevelDbPlugin.h"
#if __has_include(<level_db/level_db-Swift.h>)
#import <level_db/level_db-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "level_db-Swift.h"
#endif

@implementation LevelDbPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftLevelDbPlugin registerWithRegistrar:registrar];
}
@end
